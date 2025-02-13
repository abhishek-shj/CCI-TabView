import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
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

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
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
      padding: EdgeInsets.fromLTRB(17, 8, 10, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(42),
        boxShadow: [
          BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.07), offset: Offset(0, 4), blurRadius: 4),
          BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.32), offset: Offset(0, 0.75), blurRadius: 2),
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
                  hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF66656A)),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD7E8CD),
              foregroundColor: Color(0xFF407B1E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 22, color: Color(0xFF407B1E)),
                SizedBox(width: 2),
                Text("Schedule", style: TextStyle(fontSize: 18)),
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
            // Collapsible Search Bar
            SliverAppBar(
              floating: true,
              snap: true,
              pinned: false,
              toolbarHeight: 120,
              backgroundColor: Colors.white,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: [
                    SizedBox(height: 44),
                    Padding(
                      padding: EdgeInsets.fromLTRB(21, 16, 16, 10),
                      child: _buildSearchBar(),
                    ),
                  ],
                ),
              ),
            ),
            // Fixed Status Tabs
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
                  padding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.only(right: 18),
                  tabs: statusTabs.asMap().entries.map((entry) {
                    int index = entry.key;
                    var tab = entry.value;
                    return Tab(
                      child: Padding(
                        padding: EdgeInsets.only(left: index == 0 ? 0 : 8),
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
              itemCount: 18,
              itemBuilder: (context, index) => TrainingCard(status: tab["title"]),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Color(0xFF407B1E),
        foregroundColor: Colors.white,
        label: Text("Filter", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        icon: Icon(Icons.filter_alt, size: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigation(),
    );
  }
}

// Add this new delegate class for the fixed status tabs
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}


// Widget for the Status Tabs
class StatusTabWithImage extends StatelessWidget {
  final String title;
  final String imagePath;
  final int count;
  final double imageTextSpacing;

  StatusTabWithImage({required this.title, required this.imagePath, required this.count, this.imageTextSpacing = 4,});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(imagePath, width: 24, height: 24), // Adjusted image size
        SizedBox(width: imageTextSpacing), //  Minimized space between image & text
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        SizedBox(width: 4), // Minimized space before count box
        Container(
          width: 30,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black54, width: 1),
          ),
          child: Text("$count", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54)),
        ),
      ],
    );
  }
}

// Training Card Widget
class TrainingCard extends StatelessWidget {
  final String status;

  TrainingCard({required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xfff2f5ec),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "REGULATORY COMPLIANCE IN DEALERSHIP - $status",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, fontFamily: 'Roboto'),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Training on local, state, and federal regulations applicable to automotive sales and services...",
                    style: TextStyle( fontWeight: FontWeight.w300, fontSize: 18, fontFamily: 'Roboto', overflow: TextOverflow.ellipsis),
                    maxLines: 1,
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey, size: 30),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.store_mall_directory, color: Color(0xff407a1d), size: 20),
                SizedBox(width: 4),
                Text("Shealey Truck Center", style: TextStyle(
                  color: Color(0xFF407A1D),
                  fontSize: 18,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w400,
                )),
                SizedBox(width: 12),
                Icon(Icons.person, color: Color(0xff407a1d), size: 20),
                SizedBox(width: 4),
                Text("Miguel", style: TextStyle(
                  color: Color(0xFF407A1D),
                  fontSize: 18,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w400,
                )),
                SizedBox(width: 12),
                Icon(Icons.alarm, color: Color(0xff407a1d), size: 20),
                SizedBox(width: 4),
                Text("01/26/2025", style: TextStyle(
                  color: Color(0xFF407A1D),
                  fontSize: 18,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w400,
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Bottom Navigation Widget
class BottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000), // 0x1A = 10% opacity of black
            blurRadius: 4,
            offset: Offset(0, -2),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavItem(
                icon: Icons.content_paste_search,
                label: 'Audits',
                isSelected: false,
                onTap: () {
                  // Handle Audits tap
                },
              ),
              NavItem(
                icon: Icons.checklist_rounded,
                label: 'Tasks',
                isSelected: false,
                onTap: () {
                  // Handle Tasks tap
                },
              ),
              NavItem(
                icon: Icons.school,
                label: 'Training',
                isSelected: true,
                onTap: () {
                  // Handle Training tap
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Individual Navigation Item Widget
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
              color: isSelected ? Color(0xffd7e8cd) : Colors.transparent, // Background color
              borderRadius: BorderRadius.circular(42), // Rounded corners
              border: isSelected
                  ? Border(
                left: BorderSide(color: Colors.transparent, width: 14),  // Thicker left border
                right: BorderSide(color: Colors.transparent, width: 14), // Thicker right border
                // Normal bottom border
              )
                  : Border.all(color: Colors.transparent, width: 0), // No border when not selected
            ),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Adjust padding for balance
            child: Icon(
              icon,
              size: 40, // Increased icon size
              color: isSelected ? Colors.green : Colors.black, // Change color when selected
            ),
          ),



          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 20, // Increased text size
              color: isSelected ? Color(0xFF407B1E) : Colors.black,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
