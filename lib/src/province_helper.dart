import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

import 'administrative_division_version.dart';
import 'models/province.dart';

/// Helper class for loading province data.
class ProvinceHelper {
  /// Loads the list of provinces from a compressed JSON file.
  ///
  /// The [version] parameter determines which administrative division structure to load:
  /// - [AdministrativeDivisionVersion.v1]: 3-level structure (Province > District > Ward)
  /// - [AdministrativeDivisionVersion.v2]: 2-level structure (Province > Ward)
  static Future<List<Province>> loadProvinces(
      AdministrativeDivisionVersion version) async {
    try {
      final fileName = version == AdministrativeDivisionVersion.v1
          ? 'provinces-v1.json.gz'
          : 'provinces-v2.json.gz';
      final filePath = 'packages/vietnam_provinces/lib/assets/$fileName';

      final compressedData = await rootBundle.load(filePath);
      final jsonData =
          utf8.decode(gzip.decode(compressedData.buffer.asUint8List()));
      final List<dynamic> jsonList = jsonDecode(jsonData);

      return jsonList.map((json) => Province.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error loading provinces: $e');
    }
  }
}
