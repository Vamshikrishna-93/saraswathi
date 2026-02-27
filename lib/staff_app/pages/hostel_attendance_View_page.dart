import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/branch_controller.dart';

class HostelAttendanceFilterPage extends StatefulWidget {
  const HostelAttendanceFilterPage({super.key});

  @override
  State<HostelAttendanceFilterPage> createState() =>
      _HostelAttendanceFilterPageState();
}

class _HostelAttendanceFilterPageState
    extends State<HostelAttendanceFilterPage> {
  String? _branch;
  String? _hostel;
  String? _floor;
  String? _room;
  String? _month;

  final BranchController branchCtrl = Get.put(BranchController());

  final List<String> hostels = ['ADARSA', 'VIDHYA'];
  final List<String> floors = ['First Floor', 'Second Floor', 'Third Floor'];
  final List<String> rooms = ['C-201', 'C-202', 'C-203', 'C-204'];
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    branchCtrl.loadBranches();

    // Population logic
    void populateInitialBranch() {
      if (branchCtrl.branches.isNotEmpty && _branch == null) {
        setState(() {
          _branch = branchCtrl.branches.first.branchName;
        });
      }
    }

    // Auto-load if already present
    populateInitialBranch();

    // Auto-load when data arrives
    ever(branchCtrl.branches, (_) => populateInitialBranch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildFilterContainer(context),
                  const SizedBox(height: 30),
                  _buildNoDataState(context),
                ],
              ),
            ),
          ),
        ],
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
        ),
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
            "Hostel Attendance",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
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
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Branch
          Obx(
            () => _buildDropdownField(
              label: "Branch",
              hint: "Select Branch",
              items: branchCtrl.branches.map((b) => b.branchName).toList(),
              value: _branch,
              onChanged: (v) => setState(() => _branch = v),
            ),
          ),
          const SizedBox(height: 18),

          // Hostel
          _buildDropdownField(
            label: "Hostel",
            hint: "Select Hostel",
            items: hostels,
            value: _hostel,
            onChanged: (v) => setState(() => _hostel = v),
          ),
          const SizedBox(height: 18),

          // Floor
          _buildDropdownField(
            label: "Floor",
            hint: "Select Floor",
            items: floors,
            value: _floor,
            onChanged: (v) => setState(() => _floor = v),
          ),
          const SizedBox(height: 18),

          // Room
          _buildDropdownField(
            label: "Room",
            hint: "Select Room",
            items: rooms,
            value: _room,
            onChanged: (v) => setState(() => _room = v),
          ),
          const SizedBox(height: 18),

          // Month
          _buildDropdownField(
            label: "Month",
            hint: "Select Month",
            items: months,
            value: _month,
            onChanged: (v) => setState(() => _month = v),
          ),
          const SizedBox(height: 30),

          // GET STUDENTS BUTTON
          _buildGradientButton(),
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
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                hint,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              ),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.blue),
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
      onTap: () {
        if (_branch != null &&
            _hostel != null &&
            _floor != null &&
            _room != null &&
            _month != null) {
          Get.toNamed('/hostelAttendanceResult');
        } else {
          Get.snackbar(
            "Selection Required",
            "Please select all fields to fetch attendance",
            backgroundColor: Colors.orange.withOpacity(0.1),
            colorText: Colors.orange.shade800,
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFFC084FC)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B5CF6).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
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
                fontSize: 16,
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
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
              Icons
                  .hotel_rounded, // Changed to hotel icon for Hostel Attendance
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
        const SizedBox(height: 24),
        const Text(
          "No Attendance Data",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Select filters and click 'Get Students' to view attendance",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
