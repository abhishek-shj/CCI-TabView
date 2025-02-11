import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key}); // Add 'const' constructor

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black), // Hamburger menu
        onPressed: () {},
      ),
      title: SizedBox(
        width: 448, // Fixed width for the search bar
        child: TextField(
          decoration: InputDecoration(
            hintText: "Search Courses",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("+ Schedule"),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56); // Required for PreferredSizeWidget
}
