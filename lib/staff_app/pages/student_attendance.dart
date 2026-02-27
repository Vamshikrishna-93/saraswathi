import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_app/staff_app/controllers/monthly_attendance_controller.dart';
import 'package:student_app/staff_app/controllers/shift_controller.dart';
import 'package:student_app/staff_app/get_student_pages/student_month_attendance_page.dart';
import 'package:student_app/staff_app/controllers/main_controller.dart';

import '../controllers/branch_controller.dart';
import '../controllers/group_controller.dart';
import '../controllers/course_controller.dart';
import '../controllers/batch_controller.dart';

class StudentAttendancePage extends StatefulWidget {
  const StudentAttendancePage({super.key});

  @override
  State<StudentAttendancePage> createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  // ================= CONTROLLERS =================
  final BranchController branchCtrl = Get.put(BranchController());
  final GroupController groupCtrl = Get.put(GroupController());
  final CourseController courseCtrl = Get.put(CourseController());
  final BatchController batchCtrl = Get.put(BatchController());
  final ShiftController shiftCtrl = Get.put(ShiftController());
  final MonthlyAttendanceController attendanceCtrl = Get.put(
    MonthlyAttendanceController(),
  );

  // ================= SELECTED VALUES =================
  String? branch;
  String? group;
  String? course;
  String? batch;
  String? shift;
  String? month;
  String? selectedMonthName;

  final Map<String, String> monthMap = {
    "January": "01",
    "February": "02",
    "March": "03",
    "April": "04",
    "May": "05",
    "June": "06",
    "July": "07",
    "August": "08",
    "September": "09",
    "October": "10",
    "November": "11",
    "December": "12",
  };

  @override
  void initState() {
    super.initState();

    branchCtrl.loadBranches();

    ever(branchCtrl.branches, (_) {
      if (branchCtrl.branches.isNotEmpty && branch == null) {
        final b = branchCtrl.branches.first;
        branch = b.branchName;
        groupCtrl.loadGroups(b.id);
        setState(() {});
      }
    });

    ever(groupCtrl.groups, (_) {
      if (groupCtrl.groups.isNotEmpty && group == null) {
        final g = groupCtrl.groups.first;
        group = g.name;
        courseCtrl.loadCourses(g.id);
        setState(() {});
      }
    });

    Get.put(StaffMainController(), permanent: true).changeIndex(1);
  }

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF7E49FF);
    const lavenderBg = Color(0xFFE8EEFF);

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
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
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
                const SizedBox(width: 15),
                const Text(
                  "Students Attendance",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select filters to view students attendance\nrecords",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ================= FILTER CARD =================
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: lavenderBg,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: [
                        Obx(
                          () => _buildFilterField(
                            label: "Branch",
                            value: branch,
                            items: branchCtrl.branches
                                .map((b) => b.branchName)
                                .toList(),
                            onChanged: (v) {
                              final b = branchCtrl.branches.firstWhere(
                                (e) => e.branchName == v,
                              );
                              setState(() {
                                branch = v;
                                group = course = batch = shift = month = null;
                                selectedMonthName = null;
                              });
                              groupCtrl.loadGroups(b.id);
                              shiftCtrl.loadShifts(b.id);
                            },
                          ),
                        ),
                        Obx(
                          () => _buildFilterField(
                            label: "Group",
                            value: group,
                            items: groupCtrl.groups.map((g) => g.name).toList(),
                            onChanged: (v) {
                              final g = groupCtrl.groups.firstWhere(
                                (e) => e.name == v,
                              );
                              setState(() {
                                group = v;
                                course = batch = null;
                              });
                              courseCtrl.loadCourses(g.id);
                            },
                          ),
                        ),
                        Obx(
                          () => _buildFilterField(
                            label: "Course",
                            value: course,
                            items: courseCtrl.courses
                                .map((c) => c.courseName)
                                .toList(),
                            onChanged: (v) {
                              final c = courseCtrl.courses.firstWhere(
                                (e) => e.courseName == v,
                              );
                              setState(() {
                                course = v;
                                batch = null;
                              });
                              batchCtrl.loadBatches(c.id);
                            },
                          ),
                        ),
                        Obx(
                          () => _buildFilterField(
                            label: "Batch",
                            value: batch,
                            items: batchCtrl.batches
                                .map((b) => b.batchName)
                                .toList(),
                            onChanged: (v) => setState(() => batch = v),
                          ),
                        ),
                        Obx(
                          () => _buildFilterField(
                            label: "Shift",
                            value: shift,
                            items: shiftCtrl.shifts
                                .map((s) => s.shiftName)
                                .toList(),
                            onChanged: (v) => setState(() => shift = v),
                          ),
                        ),
                        _buildFilterField(
                          label: "Month",
                          value: selectedMonthName,
                          items: monthMap.keys.toList(),
                          onChanged: (v) => setState(() {
                            selectedMonthName = v;
                            month = monthMap[v!];
                          }),
                        ),
                        const SizedBox(height: 10),

                        // ================= GET STUDENTS BUTTON =================
                        Obx(
                          () => Container(
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF818CFF), Color(0xFFCE93F9)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ElevatedButton(
                              onPressed: (attendanceCtrl.isLoading.value)
                                  ? null
                                  : () async {
                                      if ([
                                        branch,
                                        group,
                                        course,
                                        batch,
                                        shift,
                                        month,
                                      ].contains(null)) {
                                        Get.snackbar(
                                          "Error",
                                          "Please select all filters",
                                        );
                                        return;
                                      }
                                      await attendanceCtrl.loadAttendance(
                                        branchId: branchCtrl.branches
                                            .firstWhere(
                                              (e) => e.branchName == branch!,
                                            )
                                            .id,
                                        groupId: groupCtrl.groups
                                            .firstWhere((e) => e.name == group!)
                                            .id,
                                        courseId: courseCtrl.courses
                                            .firstWhere(
                                              (e) => e.courseName == course!,
                                            )
                                            .id,
                                        batchId: batchCtrl.batches
                                            .firstWhere(
                                              (e) => e.batchName == batch!,
                                            )
                                            .id,
                                        shiftId: shiftCtrl.shifts
                                            .firstWhere(
                                              (e) => e.shiftName == shift!,
                                            )
                                            .id,
                                        month: month!,
                                      );

                                      Get.to(
                                        () => StudentMonthAttendancePage(
                                          studentName: "Students",
                                          monthName: selectedMonthName!,
                                          year: DateTime.now().year,
                                          admNo: '',
                                        ),
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: attendanceCtrl.isLoading.value
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "Get Students",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                hint: Text(
                  "Select $label",
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black54,
                ),
                items: items
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
