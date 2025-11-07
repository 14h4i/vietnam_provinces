/// Represents the version of Vietnam's administrative division structure.
///
/// - [v1]: 3-level structure (Province > District > Ward) - used before July 2025
/// - [v2]: 2-level structure (Province > Ward) - used from July 2025 onwards
enum AdministrativeDivisionVersion {
  /// 3-level administrative division structure (Province > District > Ward)
  /// Used before July 2025
  v1,

  /// 2-level administrative division structure (Province > Ward)
  /// Used from July 2025 onwards after administrative consolidation
  v2,
}
