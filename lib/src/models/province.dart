import 'package:vietnam_provinces/src/models/district.dart';
import 'package:vietnam_provinces/src/models/ward.dart';

/// Represents a province.
class Province {
  /// The unique code of the province.
  final int code;

  /// The name of the province.
  final String name;

  /// The list of districts within the province.
  /// This is only available in v1 (3-level structure).
  /// For v2 (2-level structure), this will be an empty list.
  final List<District> districts;

  /// The list of wards directly under the province.
  /// This is only available in v2 (2-level structure).
  /// For v1 (3-level structure), this will be an empty list.
  final List<Ward> wards;

  /// Creates a new [Province] instance.
  Province({
    required this.code,
    required this.name,
    this.districts = const [],
    this.wards = const [],
  });

  /// Creates a new [Province] instance from a JSON object.
  /// Supports both v1 (3-level) and v2 (2-level) structures.
  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      code: json['code'],
      name: json['name'],
      districts: json['districts'] != null
          ? (json['districts'] as List)
              .map((district) => District.fromJson(district))
              .toList()
          : [],
      wards: json['wards'] != null
          ? (json['wards'] as List).map((ward) => Ward.fromJson(ward)).toList()
          : [],
    );
  }
}
