import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/class_attendance_controller.dart';
import '../controllers/branch_controller.dart';
import '../controllers/group_controller.dart';
import '../controllers/course_controller.dart';
import '../controllers/batch_controller.dart';
import '../controllers/shift_controller.dart';

class ClassAttendancePage extends StatefulWidget {
  const ClassAttendancePage({super.key});

  @override
  State<ClassAttendancePage> createState() => _ClassAttendancePageState();
}

class _ClassAttendancePageState extends State<ClassAttendancePage> {
  // ================= CONTROLLERS =================
  final BranchController branchCtrl = Get.put(BranchController());
  final GroupController groupCtrl = Get.put(GroupController());
  final CourseController courseCtrl = Get.put(CourseController());
  final BatchController batchCtrl = Get.put(BatchController());
  final ShiftController shiftCtrl = Get.put(ShiftController());
  final ClassAttendanceController controller = Get.put(
    ClassAttendanceController(),
  );

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    branchCtrl.loadBranches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildFilterContainer(context),
            ),
            const SizedBox(height: 40),
            _buildNoDataState(context),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 30,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF7E49FF), // Accurate purple from image
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
                color: Colors.white.withOpacity(0.25),
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
            "Class Attendance",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ================= FILTER CONTAINER =================

  Widget _buildFilterContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF), // Light Lavender
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Branch
          _buildDropdownField(
            label: "Branch",
            hint: "Select Branch",
            itemsCtrl: branchCtrl.branches,
            value: branchCtrl.selectedBranch.value?.branchName,
            onChanged: (v) {
              final model = branchCtrl.branches.firstWhereOrNull(
                (e) => e.branchName == v,
              );
              if (model != null) {
                branchCtrl.selectedBranch.value = model;
                groupCtrl.loadGroups(model.id);
                shiftCtrl.loadShifts(model.id);
                // Reset dependent selections
                groupCtrl.selectedGroup.value = null;
                courseCtrl.selectedCourse.value = null;
                batchCtrl.selectedBatch.value = null;
                shiftCtrl.selectedShift.value = null;
              }
            },
          ),
          const SizedBox(height: 15),

          // Group
          _buildDropdownField(
            label: "Group",
            hint: "Select Group",
            itemsCtrl: groupCtrl.groups,
            labelGetter: (e) => e.name,
            value: groupCtrl.selectedGroup.value?.name,
            onChanged: (v) {
              final model = groupCtrl.groups.firstWhereOrNull(
                (e) => e.name == v,
              );
              if (model != null) {
                groupCtrl.selectedGroup.value = model;
                courseCtrl.loadCourses(model.id);
                // Reset dependent
                courseCtrl.selectedCourse.value = null;
                batchCtrl.selectedBatch.value = null;
              }
            },
          ),
          const SizedBox(height: 15),

          // Course
          _buildDropdownField(
            label: "Course",
            hint: "Select Course",
            itemsCtrl: courseCtrl.courses,
            labelGetter: (e) => e.courseName,
            value: courseCtrl.selectedCourse.value?.courseName,
            onChanged: (v) {
              final model = courseCtrl.courses.firstWhereOrNull(
                (e) => e.courseName == v,
              );
              if (model != null) {
                courseCtrl.selectedCourse.value = model;
                batchCtrl.loadBatches(model.id);
                // Reset dependent
                batchCtrl.selectedBatch.value = null;
              }
            },
          ),
          const SizedBox(height: 15),

          // Batch
          _buildDropdownField(
            label: "Batch",
            hint: "Select Batch",
            itemsCtrl: batchCtrl.batches,
            labelGetter: (e) => e.batchName,
            value: batchCtrl.selectedBatch.value?.batchName,
            onChanged: (v) {
              final model = batchCtrl.batches.firstWhereOrNull(
                (e) => e.batchName == v,
              );
              if (model != null) {
                batchCtrl.selectedBatch.value = model;
              }
            },
          ),
          const SizedBox(height: 15),

          // Shift
          _buildDropdownField(
            label: "Shift",
            hint: "Select Shift",
            itemsCtrl: shiftCtrl.shifts,
            labelGetter: (e) => (e as dynamic).shiftName,
            value: shiftCtrl.selectedShift.value != null
                ? (shiftCtrl.selectedShift.value as dynamic).shiftName
                : null,
            onChanged: (v) {
              final model = shiftCtrl.shifts.firstWhereOrNull(
                (e) => (e as dynamic).shiftName == v,
              );
              if (model != null) {
                shiftCtrl.selectedShift.value = model;
              }
            },
          ),
          const SizedBox(height: 25),

          // GET STUDENTS BUTTON
          _buildGradientButton(),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required RxList itemsCtrl,
    String Function(dynamic)? labelGetter,
    String? value,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A4A4A),
            ),
          ),
        ),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                hint: Text(
                  hint,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                ),
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black54,
                ),
                items: itemsCtrl.map((item) {
                  final text = labelGetter != null
                      ? labelGetter(item)
                      : (item is String ? item : (item as dynamic).branchName);
                  return DropdownMenuItem<String>(
                    value: text,
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradientButton() {
    return GestureDetector(
      onTap: () {
        if (controller.isReady) {
          controller.loadClassAttendance();
        } else {
          Get.snackbar(
            "Selection Required",
            "Please select all filters to fetch attendance",
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(20),
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFFC084FC)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B5CF6).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Get Students",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  // ================= NO DATA STATE =================

  Widget _buildNoDataState(BuildContext context) {
    return Column(
      children: [
        Image.network(
          'https://cdni.iconscout.com/illustration/premium/thumb/no-data-found-8867280-7265556.png',
          height: 180,
          errorBuilder: (context, error, stackTrace) => Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F3FF),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Icon(
                    Icons.folder_open_rounded,
                    size: 80,
                    color: Color(0xFFC084FC),
                  ),
                  Positioned(
                    right: 20,
                    top: 20,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.question_mark_rounded,
                        size: 20,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "No Attendance Data",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Select filters and click 'Get Students' to view attendance",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
          ),
        ),
      ],
    );
  }
}
