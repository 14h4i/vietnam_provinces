# Vietnam Provinces

[![Pub](https://img.shields.io/pub/v/vietnam_provinces.svg)](https://pub.dev/packages/vietnam_provinces)

[English](README.md) | **Tiếng Việt**

Package Flutter để quản lý đơn vị hành chính Việt Nam: tỉnh/thành phố, quận/huyện, và phường/xã.

Hỗ trợ cả **v1 (cấu trúc 3 cấp)** và **v2 (cấu trúc 2 cấp)** đơn vị hành chính.

<p align="center">
  <img src="https://raw.githubusercontent.com/14h4i/vietnam_provinces/main/resources/v1.png" width="300" />
  <img src="https://raw.githubusercontent.com/14h4i/vietnam_provinces/main/resources/v2.png" width="300" />
</p>

<p align="center">
  <i>Trái: v1 (cấu trúc 3 cấp) | Phải: v2 (cấu trúc 2 cấp)</i>
</p>

## 📄 Nguồn dữ liệu

Dữ liệu cho package này được lấy từ [Vietnam Provinces Open API](https://provinces.open-api.vn)

## ✨ Tính năng

- Lấy danh sách tỉnh/thành phố, quận/huyện, và phường/xã.
- Tìm kiếm theo tên hoặc mã.
- Hỗ trợ cả 2 phiên bản đơn vị hành chính:
  - **v1 (3 cấp)**: Tỉnh/Thành phố > Quận/Huyện > Phường/Xã (sử dụng trước tháng 7/2025)
  - **v2 (2 cấp)**: Tỉnh/Thành phố > Phường/Xã (sử dụng từ tháng 7/2025 trở đi)
- Nhẹ và dễ tích hợp.

## 🚀 Bắt đầu

1. Thêm package vào `pubspec.yaml`:

   ```yaml
   dependencies:
     vietnam_provinces: ^2.0.0
   ```

2. Khởi tạo dữ liệu trong ứng dụng:

   ```dart
   import 'package:vietnam_provinces/vietnam_provinces.dart';

   void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Khởi tạo với v2 (cấu trúc 2 cấp) - mặc định
    await VietnamProvinces.initialize(version: AdministrativeDivisionVersion.v2);
    
    // Hoặc khởi tạo với v1 (cấu trúc 3 cấp)
    // await VietnamProvinces.initialize(version: AdministrativeDivisionVersion.v1);
   }
   ```

## 🔧 Cách sử dụng

### Phiên bản 2 (Cấu trúc 2 cấp: Tỉnh/Thành phố > Phường/Xã)

**Sử dụng từ tháng 7/2025 trở đi**

- **Lấy danh sách tỉnh/thành phố hoặc tìm kiếm:**

  ```dart
  final provinces = VietnamProvinces.getProvinces(code: 1);
  ```

  ```dart
  final provinces = VietnamProvinces.getProvinces(query: "Hà");
  ```

- **Lấy danh sách phường/xã trực tiếp theo mã tỉnh/thành phố:**

  ```dart
  final wards = VietnamProvinces.getWards(
    provinceCode: 1,
    query: "Phường",
  );
  ```

### Phiên bản 1 (Cấu trúc 3 cấp: Tỉnh/Thành phố > Quận/Huyện > Phường/Xã)

**Sử dụng trước tháng 7/2025**

- **Lấy danh sách tỉnh/thành phố hoặc tìm kiếm:**

  ```dart
  final provinces = VietnamProvinces.getProvinces(code: 1);
  ```

  ```dart
  final provinces = VietnamProvinces.getProvinces(query: "Hà");
  ```

- **Lấy danh sách quận/huyện theo mã tỉnh/thành phố:**

  ```dart
  final districts = VietnamProvinces.getDistricts(
    provinceCode: 1,
    query: "Quận",
  );
  ```

- **Lấy danh sách phường/xã theo mã tỉnh/thành phố và mã quận/huyện:**

  ```dart
  final wards = VietnamProvinces.getWards(
    provinceCode: 1,
    districtCode: 10,
    query: "Phường",
  );
  ```

## 📱 Ví dụ

Để xem `vietnam_provinces` hoạt động, hãy xem project ví dụ tại [example](https://github.com/14h4i/vietnam_provinces/blob/master/example/lib/main.dart).

Ứng dụng ví dụ minh họa cả 2 cấu trúc đơn vị hành chính v1 và v2 với chức năng chuyển đổi phiên bản.

## 🛠️ Đóng góp

Chúng tôi hoan nghênh mọi đóng góp! Nếu bạn có ý tưởng về tính năng, sửa lỗi hoặc cải tiến, hãy thoải mái mở issue hoặc gửi pull request.

## 🐞 Vấn đề và phản hồi

Vui lòng tạo [issues](https://github.com/14h4i/vietnam_provinces/issues) để gửi phản hồi hoặc báo cáo lỗi. Cảm ơn bạn!

## 📜 Giấy phép

[MIT](https://mit-license.org) License

<a href="https://www.buymeacoffee.com/14h4i" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>
