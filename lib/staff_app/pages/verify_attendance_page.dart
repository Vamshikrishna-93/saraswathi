import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_app/staff_app/api/api_service.dart';
import 'package:student_app/staff_app/controllers/shift_controller.dart';
import 'package:student_app/staff_app/model/attendance_record_model.dart';
import '../controllers/branch_controller.dart';

class VerifyAttendancePage extends StatefulWidget {
  const VerifyAttendancePage({super.key});

  @override
  State<VerifyAttendancePage> createState() => _VerifyAttendancePageState();
}

class _VerifyAttendancePageState extends State<VerifyAttendancePage>
    with SingleTickerProviderStateMixin {
  String? selectedBranch;
  String? selectedShift;

  bool isLoading = false;
  bool isSubmitting = false;
  List<AttendanceRecord> attendanceData = [];

  late AnimationController _animationController;

  // ================= CONTROLLERS =================
  final BranchController branchCtrl = Get.put(BranchController());
  final ShiftController shiftCtrl = Get.put(ShiftController());

  List<String> branches = [];

  // ================= DARK COLORS =================
  final Color darkBg1 = const Color(0xFF1a1a2e);
  final Color darkBg2 = const Color(0xFF16213e);
  final Color darkBg3 = const Color(0xFF0f3460);
  final Color darkBg4 = const Color(0xFF533483);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Load branches
    branchCtrl.loadBranches();

    // Population logic
    void populateInitialData() {
      if (branchCtrl.branches.isNotEmpty) {
        setState(() {
          branches = branchCtrl.branches.map((b) => b.branchName).toList();

          if (selectedBranch == null) {
            selectedBranch = branches.first;
            final branch = branchCtrl.branches.first;
            shiftCtrl.loadShifts(branch.id);
          }
        });
      }
    }

    // Auto-load if already present
    populateInitialData();

    // Auto-load when data arrives
    ever(branchCtrl.branches, (_) => populateInitialData());

    // Auto-select shift
    ever(shiftCtrl.shifts, (List sList) {
      if (sList.isNotEmpty && selectedShift == null) {
        setState(() {
          selectedShift = sList.first.shiftName;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ================= FETCH =================
  Future<void> _fetchAttendanceData() async {
    if (selectedBranch == null || selectedShift == null) {
      _showSnackBar('Please select Branch & Shift', Colors.orange);
      return;
    }

    try {
      setState(() {
        isLoading = true;
        attendanceData.clear();
      });

      // get selected branch id
      final branch = branchCtrl.branches.firstWhere(
        (b) => b.branchName == selectedBranch,
      );

      // get selected shift id
      final shift = shiftCtrl.shifts.firstWhere(
        (s) => s.shiftName == selectedShift,
      );

      // 🔥 API CALL (Detailed endpoint to get all totals)
      final result = await ApiService.getVerifyAttendanceDetailed(
        branchId: branch.id,
        shiftId: shift.id,
      );

      setState(() {
        attendanceData = result
            .map((e) => AttendanceRecord.fromJson(e))
            .toList();
        isLoading = false;
      });

      _animationController.forward(from: 0);

      if (attendanceData.isEmpty) {
        _showSnackBar('No attendance found', Colors.orange);
      } else {
        _showSnackBar('Attendance Loaded', Colors.green);
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showSnackBar(e.toString(), Colors.red);
    }
  }

  void _showSnackBar(String msg, Color color) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ================= UI Constants =================
  static const Color primaryPurple = Color(0xFF7E49FF);
  static const Color lavenderBg = Color(0xFFE8EEFF);

  @override
  Widget build(BuildContext context) {
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
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
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
                  "Verify Attendance",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select filters to verify attendance",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // ================= FILTER CARD =================
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: lavenderBg,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        _buildDropdownField(
                          label: "Branch",
                          hint: "Select Branch",
                          value: selectedBranch,
                          items: branches,
                          onChanged: (v) {
                            setState(() {
                              selectedBranch = v;
                              selectedShift = null;
                            });
                            final branchObj = branchCtrl.branches.firstWhere(
                              (b) => b.branchName == v,
                            );
                            shiftCtrl.loadShifts(branchObj.id);
                          },
                        ),
                        const SizedBox(height: 15),
                        Obx(
                          () => _buildDropdownField(
                            label: "Shift",
                            hint: "Select Shift",
                            value: selectedShift,
                            items: shiftCtrl.shifts
                                .map((e) => e.shiftName)
                                .toList(),
                            onChanged: (v) => setState(() => selectedShift = v),
                          ),
                        ),
                        const SizedBox(height: 25),

                        // VERIFY BUTTON
                        _buildGradientButton(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ================= CONTENT =================
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(color: primaryPurple),
                    )
                  else if (attendanceData.isEmpty)
                    _buildEmptyState()
                  else
                    _buildAttendanceList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required List<String> items,
    String? value,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                hint,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              ),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: primaryPurple),
              items: items.map((String text) {
                return DropdownMenuItem<String>(
                  value: text,
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradientButton() {
    return GestureDetector(
      onTap: isLoading ? null : _fetchAttendanceData,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFFC084FC)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B5CF6).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLoading ? "Loading..." : "Verify Attendance",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          Image.network(
            "https://cdni.iconscout.com/illustration/premium/thumb/no-data-found-8867280-7223912.png",
            height: 180,
            errorBuilder: (c, e, s) => const Icon(
              Icons.folder_open_rounded,
              size: 100,
              color: lavenderBg,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "No Attendance Data",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceList() {
    return Column(
      children: attendanceData
          .map((record) => _buildRecordCard(record))
          .toList(),
    );
  }

  Widget _buildRecordCard(AttendanceRecord record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: lavenderBg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                record.batch,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Shift Wise",
                  style: TextStyle(
                    color: primaryPurple,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 15,
            runSpacing: 10,
            children: [
              _statMiniItem("TOTAL", record.total, Colors.blue),
              _statMiniItem("PRESENT", record.present, Colors.green),
              _statMiniItem("ABSENT", record.absent, Colors.red),
              _statMiniItem("OUTING", record.totalOuting, Colors.orange),
              _statMiniItem("HOME PASS", record.totalHomePass, Colors.purple),
              _statMiniItem("S.OUTING", record.totalSelfOuting, Colors.teal),
              _statMiniItem("S.HOME", record.totalSelfHome, Colors.indigo),
              _statMiniItem("MISSING", record.totalMissing, Colors.redAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statMiniItem(String label, int value, Color color) {
    return SizedBox(
      width: 55,
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
