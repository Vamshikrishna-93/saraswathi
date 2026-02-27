import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../widgets/staff_bottom_nav_bar.dart';

class AttendanceOptionsPage extends StatefulWidget {
  const AttendanceOptionsPage({super.key});

  @override
  State<AttendanceOptionsPage> createState() => _AttendanceOptionsPageState();
}

class _AttendanceOptionsPageState extends State<AttendanceOptionsPage> {
  @override
  void initState() {
    super.initState();
    // Ensure the bottom nav is synced
    Get.put(StaffMainController(), permanent: true).changeIndex(1);
  }

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF7E49FF);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ================= CUSTOM HEADER =================
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              bottom: 25,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              color: primaryPurple,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  "Students Attendance",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // ================= OPTIONS GRID =================
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.35, // Ultra-minimal/shorter cards for mobile
              children: [
                _buildOptionCard(
                  title: "Student\nAttendance",
                  icon: Icons.how_to_reg_rounded,
                  colors: [const Color(0xFF2DD4BF), const Color(0xFF10B981)],
                  onTap: () => Get.toNamed('/studentAttendance'),
                ),
                _buildOptionCard(
                  title: "Verify\nAttendance",
                  icon: Icons.verified_user_rounded,
                  colors: [const Color(0xFFFB7185), const Color(0xFFE11D48)],
                  onTap: () => Get.toNamed('/verifyAttendance'),
                ),
                _buildOptionCard(
                  title: "Issue\nOuting",
                  icon: Icons.route_rounded,
                  colors: [const Color(0xFF60A5FA), const Color(0xFF2563EB)],
                  onTap: () => Get.toNamed('/outingList'),
                ),
                _buildOptionCard(
                  title: "Outings\nPending",
                  icon: Icons.pending_actions_rounded,
                  colors: [const Color(0xFFFB923C), const Color(0xFFEA580C)],
                  onTap: () => Get.toNamed('/outingPending'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const StaffBottomNavBar(),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: colors[1].withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Smaller Decorative Background Circles
            Positioned(
              top: -15,
              right: -15,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -8,
              left: -8,
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Main Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: colors[1], size: 26),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
