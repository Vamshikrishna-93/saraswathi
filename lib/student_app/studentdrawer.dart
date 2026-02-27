import 'package:flutter/material.dart';
import 'package:student_app/student_app/exams_page.dart';
import 'package:student_app/student_app/services/student_profile_service.dart';

class StudentDrawerPage extends StatelessWidget {
  const StudentDrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Background will be handled by the Row
      body: Row(
        children: [
          // Main Drawer content (80% width)
          Expanded(
            flex: 8,
            child: Container(
              color: const Color(0xFFF5F3FF),
              child: Column(
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      children: [
                        _buildExpandableMenuItem(
                          context,
                          icon: Icons.edit_document,
                          title: "Exams",
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const ExamsPage()));
                          },
                        ),
                        _buildExpandableMenuItem(
                          context,
                          icon: Icons.apartment_rounded,
                          title: "Hostels",
                          onTap: () {},
                        ),
                        _buildExpandableMenuItem(
                          context,
                          icon: Icons.settings_accessibility_rounded,
                          title: "Hr Management",
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.chat_bubble_outline_rounded,
                          title: "Chat",
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.forum_outlined,
                          title: "Communication",
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // Semitransparent dismissal area (20% width)
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 30,
        left: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8B5CF6), Color(0xFFC084FC)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo Circle
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                "Logo",
                style: TextStyle(
                  color: Color(0xFF8B5CF6),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          // User Name
          ValueListenableBuilder<String?>(
            valueListenable: StudentProfileService.displayName,
            builder: (context, name, _) {
              return Text(
                name ?? "Ashok Reddy",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          // User ID
          Text(
            "User ID :  667021",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: Icon(icon, color: Colors.black, size: 22),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          trailing: const Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 22),
          children: [
            ListTile(
              title: const Text("Placeholder View"),
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Icon(icon, color: Colors.black, size: 22),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
