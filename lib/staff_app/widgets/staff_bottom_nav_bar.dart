import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class StaffBottomNavBar extends StatelessWidget {
  const StaffBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(
      ProfileController(),
      permanent: true,
    );

    return Obx(() {
      return Container(
        height: 90,
        padding: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          color: Color(0xFF7E49FF), // Persistent Purple
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, Icons.home_rounded, "Home", controller),
            _buildNavItem(
              1,
              Icons.auto_graph_rounded,
              "Attendance",
              controller,
            ),
            _buildNavItem(2, Icons.description_rounded, "Fees", controller),
            _buildNavItem(3, Icons.person_rounded, "Profile", controller),
          ],
        ),
      );
    });
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    String label,
    ProfileController controller,
  ) {
    bool isSelected = controller.currentIndex.value == index;
    return GestureDetector(
      onTap: () {
        if (isSelected) return;
        controller.changeIndex(index);

        switch (index) {
          case 0:
            Get.offAllNamed('/dashboard');
            break;
          case 1:
            Get.offAllNamed('/attendanceOptions');
            break;
          case 2:
            Get.offAllNamed('/feeHeads');
            break;
          case 3:
            Get.offAllNamed('/profile');
            break;
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.7),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
