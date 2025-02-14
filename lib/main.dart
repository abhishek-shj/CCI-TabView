import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set system UI overlay styles.
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFCFCF6),
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchScreen(), // Training page
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
    {"title": "Scheduled", "imagePath": "assets/images/scheduled_icon.png", "count": 12},
    {"title": "In-Progress", "imagePath": "assets/images/inprocess_icon.png", "count": 18},
    {"title": "Overdue", "imagePath": "assets/images/Overdue_icon.png", "count": 3},
    {"title": "Failed", "imagePath": "assets/images/failed_icon.png", "count": 5},
    {"title": "Expired", "imagePath": "assets/images/Expired_icon.png", "count": 5},
    {"title": "Passed", "imagePath": "assets/images/passed_icon.png", "count": 5},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: statusTabs.length, vsync: this);
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
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search Courses",
                  hintStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
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
                Text("Schedule", style: TextStyle(fontSize: 16)),
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
              expandedHeight: 90.0,
              floating: true,
              pinned: false,
              snap: true,
              backgroundColor: Color(0xFFCFCF6),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 15, // Increased top padding
                    bottom: 8,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 21),
                    child: _buildSearchBar(),
                  ),
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,

                  labelColor: Color(0xFF66656A),
                  unselectedLabelColor: Color(0xFF66656A),
                  indicatorColor: Color(0xFF407B1E),
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.tab, // Added for better alignment
                  labelStyle: TextStyle(fontSize: 16), // Added for better mobile scaling
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 4), // Added for indicator alignment
                  padding: EdgeInsets.symmetric(horizontal: 16), // Adjusted for mobile
                  labelPadding: EdgeInsets.symmetric(horizontal: 12), // Adjusted for mobile
                  tabs: statusTabs.asMap().entries.map((entry) {
                    int index = entry.key;
                    var tab = entry.value;
                    return Tab(
                      height: 52, // Increased height
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 0 : 4,
                          bottom: 4,
                          top: 4, // Added top padding
                        ),
                        child: StatusTabWithImage(
                          title: tab["title"],
                          imagePath: tab["imagePath"],
                          count: tab["count"],
                          imageTextSpacing: 4,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: statusTabs.map((tab) {
            return ListView.builder(
              key: PageStorageKey(tab["title"]),
              padding: EdgeInsets.all(8),
              itemCount: 28,
              itemBuilder: (context, index) => TrainingCard(status: tab["title"]),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20.0), // Adjust this value as needed
        child: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: Color(0xFF407B1E),
          foregroundColor: Colors.white,
          label: Text(
            "Filter",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          icon: Icon(Icons.filter_alt, size: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: BottomNavigation(selectedIndex: 2),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get maxExtent => _tabBar.preferredSize.height + 24.0; // Increased from 16.0
  @override
  double get minExtent => _tabBar.preferredSize.height + 24.0; // Increased from 16.0

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 23.0), // Added top padding
            child: _tabBar,
          ),
          Container(
            height: 1,
            color: Colors.grey[300], // Light grey line below tabs
            margin: EdgeInsets.only(top: 0), // Adjust if needed
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return false;
  }
}



class StatusTabWithImage extends StatelessWidget {
  final String title;
  final String imagePath;
  final int count;
  final double imageTextSpacing;

  StatusTabWithImage({
    required this.title,
    required this.imagePath,
    required this.count,
    this.imageTextSpacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Adjust text size based on screen width
    double fontSize = screenWidth < 600 ? 14 : 18;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          imagePath,
          width: screenWidth < 600 ? 20 : 24,
          height: screenWidth < 600 ? 20 : 24,
        ),
        SizedBox(width: imageTextSpacing),
        Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 4),
        Container(
          width: screenWidth < 600 ? 24 : 30,
          height: screenWidth < 600 ? 18 : 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black54, width: 1),
          ),
          child: Text(
            "$count",
            style: TextStyle(
              fontSize: screenWidth < 600 ? 12 : 14,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}

class TrainingCard extends StatelessWidget {
  final String status;

  TrainingCard({required this.status});

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive layout
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;

    return Card(
      color: Color(0xFFF2F5EC),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "REGULATORY COMPLIANCE IN DEALERSHIP - $status",
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
                Icon(Icons.chevron_right, color: Colors.grey, size: isMobile ? 24 : 30),
              ],
            ),
            SizedBox(height: 3), // Updated as requested
            if (isMobile)
            // Mobile layout - Wrapped layout
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _buildInfoItem(Icons.store_mall_directory, "Shealey Truck Center", isMobile),
                  _buildInfoItem(Icons.person, "Miguel", isMobile),
                  _buildInfoItem(Icons.access_time_filled, "01/26/2025", isMobile),
                ],
              )
            else
            // Tablet layout - Row layout
              Row(
                children: [
                  _buildInfoItem(Icons.store_mall_directory, "Shealey Truck Center", isMobile),
                  SizedBox(width: 28),
                  _buildInfoItem(Icons.person, "Miguel", isMobile),
                  SizedBox(width: 28),
                  _buildInfoItem(Icons.access_time_filled, "01/26/2025", isMobile),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, bool isMobile) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Color(0xFF407A1D), size: isMobile ? 16 : 20),
        SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            color: Color(0xFF407A1D),
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
            decoration: BoxDecoration(
              color: isSelected ? Color(0xffd7e8cd) : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              border: isSelected
                  ? Border(
                left: BorderSide(color: Colors.transparent, width: 14),
                right: BorderSide(color: Colors.transparent, width: 14),
              )
                  : Border.all(color: Colors.transparent, width: 0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
            child: Icon(
              icon,
              size: 28,
              color: isSelected ? Color(0xFF407B1E) : Colors.black,
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
