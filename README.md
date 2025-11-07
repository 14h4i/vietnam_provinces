# Vietnam Provinces

[![Pub](https://img.shields.io/pub/v/vietnam_provinces.svg)](https://pub.dev/packages/vietnam_provinces)

**English** | [Tiếng Việt](README_vi.md)

A Flutter package for managing Vietnam's administrative divisions: provinces, districts, and wards.

Supports both **v1 (3-level structure)** and **v2 (2-level structure)** administrative divisions.

<p align="center">
  <img src="https://raw.githubusercontent.com/14h4i/vietnam_provinces/main/resources/v1.png" width="300" />
  <img src="https://raw.githubusercontent.com/14h4i/vietnam_provinces/main/resources/v2.png" width="300" />
</p>

<p align="center">
  <i>Left: v1 (3-level structure) | Right: v2 (2-level structure)</i>
</p>

## 📄 Data source

The data for this package is sourced from the [Vietnam Provinces Open API](https://provinces.open-api.vn)

## ✨ Features

- Retrieve provinces, districts, and wards.
- Search by name (query) or code.
- Support for both administrative division versions:
  - **v1 (3-level)**: Province > District > Ward (used before July 2025)
  - **v2 (2-level)**: Province > Ward (used from July 2025 onwards)
- Lightweight and simple to integrate.

## 🚀 Getting Started

1. Add the package to your `pubspec.yaml`:

   ```yaml
   dependencies:
     vietnam_provinces: ^1.0.2
   ```

2. Load the data in your app:

   ```dart
   import 'package:vietnam_provinces/vietnam_provinces.dart';

   void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize with v2 (2-level structure) - default
    await VietnamProvinces.initialize(version: AdministrativeDivisionVersion.v2);
    
    // Or initialize with v1 (3-level structure)
    // await VietnamProvinces.initialize(version: AdministrativeDivisionVersion.v1);
   }
   ```

## 🔧 Usage

### Version 2 (2-Level Structure: Province > Ward)

**Used from July 2025 onwards**

- **Get provinces or query:**

  ```dart
  final provinces = VietnamProvinces.getProvinces(code: 1);
  ```

  ```dart
  final provinces = VietnamProvinces.getProvinces(query: "Hà");
  ```

- **Get wards directly by province code:**

  ```dart
  final wards = VietnamProvinces.getWards(
    provinceCode: 1,
    query: "Phường",
  );
  ```

### Version 1 (3-Level Structure: Province > District > Ward)

**Used before July 2025**

- **Get provinces or query:**

  ```dart
  final provinces = VietnamProvinces.getProvinces(code: 1);
  ```

  ```dart
  final provinces = VietnamProvinces.getProvinces(query: "Hà");
  ```

- **Get districts by province code:**

  ```dart
  final districts = VietnamProvinces.getDistricts(
    provinceCode: 1,
    query: "Quận",
  );
  ```

- **Get wards by province code and district code:**

  ```dart
  final wards = VietnamProvinces.getWards(
    provinceCode: 1,
    districtCode: 10,
    query: "Phường",
  );
  ```

## 📱 Example

To see `vietnam_provinces` in action, check out the example project in the [example](https://github.com/14h4i/vietnam_provinces/blob/master/example/lib/main.dart).

The example app demonstrates both v1 and v2 administrative division structures with a version switcher.

## 🛠️ Contributions

We welcome contributions! If you have ideas for features, bug fixes, or improvements, feel free to open an issue or submit a pull request.

## 🐞 Issues and feedback

Please file [issues](https://github.com/14h4i/vietnam_provinces/issues) to send feedback or report a bug. Thank you!

## 📜 License

[MIT](https://mit-license.org) License

<a href="https://www.buymeacoffee.com/14h4i" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>
