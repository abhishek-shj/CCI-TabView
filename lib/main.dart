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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 44),

          // Search Bar
          Padding(
            padding: EdgeInsets.fromLTRB(21, 16, 16, 10),
            child: Container(
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
                  Icon(Icons.menu, color: Colors.black, size: 27),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search Courses",
                          hintStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Color(0xFF66656A)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD7E8CD),
                      foregroundColor: Color(0xFF407B1E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    icon: Icon(Icons.add, size: 25, color: Color(0xFF407B1E)),
                    label: Text("Schedule", style: TextStyle(fontSize: 25)),
                  ),
                ],
              ),
            ),
          ),

          // TabBar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            child: SizedBox(
              height: 50,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Color(0xFF66656A),
                unselectedLabelColor: Color(0xFF66656A),
                indicatorColor: Color(0xFF407B1E),
                indicatorWeight: 3,
                tabs: statusTabs.map((tab) => Tab(
                  child: StatusTabWithImage(
                    title: tab["title"],
                    imagePath: tab["imagePath"],
                    count: tab["count"],
                  ),
                )).toList(),
              ),
            ),
          ),

          // Training Cards inside TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: statusTabs.map((tab) {
                return ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: 5, // Change as needed per status
                  itemBuilder: (context, index) => TrainingCard(status: tab["title"]),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget for the Status Tabs
class StatusTabWithImage extends StatelessWidget {
  final String title;
  final String imagePath;
  final int count;

  StatusTabWithImage({required this.title, required this.imagePath, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(imagePath, width: 30, height: 30),
        SizedBox(width: 10),
        Text(title, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
        SizedBox(width: 6),
        Container(
          width: 35,
          height: 25,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.black54, width: 1),
          ),
          child: Text("$count", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black54)),
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
      color: Color(0xFFF2F5EC), // Background color added
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
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 25,
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 8),

            // Description with Chevron Icon
            Row(
              children: [
                Expanded( // Ensures text does not overflow
                  child: Text(
                    "Training on local, state, and federal regulations applicable to automotive sales and services...",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w300,
                      fontSize: 25,
                      fontFamily: 'Roboto',
                      overflow: TextOverflow.ellipsis, // Prevents overflow
                    ),
                    maxLines: 1, // Keeps it in one line
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey, size: 30), // Chevron icon
              ],
            ),

            SizedBox(height: 8),

            // Additional Information Row
            Row(
              children: [
                Icon(Icons.store_mall_directory, color: Colors.green, size: 23),
                SizedBox(width: 4),
                Text("Shealey Truck Center", style: TextStyle(
                  color: Color(0xFF407A1D),
                  fontSize: 25,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w400,
                )),
                SizedBox(width: 12),

                Icon(Icons.person, color: Colors.green, size: 23),
                SizedBox(width: 4),
                Text("Miguel", style: TextStyle(
                  color: Color(0xFF407A1D),
                  fontSize: 25,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w400,
                )),
                SizedBox(width: 12),

                Icon(Icons.access_alarm_rounded, color: Colors.green, size: 23),
                SizedBox(width: 4),
                Text("01/26/2025", style: TextStyle(
                  color: Color(0xFF407A1D),
                  fontSize: 25,
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
