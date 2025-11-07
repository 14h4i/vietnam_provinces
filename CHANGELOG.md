## 2.0.0

- **BREAKING CHANGE**: Added support for both v1 (3-level) and v2 (2-level) administrative division structures.
- Added `AdministrativeDivisionVersion` enum to specify the version (v1 or v2).
- Updated `initialize()` method to accept a `version` parameter (defaults to v2).
- Updated `Province` model to support both `districts` (v1) and `wards` (v2) structures.
- Updated `getWards()` method to work with both versions:
  - v1: Requires both `provinceCode` and `districtCode`
  - v2: Requires only `provinceCode`, `districtCode` is optional
- Added `provinces-v1.json.gz` for 3-level structure (before July 2025).
- Added `provinces-v2.json.gz` for 2-level structure (from July 2025 onwards).
- Updated example app to demonstrate both versions with a version switcher.
- Updated documentation with usage examples for both versions.

## 1.0.2

- Update documents.
- Optimize library size.
- Optimize package.

## 1.0.1

- Add Demo Gif

## 1.0.0

- Initial release.
- Features:
  - Search provinces, districts, and wards by name or code.
