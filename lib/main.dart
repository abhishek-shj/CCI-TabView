import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFFCFCF6),
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchScreen(),
    );
  }
}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> statusTabs = [
    {
      "title": "Scheduled",
      "imagePath": "assets/images/scheduled_icon.png",
      "count": 12,
    },
    {
      "title": "In-Progress",
      "imagePath": "assets/images/inprocess_icon.png",
      "count": 18,
    },
    {
      "title": "Overdue",
      "imagePath": "assets/images/Overdue_icon.png",
      "count": 3,
    },
    {
      "title": "Failed",
      "imagePath": "assets/images/failed_icon.png",
      "count": 5,
    },
    {
      "title": "Expired",
      "imagePath": "assets/images/Expired_icon.png",
      "count": 5,
    },
    {
      "title": "Passed",
      "imagePath": "assets/images/passed_icon.png",
      "count": 5,
    },
  ];

  // Use your provided progress values.
  final Map<String, List<double>> mockProgress = {
    "In-Progress": [0.25, 0.45, 0.65, 0.15, 0.85],
    "Overdue": [0.55, 0.75, 0.85, 0.95, 0.65],
    "Failed": [1.0, 1.0, 1.0, 1.0, 1.0],
    "Expired": [1.0, 1.0, 1.0, 1.0, 1.0],
    "Passed": [1.0, 1.0, 1.0, 1.0, 1.0],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: statusTabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild when tab changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(42),
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.07),
              offset: Offset(0, 4),
              blurRadius: 4),
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.32),
              offset: Offset(0, 0.75),
              blurRadius: 2),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.menu, color: Colors.black, size: 25),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search Courses",
                  hintStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF66656A)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD7E8CD),
              foregroundColor: Color(0xFF407B1E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 20, color: Color(0xFF407B1E)),
                SizedBox(width: 2),
                Text("Schedule", style: TextStyle(fontSize: 16
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 88.0,
              floating: true,
              pinned: false,
              snap: true,
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFFCFCF6),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 15,
                    bottom: 8,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 21),
                    child: _buildSearchBar(),
                  ),
                ),
              ),
            ),
            // TabBar with a gap on top when scrolling
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: Color(0xFF407B1E),
                  unselectedLabelColor: Color(0xFF66656A),
                  indicatorColor: Color(0xFF407B1E),
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: TextStyle(fontSize: 16),
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 4),
                  padding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.symmetric(horizontal: 12),
                  onTap: (index) {
                    setState(() {});
                  },
                  tabs: List.generate(
                    statusTabs.length,
                        (index) => Tab(
                      height: 52,
                      child: StatusTabWithImage(
                        title: statusTabs[index]["title"],
                        imagePath: statusTabs[index]["imagePath"],
                        count: statusTabs[index]["count"],
                        isSelected: _tabController.index == index,
                      ),
                    ),
                  ),
                ),
                gap: innerBoxIsScrolled ? 30 : 5, // Update gap based on scroll state, // gap from top when pinned
              ),
            ),
          ];
        },
        // The ListView now includes the header text inside so it scrolls with the cards.
        body: TabBarView(
          controller: _tabController,
          children: statusTabs.map((tab) {
            return ListView.builder(
              padding: EdgeInsets.all(8),
              // Increase itemCount by 1 to include the header text as the first item.
              itemCount: 29,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.only(left: 16, top: 4, bottom: 2),
                    child: Text(
                      "SHEALEY TRUCK CENTER",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF66656A),
                      ),
                    ),
                  );
                }
                // For each TrainingCard, determine the progress:
                double progress = 0.0;
                if (mockProgress.containsKey(tab["title"])) {
                  List<double> values = mockProgress[tab["title"]]!;
                  // Cycle through the list of progress values using (index - 1)
                  progress = values[(index - 1) % values.length];
                } else {
                  // For statuses not in mockProgress (e.g., "Scheduled"), use 0.0.
                  progress = 0.0;
                }
                return TrainingCard(status: tab["title"], progress: progress);
              },
            );
          }).toList(),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 25.0),
        child: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: Color(0xFF407B1E),
          foregroundColor: Colors.white,
          label: Text(
            "Filter",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          icon: Icon(Icons.filter_alt, size: 24),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigation(selectedIndex: 2),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final double gap;

  _SliverAppBarDelegate(this._tabBar, {this.gap = 10});

  @override
  double get minExtent => _tabBar.preferredSize.height + gap;

  @override
  double get maxExtent => _tabBar.preferredSize.height + gap;

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: gap), // creates the top gap
      child: _tabBar,
    );
  }
}

class StatusTabWithImage extends StatelessWidget {
  final String title;
  final String imagePath;
  final int count;
  final bool isSelected;

  StatusTabWithImage({
    required this.title,
    required this.imagePath,
    required this.count,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          imagePath,
          width: 24,
          height: 24,
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            color: isSelected ? Colors.black : Color(0xFF66656A),
          ),
        ),
        SizedBox(width: 4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black54, width: 1),
          ),
          child: Text(
            "$count",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}

/// Modified TrainingCard now accepts an optional progress parameter.
class TrainingCard extends StatelessWidget {
  final String status;
  final double? progress; // if provided, this value will be used

  TrainingCard({required this.status, this.progress});

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
        return Color(0xFF407B1E);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;
    bool showProgress = status != "Scheduled";

    return Card(
      color: Color(0xFFF2F5EC),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showProgress)
            Container(
              width: double.infinity,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _getProgress(),
                child: Container(
                  decoration: BoxDecoration(
                    color: _getProgressColor(),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "REGULATORY COMPLIANCE IN DEALERSHIP",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: isMobile ? 16 : 18,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Training on local, state, and federal regulations applicable to automotive sales and services...",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: isMobile ? 14 : 18,
                          fontFamily: 'Roboto',
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Icon(Icons.chevron_right,
                        color: Colors.grey, size: isMobile ? 24 : 30),
                  ],
                ),
                SizedBox(height: 3),
                if (isMobile)
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _buildInfoItem(
                          Icons.store_mall_directory, "Shealey Truck Center", isMobile),
                      _buildInfoItem(Icons.person, "Miguel", isMobile),
                      _buildInfoItem(
                          Icons.access_time_filled, "01/26/2025", isMobile),
                    ],
                  )
                else
                  Row(
                    children: [
                      _buildInfoItem(
                          Icons.store_mall_directory, "Shealey Truck Center", isMobile),
                      SizedBox(width: 28),
                      _buildInfoItem(Icons.person, "Miguel", isMobile),
                      SizedBox(width: 28),
                      _buildInfoItem(
                          Icons.access_time_filled, "01/26/2025", isMobile),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, bool isMobile) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Color(0xFF407B1D), size: isMobile ? 16 : 20),
        SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            color: Color(0xFF407B1D),
            fontSize: isMobile ? 14 : 18,
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
  const BottomNavigation({this.selectedIndex = 2});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000), // 10% opacity black
            blurRadius: 4,
            offset: Offset(0, -2),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavItem(
                icon: Icons.content_paste_search,
                label: 'Audits',
                isSelected: selectedIndex == 0,
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
  final VoidCallback onTap;

  const NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xffd7e8cd) : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              border: isSelected
                  ? Border(
                left: BorderSide(color: Colors.transparent, width: 15),
                right: BorderSide(color: Colors.transparent, width: 15),
                top: BorderSide(color: Colors.transparent, width: 1),
                bottom: BorderSide(color: Colors.transparent, width: 3),
              )
                  : Border.all(color: Colors.transparent, width: 0),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 4, 8, 1),
              child: Icon(
                icon,
                size: 28,
                color: isSelected ? Color(0xFF407B1E) : Colors.black,
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audits"),
      ),
      body: Center(
        child: Text("Audits Page"),
      ),
      bottomNavigationBar: BottomNavigation(selectedIndex: 0),
    );
  }
}

class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks"),
      ),
      body: Center(
        child: Text("Tasks Page"),
      ),
      bottomNavigationBar: BottomNavigation(selectedIndex: 1),
    );
  }
}
