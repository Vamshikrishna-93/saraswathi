import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_app/staff_app/widgets/skeleton.dart';
import '../controllers/hostel_controller.dart';
import '../model/hostel_grid_model.dart';

class HostelAttendanceGridPage extends StatefulWidget {
  final int sid;
  final String studentName;
  final String admNo;

  const HostelAttendanceGridPage({
    super.key,
    required this.sid,
    required this.studentName,
    required this.admNo,
  });

  @override
  State<HostelAttendanceGridPage> createState() =>
      _HostelAttendanceGridPageState();
}

class _HostelAttendanceGridPageState extends State<HostelAttendanceGridPage> {
  final HostelController hostelCtrl = Get.find<HostelController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      hostelCtrl.loadHostelGrid(widget.sid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Attendance Grid",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${widget.studentName} (${widget.admNo})",
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              if (hostelCtrl.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SkeletonList(itemCount: 3),
                );
              }

              if (hostelCtrl.hostelGrid.isEmpty) {
                return const Center(
                  child: Text(
                    "No attendance data found",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 5,
                ),
                itemCount: hostelCtrl.hostelGrid.length,
                itemBuilder: (context, index) {
                  final monthData = hostelCtrl.hostelGrid[index];
                  return _MonthGridCard(monthData: monthData);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPad + 12,
        bottom: 28,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF7C3AED), // Same as mark page
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Text(
            "Attendance Grid",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthGridCard extends StatelessWidget {
  final HostelGridModel monthData;

  const _MonthGridCard({required this.monthData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F0FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month/Year Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFDCD6FD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              monthData.monthName?.toUpperCase() ?? "UNKNOWN",
              style: const TextStyle(
                color: Color(0xFF7C3AED),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: 31,
            itemBuilder: (context, index) {
              final dayNum = index + 1;
              final key = "Day_${dayNum.toString().padLeft(2, '0')}";
              final status = monthData.dayAttendance[key];

              return _DayGridCell(day: dayNum, status: status);
            },
          ),
        ],
      ),
    );
  }
}

class _DayGridCell extends StatelessWidget {
  final int day;
  final String? status;

  const _DayGridCell({required this.day, required this.status});

  @override
  Widget build(BuildContext context) {
    // Determine color based on status if needed
    // For now matching the visual of white boxes
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          "$day",
          style: const TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
