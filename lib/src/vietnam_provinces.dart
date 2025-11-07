library vietnam_provinces;

import 'administrative_division_version.dart';
import 'models/district.dart';
import 'models/province.dart';
import 'models/ward.dart';
import 'province_helper.dart';
import 'utils.dart';

/// A library for managing Vietnamese provinces, districts, and wards.
/// Supports both v1 (3-level) and v2 (2-level) administrative division structures.
class VietnamProvinces {
  static late List<Province> _provinces;
  static late AdministrativeDivisionVersion _version;

  /// Initializes the plugin by loading province data.
  ///
  /// The [version] parameter determines which administrative division structure to load:
  /// - [AdministrativeDivisionVersion.v1]: 3-level structure (Province > District > Ward) - used before July 2025
  /// - [AdministrativeDivisionVersion.v2]: 2-level structure (Province > Ward) - used from July 2025 onwards
  ///
  /// Defaults to [AdministrativeDivisionVersion.v2] if not specified.
  static Future<void> initialize({
    AdministrativeDivisionVersion version = AdministrativeDivisionVersion.v2,
  }) async {
    _version = version;
    _provinces = await ProvinceHelper.loadProvinces(version);
  }

  /// Gets the current administrative division version being used.
  static AdministrativeDivisionVersion get version => _version;

  /// Gets the list of provinces.
  ///
  /// Optionally filters by [code] or [query].
  static List<Province> getProvinces({int? code, String? query}) {
    return _provinces.where((province) {
      final matchesCode = code == null || province.code == code;

      final normalizedQuery = query != null ? removeDiacritics(query) : null;
      final normalizedProvinceName = removeDiacritics(province.name);

      final matchesQuery = normalizedQuery == null ||
          normalizedProvinceName.contains(normalizedQuery);
      return matchesCode && matchesQuery;
    }).toList();
  }

  /// Gets the list of districts by province code.
  ///
  /// Optionally filters by [query].
  ///
  /// Note: This method is only applicable for v1 (3-level structure).
  /// For v2 (2-level structure), this will return an empty list.
  static List<District> getDistricts(
      {required int provinceCode, String? query}) {
    if (_version == AdministrativeDivisionVersion.v2) {
      return [];
    }

    final province = _provinces.firstWhere(
      (p) => p.code == provinceCode,
      orElse: () =>
          throw ArgumentError('Province with code $provinceCode not found'),
    );

    return province.districts.where((district) {
      final normalizedQuery = query != null ? removeDiacritics(query) : null;
      final normalizedDistrictName = removeDiacritics(district.name);

      final matchesQuery = normalizedQuery == null ||
          normalizedDistrictName.contains(normalizedQuery);
      return matchesQuery;
    }).toList();
  }

  /// Gets the list of wards.
  ///
  /// For v1 (3-level structure): requires both [provinceCode] and [districtCode]
  /// For v2 (2-level structure): requires only [provinceCode], [districtCode] is ignored
  ///
  /// Optionally filters by [query].
  static List<Ward> getWards({
    required int provinceCode,
    int? districtCode,
    String? query,
  }) {
    final province = _provinces.firstWhere(
      (p) => p.code == provinceCode,
      orElse: () =>
          throw ArgumentError('Province with code $provinceCode not found'),
    );

    List<Ward> wards;

    if (_version == AdministrativeDivisionVersion.v2) {
      // For v2, wards are directly under province
      wards = province.wards;
    } else {
      // For v1, wards are under districts
      if (districtCode == null) {
        throw ArgumentError(
            'districtCode is required for v1 administrative division structure');
      }

      final district = province.districts.firstWhere(
        (d) => d.code == districtCode,
        orElse: () =>
            throw ArgumentError('District with code $districtCode not found'),
      );

      wards = district.wards;
    }

    return wards.where((ward) {
      final normalizedQuery = query != null ? removeDiacritics(query) : null;
      final normalizedWardName = removeDiacritics(ward.name);

      final matchesQuery = normalizedQuery == null ||
          normalizedWardName.contains(normalizedQuery);
      return matchesQuery;
    }).toList();
  }
}
