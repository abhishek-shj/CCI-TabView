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

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 44),

          Padding(
            padding: EdgeInsets.fromLTRB(21, 16, 16.339, 10),
            child: Container(
              padding: EdgeInsets.fromLTRB(17, 8, 10, 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(42),
                boxShadow: [
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.menu, color: Colors.black, size: 27),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search Courses",
                          hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 27,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.4,
                            color: Color(0xFF66656A),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD7E8CD),
                      foregroundColor: Color(0xFF407B1E),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: Icon(Icons.add, size: 30, color: Color(0xFF407B1E)),
                    label: Text("Schedule", style: TextStyle(fontSize: 27,fontFamily:'Roboto')),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusTabWithImage(
                  title: "Scheduled",
                  imagePath: "assets/images/scheduled_icon.png",
                  count: 12,
                ),
                StatusTabWithImage(
                  title: "In-Progress",
                  imagePath: "assets/images/inprocess_icon.png",
                  count: 18,
                ),
                StatusTabWithImage(
                  title: "Overdue",
                  imagePath: "assets/images/Overdue_icon.png",
                  count: 3,
                ),
                StatusTabWithImage(
                  title: "Passed",
                  imagePath: "assets/images/passed_icon.png",
                  count: 5,
                ),
                StatusTabWithImage(
                  title: "Failed",
                  imagePath: "assets/images/failed_icon.png",
                  count: 5,
                ),
              ],
            ),
          ),

          Transform.translate(
            offset: Offset(0, -12), // Move the line up by 10 pixels
            child: Container(
              height: 1,
              color: Color.fromRGBO(64, 123, 30, 0.15),
              margin: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),

        ],
      ),
    );
  }
}

class StatusTabWithImage extends StatelessWidget {
  final String title;
  final String imagePath;
  final int count;

  StatusTabWithImage({required this.title, required this.imagePath, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 28,
          height: 28,
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.w500, color: Color(0xFF66656A)),
        ),
        SizedBox(width: 10),
        Container(
          width: 34,
          height: 28,
          alignment: Alignment.center, // Centers the text inside the circle
          decoration: BoxDecoration(
            // color: Colors.grey[300], // Background color of the circle
            borderRadius: BorderRadius.circular(18), // Border radius of 8px
            border: Border.all(color: Colors.black54, width: 1), // Optional border
          ),
          child: Text(
            "$count",
            style: TextStyle(
              fontSize: 18, // Adjusted size for better fit
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ),

      ],
    );
  }
}
