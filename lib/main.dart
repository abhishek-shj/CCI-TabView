import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
import 'dart:math' as math;

// Helper function for clamping double values
double clampDouble(double x, double min, double max) {
  return math.max(min, math.min(max, x));
}

// Data model for training cards
class TrainingData {
  final String title;
  final String message;
  final String companyName;
  final String user;
  final String date;
  final String status;
  final String department;  // Added for department filtering


  TrainingData({
    required this.title,
    required this.message,
    required this.companyName,
    required this.user,
    required this.date,
    required this.status,
    this.department = '',  // Default empty string

  });
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFFCFCF6),
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SearchScreen(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor:
            clampDouble(MediaQuery.of(context).textScaleFactor, 0.8, 1.4),
          ),
          child: child!,
        );
      },
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Main filters used to render data.
  Map<String, dynamic> selectedFilters = {
    'Company': <String>[],
    'Dealerships': <String>[],
    'Department': <String>[],
    'User': <String>[],
    'Date Range': '', // Keep this as String since it's not multi-select
  };

  final List<Map<String, dynamic>> statusTabs = [
    {
      "title": "Scheduled",
      "imagePath": "assets/images/scheduled_icon.png",
      "count": 3,
    },
    {
      "title": "In-Progress",
      "imagePath": "assets/images/inprocess_icon.png",
      "count": 4,
    },
    {
      "title": "Overdue",
      "imagePath": "assets/images/Overdue_icon.png",
      "count": 2,
    },
    {
      "title": "Failed",
      "imagePath": "assets/images/failed_icon.png",
      "count": 3,
    },
    {
      "title": "Expired",
      "imagePath": "assets/images/Expired_icon.png",
      "count": 2,
    },
    {
      "title": "Passed",
      "imagePath": "assets/images/passed_icon.png",
      "count": 4,
    },
  ];

  final Map<String, List<String>> filterOptions = {
    'Company': ['Shealey Truck Center', 'LoadMe'],
    'Dealerships': ['Columbia', 'Charleston', 'Greenville'],
    'Department': ['All Departments', 'Sales', 'Service', 'Parts', 'Administration'],
    'User': ["john", "abhishek", "miguel", "lisa", "james"],
    'Date Range': ['Last 7 Days', 'Last 30 Days', 'Last 90 Days', 'Custom Range'],
  };

  final Map<String, List<TrainingData>> trainingDataByStatus = {
    "Scheduled": [
      TrainingData(
        title: "NEW VEHICLE TECHNOLOGY TRAINING",
        message: "Overview of latest automotive technologies and systems...",
        companyName: "LoadMe",
        user: "john",
        date: "03/15/2025",
        status: "Scheduled",
      ),
      TrainingData(
        title: "ELECTRIC VEHICLE MAINTENANCE",
        message: "Comprehensive training on EV systems and servicing...",
        companyName: "Shealey Truck Center",
        user: "abhishek",
        date: "03/20/2025",
        status: "Scheduled",
      ),
      TrainingData(
        title: "DIAGNOSTIC TOOLS WORKSHOP",
        message: "Hands-on training with new diagnostic equipment...",
        companyName: "Shealey Truck Center",
        user: "miguel",
        date: "03/25/2025",
        status: "Scheduled",
      ),
    ],
    "In-Progress": [
      TrainingData(
        title: "REGULATORY COMPLIANCE IN DEALERSHIP",
        message: "Training on local, state, and federal regulations...",
        companyName: "LoadMe",
        user: "lisa",
        date: "02/28/2025",
        status: "In-Progress",
      ),
      TrainingData(
        title: "SAFETY PROTOCOLS AND PROCEDURES",
        message: "Comprehensive training on workplace safety standards...",
        companyName: "Shealey Truck Center",
        user: "james",
        date: "02/25/2025",
        status: "In-Progress",
      ),
      TrainingData(
        title: "CUSTOMER SERVICE EXCELLENCE",
        message: "Interactive workshop on effective communication...",
        companyName: "Shealey Truck Center",
        user: "john",
        date: "02/20/2025",
        status: "In-Progress",
      ),
      TrainingData(
        title: "INVENTORY MANAGEMENT SYSTEMS",
        message: "Hands-on training for using the new inventory tracking software...",
        companyName: "Shealey Truck Center",
        user: "abhishek",
        date: "02/15/2025",
        status: "In-Progress",
      ),
    ],
    "Overdue": [
      TrainingData(
        title: "ANNUAL SAFETY CERTIFICATION",
        message: "Mandatory safety certification renewal...",
        companyName: "Shealey Truck Center",
        user: "miguel",
        date: "01/15/2025",
        status: "Overdue",
      ),
      TrainingData(
        title: "HAZMAT HANDLING PROCEDURES",
        message: "Required training for hazardous materials handling...",
        companyName: "Shealey Truck Center",
        user: "lisa",
        date: "01/10/2025",
        status: "Overdue",
      ),
    ],
    "Failed": [
      TrainingData(
        title: "ADVANCED DIAGNOSTICS CERTIFICATION",
        message: "Certification program for advanced diagnostic techniques...",
        companyName: "Shealey Truck Center",
        user: "james",
        date: "01/05/2025",
        status: "Failed",
      ),
      TrainingData(
        title: "PARTS INVENTORY MANAGEMENT",
        message: "Training on new parts management system...",
        companyName: "Shealey Truck Center",
        user: "john",
        date: "01/02/2025",
        status: "Failed",
      ),
      TrainingData(
        title: "CUSTOMER DATA PROTECTION",
        message: "Training on privacy regulations and data handling...",
        companyName: "Shealey Truck Center",
        user: "abhishek",
        date: "12/28/2024",
        status: "Failed",
      ),
    ],
    "Expired": [
      TrainingData(
        title: "SEASONAL MAINTENANCE PROCEDURES",
        message: "Training on seasonal vehicle maintenance requirements...",
        companyName: "Shealey Truck Center",
        user: "miguel",
        date: "12/15/2024",
        status: "Expired",
      ),
      TrainingData(
        title: "WARRANTY PROCESSING",
        message: "Training on warranty claim procedures...",
        companyName: "Shealey Truck Center",
        user: "lisa",
        date: "12/10/2024",
        status: "Expired",
      ),
    ],
    "Passed": [
      TrainingData(
        title: "BASIC VEHICLE MAINTENANCE",
        message: "Fundamental vehicle maintenance procedures...",
        companyName: "Shealey Truck Center",
        user: "james",
        date: "02/01/2025",
        status: "Passed",
      ),
      TrainingData(
        title: "SALES TECHNIQUES AND STRATEGIES",
        message: "Advanced training on consultative selling approaches...",
        companyName: "Shealey Truck Center",
        user: "john",
        date: "01/25/2025",
        status: "Passed",
      ),
      TrainingData(
        title: "CUSTOMER RELATIONSHIP MANAGEMENT",
        message: "Training on CRM system and customer retention...",
        companyName: "Shealey Truck Center",
        user: "abhishek",
        date: "01/20/2025",
        status: "Passed",
      ),
      TrainingData(
        title: "DEALERSHIP MANAGEMENT SYSTEM",
        message: "Overview of dealership management software...",
        companyName: "Shealey Truck Center",
        user: "miguel",
        date: "01/15/2025",
        status: "Passed",
      ),
    ],
  };

  final Map<String, List<double>> mockProgress = {
    "In-Progress": [0.25, 0.45, 0.65, 0.85],
    "Overdue": [0.75, 0.85],
    "Failed": [1.0, 1.0, 1.0],
    "Expired": [1.0, 1.0],
    "Passed": [1.0, 1.0, 1.0, 1.0],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: statusTabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Builds the top search bar.
  Widget _buildSearchBar(bool isTablet) {
    return Container(
      height: isTablet ? 50 : 40,
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 50 : 42),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.07),
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.32),
            offset: Offset(0, 0.75),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.menu, color: Colors.black, size: isTablet ? 30 : 25),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 16 : 12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search Courses",
                  hintStyle: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF66656A),
                  ),
                  border: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(vertical: isTablet ? 12 : 8),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD7E8CD),
              foregroundColor: const Color(0xFF407B1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isTablet ? 18 : 15),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 12 : 9,
                vertical: isTablet ? 7 : 5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: isTablet ? 24 : 20),
                const SizedBox(width: 2),
                Text(
                  "Schedule",
                  style: TextStyle(fontSize: isTablet ? 18 : 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Builds the adaptive tab bar using the statusTabs list.
  TabBar _buildAdaptiveTabBar(bool isTablet) {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      labelColor: const Color(0xFF407B1E),
      unselectedLabelColor: const Color(0xFF66656A),
      indicatorColor: const Color(0xFF407B1E),
      indicatorWeight: isTablet ? 4 : 3,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: TextStyle(fontSize: isTablet ? 18 : 16),
      padding: EdgeInsets.zero,
      labelPadding: EdgeInsets.only(left: 0, right: isTablet ? 16 : 12),
      indicatorPadding: EdgeInsets.symmetric(horizontal: isTablet ? 6 : 4),
      onTap: (index) {
        setState(() {});
      },
      tabs: List.generate(
        statusTabs.length,
            (index) => Tab(
          height: isTablet ? 49 : 41,
          child: StatusTabWithImage(
            title: statusTabs[index]["title"],
            imagePath: statusTabs[index]["imagePath"],
            count: statusTabs[index]["count"],
            isSelected: _tabController.index == index,
            isTablet: isTablet,
          ),
        ),
      ),
    );
  }


  List<TrainingData> getFilteredTrainingData(String status) {
    List<TrainingData> originalList = trainingDataByStatus[status] ?? [];

    // Check if any filters are active
    bool hasActiveFilters = false;
    selectedFilters.forEach((key, value) {
      if (key == 'Date Range' && (value as String).isNotEmpty) {
        hasActiveFilters = true;
      } else if (key != 'Date Range' && (value as List<String>).isNotEmpty) {
        hasActiveFilters = true;
      }
    });

    // If no filters are active, return the original list
    if (!hasActiveFilters) {
      return originalList;
    }

    return originalList.where((training) {
      // Company filter (multi-select)
      final List<String> selectedCompanies = selectedFilters['Company'] as List<String>;
      if (selectedCompanies.isNotEmpty && !selectedCompanies.contains(training.companyName)) {
        return false;
      }

      // Dealerships filter (multi-select)
      final List<String> selectedDealerships = selectedFilters['Dealerships'] as List<String>;
      if (selectedDealerships.isNotEmpty) {
        bool matchesDealership = false;
        for (String dealership in selectedDealerships) {
          if (training.companyName.contains(dealership)) {
            matchesDealership = true;
            break;
          }
        }
        if (!matchesDealership) return false;
      }

      // Department filter (multi-select)
      final List<String> selectedDepartments = selectedFilters['Department'] as List<String>;
      if (selectedDepartments.isNotEmpty &&
          !selectedDepartments.contains('All Departments') &&
          !selectedDepartments.contains(training.department)) {
        return false;
      }

      // User filter (multi-select)
      final List<String> selectedUsers = selectedFilters['User'] as List<String>;
      if (selectedUsers.isNotEmpty &&
          !selectedUsers.contains('All Users') &&
          !selectedUsers.contains(training.user)) {
        return false;
      }

      // Date Range filter (single-select)
      if ((selectedFilters['Date Range'] as String).isNotEmpty) {
        DateTime trainingDate = DateTime.parse(training.date.split('/').reversed.join('-'));
        DateTime now = DateTime.now();

        switch (selectedFilters['Date Range'] as String) {
          case 'Last 7 Days':
            return now.difference(trainingDate).inDays <= 7;
          case 'Last 30 Days':
            return now.difference(trainingDate).inDays <= 30;
          case 'Last 90 Days':
            return now.difference(trainingDate).inDays <= 90;
          case 'Custom Range':
          // Implement custom date range logic here
            return true;
        }
      }

      return true;
    }).toList();
  }

  // Builds the list view for each tab.
  Widget _buildAdaptiveListView(
      Map<String, dynamic> tab,
      bool isTablet,
      double cardWidth,
      double horizontalPadding,
      ) {
    final status = tab["title"];
    final trainingList = getFilteredTrainingData(status);

    // Update the count in statusTabs
    final statusTabIndex = statusTabs.indexWhere((t) => t["title"] == status);
    if (statusTabIndex != -1) {
      statusTabs[statusTabIndex]["count"] = trainingList.length;
    }

    return Column(
      children: [
        // Header row with company name and sort text + icon
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 24 : 16,
            vertical: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedFilters['Company']?.isNotEmpty == true
                    ? selectedFilters['Company']!
                    : "SHEALEY TRUCK CENTER",
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF66656A),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 4),
                    Icon(Icons.sort, color: Colors.grey[700], size: isTablet ? 20 : 18),
                    Text(
                      'Sort',
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_drop_down, color: Colors.grey[700], size: 20),

                  ],
                ),
              ),
            ],
          ),
        ),
        // List of training cards
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(isTablet ? 12 : 8),
            itemCount: trainingList.length,
            itemBuilder: (context, index) {
              final trainingData = trainingList[index];
              double progress = 0.0;
              if (mockProgress.containsKey(status)) {
                List<double> values = mockProgress[status]!;
                progress = values[index % values.length];
              }

              return TrainingCard(
                status: status,
                progress: progress,
                isTablet: isTablet,
                cardWidth: cardWidth,
                trainingData: trainingData,
              );
            },
          ),
        ),
      ],
    );
  }
  // Builds the floating action button that opens the main filter bottom sheet.
  Widget _buildAdaptiveFloatingActionButton(bool isTablet) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1200;

    return Padding(
      padding: EdgeInsets.only(
        bottom: isDesktop ? 40.0 : (isTablet ? 30.0 : 20.0),
        right: isDesktop ? 40.0 : 0.0,
      ),
      child: FloatingActionButton.extended(
        onPressed: () {
          // Open main filter bottom sheet with temporary filters.
          showModalBottomSheet(
            context: context,
            backgroundColor: const Color(0xfffcfcf6),
            isScrollControlled: true,
            constraints: BoxConstraints(
              maxWidth: isDesktop ? screenWidth * 0.4 : double.infinity,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(isDesktop ? 30 : 20),
              ),
            ),
            builder: (BuildContext context) {
              // Create a temporary copy of the current filters.
              Map<String, dynamic> tempFilters = {
                'Company': List<String>.from(selectedFilters['Company'] as List<String>),
                'Dealerships': List<String>.from(selectedFilters['Dealerships'] as List<String>),
                'Department': List<String>.from(selectedFilters['Department'] as List<String>),
                'User': List<String>.from(selectedFilters['User'] as List<String>),
                'Date Range': selectedFilters['Date Range'],
              };

              return StatefulBuilder(
                builder: (context, setModalState) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 30 : 20,
                      ),
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header Section with Reset Filters.
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: isDesktop ? 24 : (isTablet ? 20 : 16),
                                horizontal: isDesktop ? 40 : 20,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () => Navigator.pop(context),
                                          child: Icon(
                                            Icons.close,
                                            size: isDesktop ? 26 : null,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: isDesktop ? 16 : 12),
                                      Text(
                                        'Add Filters',
                                        style: TextStyle(
                                          fontSize: isDesktop ? 22 : (isTablet ? 20 : 18),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setModalState(() {
                                        tempFilters = {
                                          'Company': <String>[],
                                          'Dealerships': <String>[],
                                          'Department': <String>[],
                                          'User': <String>[],
                                          'Date Range': '',
                                        };
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: const Color(0xFF407B1E),
                                      textStyle: TextStyle(
                                        fontSize: isDesktop ? 22 : 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    child: const Text('Reset Filters'),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),
                            // List of filter items with temporary state.
                            _buildFilterItem('Company', 'Select Company', context, isTablet, isDesktop, tempFilters, (filterTitle, value) {
                              setModalState(() {
                                tempFilters[filterTitle] = value;
                              });
                            }),
                            _buildFilterItem('Dealerships', 'Select Dealership', context, isTablet, isDesktop, tempFilters, (filterTitle, value) {
                              setModalState(() {
                                tempFilters[filterTitle] = value;
                              });
                            }),
                            _buildFilterItem('Department', 'Select Department', context, isTablet, isDesktop, tempFilters, (filterTitle, value) {
                              setModalState(() {
                                tempFilters[filterTitle] = value;
                              });
                            }),
                            _buildFilterItem('User', 'Select User', context, isTablet, isDesktop, tempFilters, (filterTitle, value) {
                              setModalState(() {
                                tempFilters[filterTitle] = value;
                              });
                            }),
                            _buildFilterItem('Date Range', 'Select Date Range', context, isTablet, isDesktop, tempFilters, (filterTitle, value) {
                              setModalState(() {
                                tempFilters[filterTitle] = value;
                              });
                            }),
                            SizedBox(height: isDesktop ? 30 : 20),
                            // Apply Filters Button commits the temporary filters.
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                isDesktop ? 24 : 16,
                                isDesktop ? 16 : 10,
                                isDesktop ? 24 : 16,
                                isDesktop ? 30 : 35,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedFilters = Map.from(tempFilters);
                                  });
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF407B1E),
                                  minimumSize: Size(
                                    double.infinity,
                                    isDesktop ? 60 : (isTablet ? 55 : 50),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(isDesktop ? 30 : 28),
                                  ),
                                ),
                                child: Text(
                                  'Apply Filters',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isDesktop ? 20 : 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        backgroundColor: const Color(0xFF407B1E),
        foregroundColor: Colors.white,
        label: Text(
          "Filter",
          style: TextStyle(
            fontSize: isDesktop ? 20 : (isTablet ? 18 : 16),
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: Icon(
          Icons.filter_alt,
          size: isDesktop ? 32 : (isTablet ? 28 : 24),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            isDesktop ? 40 : (isTablet ? 35 : 30),
          ),
        ),
      ),
    );
  }
  // Updated helper function to build each filter item using temporary filters.
  Widget _buildFilterItem(
      String title,
      String defaultDisplayText,
      BuildContext context,
      bool isTablet,
      bool isDesktop,
      Map<String, dynamic> tempFilters,
      Function(String, dynamic) onUpdate,
      ) {
    String displayText = defaultDisplayText;

    // Handle display text based on filter type
    if (title != 'Date Range') {
      // For multi-select filters
      final selectedValues = tempFilters[title] as List<String>;
      if (selectedValues.isNotEmpty) {
        if (selectedValues.length == 1) {
          displayText = selectedValues.first;
        } else {
          displayText = '${selectedValues.length} selected';
        }
      }
    } else {
      // For single-select Date Range
      displayText = tempFilters[title]?.isNotEmpty == true ? tempFilters[title] : defaultDisplayText;
    }

    return InkWell(
      onTap: () => _showFilterDetailSheet(
          context,
          title,
          isTablet,
          isDesktop,
          tempFilters,
          onUpdate
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 30 : 20,
          vertical: isDesktop ? 20 : 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: isDesktop ? 20 : 18,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 150),
                  child: Text(
                    displayText,
                    style: TextStyle(
                      color: title != 'Date Range'
                          ? ((tempFilters[title] as List<String>).isNotEmpty ? const Color(0xFF407B1E) : Colors.grey)
                          : (tempFilters[title]?.isNotEmpty == true ? const Color(0xFF407B1E) : Colors.grey),
                      fontSize: isDesktop ? 20 : 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: isDesktop ? 12 : 8),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: isDesktop ? 24 : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  // Modified bottom sheet for filter detail that uses the temporary filters.
  void _showFilterDetailSheet(
      BuildContext context,
      String filterTitle,
      bool isTablet,
      bool isDesktop,
      Map<String, dynamic> tempFilters,
      Function(String, dynamic) onUpdate) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Use fixed heights that match the main filter sheet
    final double sheetHeight = MediaQuery.of(context).size.height *
        (isDesktop ? 0.7 : (isTablet ? 0.4 : 0.5));

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxWidth: isDesktop ? screenWidth * 0.4 : screenWidth,
        maxHeight: sheetHeight,
      ),
      builder: (BuildContext context) {
        // Initialize the temporary values
        List<String> tempSelectedValues = [];
        String tempDateRange = '';

        if (filterTitle != 'Date Range') {
          tempSelectedValues = List<String>.from(tempFilters[filterTitle] as List<String>);
        } else {
          tempDateRange = tempFilters[filterTitle] as String;
        }

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: sheetHeight,
              decoration: BoxDecoration(
                color: const Color(0xFFFCFCF6),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(isDesktop ? 30 : 20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: isDesktop ? 24 : (isTablet ? 20 : 16),
                      horizontal: isDesktop ? 30 : 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Icons.close,
                                size: isDesktop ? 26 : 24,
                              ),
                            ),
                            SizedBox(width: isDesktop ? 16 : 12),
                            Text(
                              filterTitle == 'Date Range'
                                  ? 'Select $filterTitle'
                                  : 'Select $filterTitle (Multiple)',
                              style: TextStyle(
                                fontSize: isDesktop ? 22 : (isTablet ? 20 : 18),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            if (filterTitle != 'Date Range') {
                              setModalState(() {
                                tempSelectedValues.clear();
                              });
                            } else {
                              setModalState(() {
                                tempDateRange = '';
                              });
                            }
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF407B1E),
                          ),
                          child: Text(
                            'Reset',
                            style: TextStyle(
                              fontSize: isDesktop ? 18 : 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // List of filter options
                  Expanded(
                    child: ListView.builder(
                      itemCount: filterOptions[filterTitle]?.length ?? 0,
                      itemBuilder: (context, index) {
                        final option = filterOptions[filterTitle]![index];

                        if (filterTitle != 'Date Range') {
                          // Multi-select handling with text color and checkmark
                          final isSelected = tempSelectedValues.contains(option);
                          return InkWell(
                            onTap: () {
                              setModalState(() {
                                if (isSelected) {
                                  tempSelectedValues.remove(option);
                                } else {
                                  tempSelectedValues.add(option);
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isDesktop ? 30 : 20,
                                vertical: isDesktop ? 20 : 16,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: TextStyle(
                                        fontSize: isDesktop ? 20 : 18,
                                        fontWeight: FontWeight.w400,
                                        color: isSelected ? const Color(0xFF407B1E) : Colors.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check,
                                      color: const Color(0xFF407B1E),
                                      size: isDesktop ? 24 : 20,
                                    ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          // Single-select handling with text color and checkmark
                          final isSelected = tempDateRange == option;
                          return InkWell(
                            onTap: () {
                              setModalState(() {
                                tempDateRange = option;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isDesktop ? 30 : 20,
                                vertical: isDesktop ? 20 : 16,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: TextStyle(
                                        fontSize: isDesktop ? 20 : 18,
                                        fontWeight: FontWeight.w400,
                                        color: isSelected ? const Color(0xFF407B1E) : Colors.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check,
                                      color: const Color(0xFF407B1E),
                                      size: isDesktop ? 24 : 20,
                                    ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  // Apply button
                  Padding(
                    padding: EdgeInsets.all(isDesktop ? 24 : 16),
                    child: ElevatedButton(
                      onPressed: () {
                        if (filterTitle != 'Date Range') {
                          onUpdate(filterTitle, tempSelectedValues);
                        } else {
                          onUpdate(filterTitle, tempDateRange);
                        }
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF407B1E),
                        minimumSize: Size(
                          double.infinity,
                          isDesktop ? 60 : 50,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(isDesktop ? 30 : 25),
                        ),
                      ),
                      child: Text(
                        'Apply',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isDesktop ? 20 : 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    final isTablet = size.width >= 600;

    final horizontalPadding = size.width * 0.05;
    final cardWidth = isTablet
        ? (isLandscape ? size.width * 0.4 : size.width * 0.8)
        : size.width * 0.9;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: isTablet ? 99.0 : 77.0,
              floating: true,
              pinned: false,
              snap: true,
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFCFCF6),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + (isTablet ? 25 : 15),
                    bottom: isTablet ? 12 : 8,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: _buildSearchBar(isTablet),
                  ),
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                _buildAdaptiveTabBar(isTablet),
                gap: innerBoxIsScrolled ? (isTablet ? 35 : 25) : (isTablet ? 12 : 5),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: statusTabs.map((tab) {
            return _buildAdaptiveListView(
              tab,
              isTablet,
              cardWidth,
              horizontalPadding,
            );
          }).toList(),
        ),
      ),
      floatingActionButton: _buildAdaptiveFloatingActionButton(isTablet),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: const BottomNavigation(
        selectedIndex: 2,
        isTablet: false,
      ),
    );
  }
}

// Custom SliverPersistentHeaderDelegate for the tab bar.
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final double gap;

  _SliverAppBarDelegate(this._tabBar, {this.gap = 10});

  @override
  double get minExtent => _tabBar.preferredSize.height + gap;

  @override
  double get maxExtent => _tabBar.preferredSize.height + gap;

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => true;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: maxExtent,
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(
            top: gap,
            left: 0,
            right: 0,
            child: MediaQuery.removePadding(
              context: context,
              removeLeft: true,
              child: Transform.translate(
                offset: const Offset(-18, 0),
                child: _tabBar,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Stub widget for StatusTabWithImage (replace with your full implementation).
class StatusTabWithImage extends StatelessWidget {
  final String title;
  final String imagePath;
  final int count;
  final bool isSelected;
  final bool isTablet;

  const StatusTabWithImage({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.count,
    required this.isSelected,
    required this.isTablet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          imagePath,
          width: isTablet ? 28 : 24,
          height: isTablet ? 28 : 24,
        ),
        SizedBox(width: isTablet ? 6 : 4),
        Text(
          title,
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            color: isSelected ? Colors.black : const Color(0xFF66656A),
          ),
        ),
        SizedBox(width: isTablet ? 6 : 4),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 8 : 6,
            vertical: isTablet ? 3 : 2,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isTablet ? 14 : 12),
            border: Border.all(color: Colors.black54, width: 1),
          ),
          child: Text(
            "$count",
            style: TextStyle(
              fontSize: isTablet ? 14 : 12,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}

// Stub widget for TrainingCard (replace with your full implementation).
class TrainingCard extends StatelessWidget {
  final String status;
  final double? progress;
  final bool isTablet;
  final double cardWidth;
  final TrainingData trainingData;

  const TrainingCard({
    Key? key,
    required this.status,
    this.progress,
    required this.isTablet,
    required this.cardWidth,
    required this.trainingData,
  }) : super(key: key);

  double _getProgress() {
    if (progress != null) return progress!;
    switch (status) {
      case "In-Progress":
        return 0.45;
      case "Overdue":
        return 0.75;
      case "Failed":
      case "Expired":
      case "Passed":
        return 1.0;
      default:
        return 0.0;
    }
  }

  Color _getProgressColor() {
    switch (status) {
      case "Failed":
        return Colors.red;
      case "Overdue":
        return Colors.orange;
      case "Passed":
      case "In-Progress":
      default:
        return const Color(0xFF407B1E);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool showProgress = status != "Scheduled";

    return Container(
      width: cardWidth,
      child: Card(
        color: const Color(0xFFF2F5EC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
        ),
        elevation: 0,
        margin: EdgeInsets.symmetric(
          vertical: isTablet ? 8 : 6,
          horizontal: isTablet ? 10 : 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showProgress)
              Container(
                width: double.infinity,
                height: isTablet ? 6 : 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isTablet ? 24 : 20),
                    topRight: Radius.circular(isTablet ? 24 : 20),
                  ),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _getProgress(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _getProgressColor(),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(isTablet ? 24 : 20),
                        topRight: Radius.circular(isTablet ? 24 : 20),
                      ),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(isTablet ? 19 : 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trainingData.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: isTablet ? 18 : 16,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: isTablet ? 4 : 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          trainingData.message,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: isTablet ? 18 : 14,
                            fontFamily: 'Roboto',
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                        size: isTablet ? 32 : 24,
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 6 : 3),
                  _buildInfoSection(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Wrap(
      spacing: isTablet ? 36 : 30,
      runSpacing: isTablet ? 12 : 8,
      children: [
        _buildInfoItem(Icons.store_mall_directory, trainingData.companyName),
        _buildInfoItem(Icons.person, trainingData.user),
        _buildInfoItem(Icons.access_time_filled, trainingData.date),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: const Color(0xFF407B1D),
          size: isTablet ? 20 : 16,
        ),
        SizedBox(width: isTablet ? 7 : 5),
        Text(
          text,
          style: TextStyle(
            color: const Color(0xFF407B1D),
            fontSize: isTablet ? 18 : 14,
            fontFamily: 'Proxima Nova',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}




class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final bool isTablet;

  const BottomNavigation({
    this.selectedIndex = 2,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 24 : 16,
            // vertical: isTablet ? 0 : 4,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavItem(
                icon: Icons.content_paste_search,
                label: 'Audits',
                isSelected: selectedIndex == 0,
                isTablet: isTablet,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AuditsScreen()),
                  );
                },
              ),
              NavItem(
                icon: Icons.checklist_rounded,
                label: 'Tasks',
                isSelected: selectedIndex == 1,
                isTablet: isTablet,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => TasksScreen()),
                  );
                },
              ),
              NavItem(
                icon: Icons.school,
                label: 'Training',
                isSelected: selectedIndex == 2,
                isTablet: isTablet,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isTablet;
  final VoidCallback onTap;

  const NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: isTablet ? 12 : 8),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xffd7e8cd) : Colors.transparent,
              borderRadius: BorderRadius.circular(isTablet ? 35 : 30),
              border: isSelected
                  ? Border(
                left: BorderSide(color: Colors.transparent, width: isTablet ? 18 : 15),
                right: BorderSide(color: Colors.transparent, width: isTablet ? 18 : 15),
                top: BorderSide(color: Colors.transparent, width: 1),
                bottom: BorderSide(color: Colors.transparent, width: 3),
              )
                  : Border.all(color: Colors.transparent, width: 0),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                isTablet ? 10 : 8,
                isTablet ? 6 : 4,
                isTablet ? 10 : 8,
                1,
              ),
              child: Icon(
                icon,
                size: isTablet ? 32 : 28,
                color: isSelected ? Color(0xFF407B1E) : Colors.black,
              ),
            ),
          ),
          SizedBox(height: isTablet ? 6 : 4),
          Text(
            label,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: isSelected ? Color(0xFF407B1E) : Colors.black,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class AuditsScreen extends StatelessWidget {
  const AuditsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Audits",
          style: TextStyle(
            fontSize: isTablet ? 24 : 20,
          ),
        ),
      ),
      body: Center(
        child: Text(
          "Audits Page",
          style: TextStyle(
            fontSize: isTablet ? 20 : 16,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 0,
        isTablet: isTablet,
      ),
    );
  }
}

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tasks",
          style: TextStyle(
            fontSize: isTablet ? 24 : 20,
          ),
        ),
      ),
      body: Center(
        child: Text(
          "Tasks Page",
          style: TextStyle(
            fontSize: isTablet ? 20 : 16,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 1,
        isTablet: isTablet,
      ),
    );
  }
}