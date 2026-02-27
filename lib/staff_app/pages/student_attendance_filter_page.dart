import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_app/staff_app/controllers/monthly_attendance_controller.dart';
import 'package:student_app/staff_app/controllers/shift_controller.dart';
import 'package:student_app/staff_app/get_student_pages/student_month_attendance_page.dart';
import 'package:student_app/staff_app/widgets/skeleton.dart';
import '../controllers/branch_controller.dart';
import '../controllers/group_controller.dart';
import '../controllers/course_controller.dart';
import '../controllers/batch_controller.dart';

class StudentAttendanceFilterPage extends StatefulWidget {
  const StudentAttendanceFilterPage({super.key});

  @override
  State<StudentAttendanceFilterPage> createState() =>
      _StudentAttendanceFilterPageState();
}

class _StudentAttendanceFilterPageState
    extends State<StudentAttendanceFilterPage> {
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
  String? month = "01"; // Default month if not provided
  String? selectedMonthName = "January";

  @override
  void initState() {
    super.initState();
    branchCtrl.loadBranches();

    // Population logic
    void populateInitialBranch() {
      if (branchCtrl.branches.isNotEmpty && branch == null) {
        final b = branchCtrl.branches.first;
        setState(() {
          branch = b.branchName;
        });
        groupCtrl.loadGroups(b.id);
        shiftCtrl.loadShifts(b.id);
      }
    }

    // Auto-load if already present
    populateInitialBranch();

    // Auto-load when data arrives
    ever(branchCtrl.branches, (_) => populateInitialBranch());

    ever(groupCtrl.groups, (groups) {
      if (groups.isNotEmpty && group == null) {
        final g = groups.first;
        setState(() {
          group = g.name;
        });
        courseCtrl.loadCourses(g.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= HEADER =================
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 10,
                bottom: 30,
                left: 20,
                right: 20,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF7E49FF), // Accurate Purple from image
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    "Class Attendance",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ================= FILTER CONTAINER (CARD) =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F3FF),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // BRANCH
                    Obx(
                      () => _buildFilterRow(
                        "Branch",
                        "Select Branch",
                        branch,
                        branchCtrl.branches.map((b) => b.branchName).toList(),
                        (v) {
                          final b = branchCtrl.branches.firstWhere(
                            (e) => e.branchName == v,
                          );
                          setState(() {
                            branch = v;
                            group = course = batch = shift = null;
                          });
                          groupCtrl.loadGroups(b.id);
                          shiftCtrl.loadShifts(b.id);
                        },
                      ),
                    ),
                    // GROUP
                    Obx(
                      () => _buildFilterRow(
                        "Group",
                        "Select Group",
                        group,
                        groupCtrl.groups.map((g) => g.name).toList(),
                        (v) {
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
                    // COURSE
                    Obx(
                      () => _buildFilterRow(
                        "Course",
                        "Select Course",
                        course,
                        courseCtrl.courses.map((c) => c.courseName).toList(),
                        (v) {
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
                    // BATCH
                    Obx(
                      () => _buildFilterRow(
                        "Batch",
                        "Select Batch",
                        batch,
                        batchCtrl.batches.map((b) => b.batchName).toList(),
                        (v) => setState(() => batch = v),
                      ),
                    ),
                    // SHIFT
                    Obx(
                      () => _buildFilterRow(
                        "Shift",
                        "Select Shift",
                        shift,
                        shiftCtrl.shifts.map((s) => s.shiftName).toList(),
                        (v) => setState(() => shift = v),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // GET STUDENTS BUTTON
                    _buildActionButton(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ================= EMPTY STATE =================
            Column(
              children: [
                Image.network(
                  'https://cdni.iconscout.com/illustration/premium/thumb/folder-illustration-download-in-svg-png-gif-file-formats--personal-file-document-records-pack-business-illustrations-4648711.png',
                  height: 160,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.folder_open_rounded,
                    size: 80,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "No Attendance Data",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Select filters and click 'Get Students' to view attendance",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow(
    String label,
    String hint,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: items.contains(value) ? value : null,
                isExpanded: true,
                hint: Text(
                  hint,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black54,
                  size: 20,
                ),
                items: items
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
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

  Widget _buildActionButton() {
    return Obx(() {
      final isLoading = attendanceCtrl.isLoading.value;

      return GestureDetector(
        onTap: isLoading
            ? null
            : () async {
                if ([branch, group, course, batch, shift].contains(null)) {
                  Get.snackbar(
                    "Selection Required",
                    "Please select all filters to continue",
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(20),
                  );
                  return;
                }

                await attendanceCtrl.loadAttendance(
                  branchId: branchCtrl.branches
                      .firstWhere((e) => e.branchName == branch!)
                      .id,
                  groupId: groupCtrl.groups
                      .firstWhere((e) => e.name == group!)
                      .id,
                  courseId: courseCtrl.courses
                      .firstWhere((e) => e.courseName == course!)
                      .id,
                  batchId: batchCtrl.batches
                      .firstWhere((e) => e.batchName == batch!)
                      .id,
                  shiftId: shiftCtrl.shifts
                      .firstWhere((e) => e.shiftName == shift!)
                      .id,
                  month: month ?? "01",
                );

                Get.to(
                  () => StudentMonthAttendancePage(
                    studentName: "Students",
                    monthName: selectedMonthName ?? "January",
                    year: DateTime.now().year,
                    admNo: '',
                  ),
                );
              },
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFFC084FC)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5CF6).withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: isLoading
                ? const StaffLoadingAnimation()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }
}
