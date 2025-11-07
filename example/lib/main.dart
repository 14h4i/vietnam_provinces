import 'package:flutter/material.dart';
import 'package:vietnam_provinces/vietnam_provinces.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize with v2 by default (2-level structure)
  await VietnamProvinces.initialize(version: AdministrativeDivisionVersion.v2);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vietnam Provinces Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Province? selectedProvince;
  District? selectedDistrict;
  Ward? selectedWard;

  List<Province> filteredProvinces = [];
  List<District> filteredDistricts = [];
  List<Ward> filteredWards = [];

  AdministrativeDivisionVersion currentVersion =
      AdministrativeDivisionVersion.v2;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    filteredProvinces = VietnamProvinces.getProvinces();
    currentVersion = VietnamProvinces.version;
  }

  Future<void> switchVersion(AdministrativeDivisionVersion newVersion) async {
    if (newVersion == currentVersion) return;

    setState(() {
      isLoading = true;
      selectedProvince = null;
      selectedDistrict = null;
      selectedWard = null;
      filteredDistricts = [];
      filteredWards = [];
    });

    await VietnamProvinces.initialize(version: newVersion);

    setState(() {
      currentVersion = newVersion;
      filteredProvinces = VietnamProvinces.getProvinces();
      isLoading = false;
    });
  }

  void updateFilteredProvinces(String query) {
    selectedProvince = null;
    selectedDistrict = null;
    selectedWard = null;
    filteredWards = [];
    filteredDistricts = [];
    setState(() {
      filteredProvinces = VietnamProvinces.getProvinces(query: query);
    });
  }

  void updateFilteredDistricts(String query) {
    selectedDistrict = null;
    selectedWard = null;
    filteredWards = [];
    if (selectedProvince != null) {
      setState(() {
        filteredDistricts = VietnamProvinces.getDistricts(
          provinceCode: selectedProvince!.code,
          query: query,
        );
      });
    }
  }

  void updateFilteredWards(String query) {
    selectedWard = null;
    if (currentVersion == AdministrativeDivisionVersion.v2) {
      // For v2, wards are directly under province
      if (selectedProvince != null) {
        setState(() {
          filteredWards = VietnamProvinces.getWards(
            provinceCode: selectedProvince!.code,
            query: query,
          );
        });
      }
    } else {
      // For v1, wards are under district
      if (selectedDistrict != null) {
        setState(() {
          filteredWards = VietnamProvinces.getWards(
            provinceCode: selectedProvince!.code,
            districtCode: selectedDistrict!.code,
            query: query,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vietnam Provinces Picker'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Text(
                currentVersion == AdministrativeDivisionVersion.v1
                    ? '3-Level (v1)'
                    : '2-Level (v2)',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Version Selector
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Administrative Division Version',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child:
                                SegmentedButton<AdministrativeDivisionVersion>(
                              segments: const [
                                ButtonSegment<AdministrativeDivisionVersion>(
                                  value: AdministrativeDivisionVersion.v1,
                                  label: Text('v1 (3-Level)'),
                                  icon: Icon(Icons.account_tree),
                                ),
                                ButtonSegment<AdministrativeDivisionVersion>(
                                  value: AdministrativeDivisionVersion.v2,
                                  label: Text('v2 (2-Level)'),
                                  icon: Icon(Icons.layers),
                                ),
                              ],
                              selected: {currentVersion},
                              onSelectionChanged:
                                  (Set<AdministrativeDivisionVersion>
                                      newSelection) {
                                switchVersion(newSelection.first);
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentVersion == AdministrativeDivisionVersion.v1
                                ? 'Province > District > Ward (Before July 2025)'
                                : 'Province > Ward (From July 2025)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Province Selector
                  buildDropdownSection(
                    title: "Select Province",
                    hintText: "Search for a province",
                    items: filteredProvinces.map((p) => p.name).toList(),
                    onSearchChanged: updateFilteredProvinces,
                    currentValueSelected: selectedProvince?.name,
                    onItemSelected: (value) {
                      setState(() {
                        selectedProvince = filteredProvinces
                            .firstWhere((p) => p.name == value);
                        selectedDistrict = null;
                        selectedWard = null;

                        if (currentVersion ==
                            AdministrativeDivisionVersion.v1) {
                          // For v1, load districts
                          filteredDistricts = VietnamProvinces.getDistricts(
                            provinceCode: selectedProvince!.code,
                          );
                          filteredWards = [];
                        } else {
                          // For v2, load wards directly
                          filteredDistricts = [];
                          filteredWards = VietnamProvinces.getWards(
                            provinceCode: selectedProvince!.code,
                          );
                        }
                      });
                    },
                  ),

                  // District Selector (only for v1)
                  if (selectedProvince != null &&
                      currentVersion == AdministrativeDivisionVersion.v1)
                    buildDropdownSection(
                      title: "Select District",
                      hintText: "Search for a district",
                      items: filteredDistricts.map((d) => d.name).toList(),
                      onSearchChanged: updateFilteredDistricts,
                      currentValueSelected: selectedDistrict?.name,
                      onItemSelected: (value) {
                        setState(() {
                          selectedDistrict = filteredDistricts
                              .firstWhere((d) => d.name == value);
                          selectedWard = null;
                          filteredWards = VietnamProvinces.getWards(
                            provinceCode: selectedProvince!.code,
                            districtCode: selectedDistrict!.code,
                          );
                        });
                      },
                    ),

                  // Ward Selector
                  if ((currentVersion == AdministrativeDivisionVersion.v2 &&
                          selectedProvince != null) ||
                      (currentVersion == AdministrativeDivisionVersion.v1 &&
                          selectedDistrict != null))
                    buildDropdownSection(
                      title: "Select Ward",
                      hintText: "Search for a ward",
                      items: filteredWards.map((w) => w.name).toList(),
                      onSearchChanged: updateFilteredWards,
                      currentValueSelected: selectedWard?.name,
                      onItemSelected: (value) {
                        setState(() {
                          selectedWard =
                              filteredWards.firstWhere((w) => w.name == value);
                        });
                      },
                    ),

                  // Selection Result
                  if (selectedWard != null)
                    Card(
                      color: Colors.blue.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Selected Address:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                currentVersion ==
                                        AdministrativeDivisionVersion.v1
                                    ? "${selectedWard?.name} - ${selectedDistrict?.name} - ${selectedProvince?.name}"
                                    : "${selectedWard?.name} - ${selectedProvince?.name}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget buildDropdownSection({
    required String title,
    required String hintText,
    required List<String> items,
    required void Function(String query) onSearchChanged,
    required void Function(String selectedItem) onItemSelected,
    required String? currentValueSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onChanged: onSearchChanged,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: currentValueSelected,
            isExpanded: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
            ),
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(item, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) onItemSelected(value);
            },
          ),
        ],
      ),
    );
  }
}
