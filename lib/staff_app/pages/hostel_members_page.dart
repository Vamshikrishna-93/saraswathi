import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/branch_controller.dart';
import 'assign_students_page.dart';

class HostelMembersPage extends StatefulWidget {
  const HostelMembersPage({super.key});

  @override
  State<HostelMembersPage> createState() => _HostelMembersPageState();
}

class _HostelMembersPageState extends State<HostelMembersPage> {
  // ================= UI Constants =================
  static const Color primaryPurple = Color(0xFF7E49FF);
  static const Color lavenderBg = Color(0xFFF1F4FF);

  final BranchController branchCtrl = Get.put(BranchController());

  // Filter Values
  String? selectedHostel;
  int? selectedBranchId;

  // Mock Data List
  final List<Map<String, String>> _hostelMembers = [
    {
      'name': 'TIRUMALARADDY VENKATA KEER..',
      'admNo': '241400',
      'branch': 'SSJC-SSG EAMCET CAMPUS',
      'group': 'G3',
    },
    {
      'name': 'B. RAJESH KUMAR',
      'admNo': '241401',
      'branch': 'SSJC-SSG EAMCET CAMPUS',
      'group': 'G1',
    },
    {
      'name': 'CH. SAI TEJA',
      'admNo': '241402',
      'branch': 'SSJC-SSG EAMCET CAMPUS',
      'group': 'G2',
    },
    {
      'name': 'D. MAHESH',
      'admNo': '241403',
      'branch': 'SSJC-SSG EAMCET CAMPUS',
      'group': 'G3',
    },
  ];

  String _query = "";

  @override
  void initState() {
    super.initState();
    branchCtrl.loadBranches();
  }

  @override
  Widget build(BuildContext context) {
    // Logic to check if filter is selected to show data or empty state
    final bool showData = selectedHostel != null && selectedBranchId != null;

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
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                const Text(
                  "Hostel Members",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ================= FILTERS =================
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Column(
              children: [
                _buildLabel("Hostel"),
                _buildDropdown(
                  hint: "Hostel Wise",
                  value: selectedHostel,
                  items: ["Hostel Wise", "Floor Wise", "Room Wise"],
                  onChanged: (val) => setState(() => selectedHostel = val),
                ),
                const SizedBox(height: 12),
                _buildLabel("Branch"),
                Obx(
                  () => _buildDropdown(
                    hint: "Select Branch",
                    value: branchCtrl.branches
                        .firstWhereOrNull((b) => b.id == selectedBranchId)
                        ?.branchName,
                    items: branchCtrl.branches
                        .map((b) => b.branchName)
                        .toList(),
                    onChanged: (val) {
                      final selected = branchCtrl.branches.firstWhere(
                        (b) => b.branchName == val,
                      );
                      setState(() => selectedBranchId = selected.id);
                    },
                  ),
                ),
              ],
            ),
          ),

          // ================= MAIN CONTAINER =================
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: lavenderBg.withOpacity(0.5),
                borderRadius: BorderRadius.circular(30),
              ),
              child: !showData
                  ? _buildEmptyState()
                  : Column(
                      children: [
                        // Search inside container
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: primaryPurple.withOpacity(0.3),
                              ),
                            ),
                            child: TextField(
                              onChanged: (v) => setState(() => _query = v),
                              decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.black54,
                                  size: 20,
                                ),
                                hintText: "Search by Name, Adm No, Room....",
                                hintStyle: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 13,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 0,
                            ),
                            itemCount: _hostelMembers
                                .where(
                                  (m) =>
                                      m['name']!.toLowerCase().contains(
                                        _query.toLowerCase(),
                                      ) ||
                                      m['admNo']!.contains(_query),
                                )
                                .length,
                            itemBuilder: (context, i) {
                              final filtered = _hostelMembers
                                  .where(
                                    (m) =>
                                        m['name']!.toLowerCase().contains(
                                          _query.toLowerCase(),
                                        ) ||
                                        m['admNo']!.contains(_query),
                                  )
                                  .toList();
                              return _memberCard(filtered[i], i);
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          // ================= ASSIGN STUDENTS BUTTON =================
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C69FF), Color(0xFFD38DFA)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ElevatedButton.icon(
                onPressed: () =>
                    Get.to(() => const AssignStudentsPage(students: [])),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Assign Students",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            "https://cdni.iconscout.com/illustration/premium/thumb/searching-concept-illustration-download-in-svg-png-gif-file-formats--person-magnifying-glass-data-find-pack-business-illustrations-4712431.png",
            height: 200,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.cloud_off, size: 80, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Please select a branch to view categories",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _memberCard(Map<String, String> data, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // G3 Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: primaryPurple,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              data['group'] ?? 'G3',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data['name']!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 12),
          _infoRow("Adm No", data['admNo']!),
          const SizedBox(height: 4),
          _infoRow("Branch", data['branch'] ?? 'SSJC-SSG EAMCET CAMPUS'),
          const SizedBox(height: 14),
          Row(
            children: [
              _circleIcon(Icons.edit, () {
                Get.snackbar(
                  "Info",
                  "Edit member: ${data['name']}",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: primaryPurple.withOpacity(0.1),
                );
              }),
              const SizedBox(width: 10),
              _circleIcon(Icons.delete, () {
                _showDeleteDialog(index);
              }),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(int index) {
    Get.defaultDialog(
      title: "Delete Member",
      middleText: "Are you sure you want to remove this member from hostel?",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        setState(() {
          _hostelMembers.removeAt(index);
        });
        Get.back();
        Get.snackbar(
          "Removed",
          "Member removed successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      onCancel: () {},
    );
  }

  Widget _infoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 13),
        children: [
          TextSpan(
            text: "$label : ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: primaryPurple,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, left: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            text: text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            children: const [
              TextSpan(
                text: " *",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(
            hint,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
