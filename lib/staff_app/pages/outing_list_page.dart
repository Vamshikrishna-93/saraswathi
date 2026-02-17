import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/branch_controller.dart';
import '../controllers/outing_controller.dart';
import '../widgets/skeleton.dart';
import 'issue_outing.dart';

class OutingListPage extends StatefulWidget {
  const OutingListPage({super.key});

  @override
  State<OutingListPage> createState() => _OutingListPageState();
}

class _OutingListPageState extends State<OutingListPage> {
  bool showStudents = false;
  final TextEditingController searchController = TextEditingController();
  final BranchController branchController = Get.put(BranchController());
  final OutingController controller = Get.put(OutingController());

  String selectedBranch = "All";
  String selectedStatus = "All";
  String selectedDuration = "All";
  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();
    branchController.loadBranches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildStatsGrid(),
                            const SizedBox(height: 25),
                            _buildSearchBar(),
                            const SizedBox(height: 25),
                            _buildFilterSection(),
                            const SizedBox(height: 25),
                            if (showStudents) _buildStudentList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStickyBottomButton(),
              ],
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
        bottom: 25,
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
            "Outing List",
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

  // ================= STATS GRID =================
  Widget _buildStatsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double itemWidth = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            // Row 1: Out Pass, Self Outing
            _buildObxCard(
              "Out Pass",
              controller.outPassInfo,
              itemWidth,
              const [Color(0xFF10B981), Color(0xFF34D399)],
              Icons.exit_to_app_rounded,
            ),
            _buildObxCard(
              "Self Outing",
              controller.selfOutingInfo,
              itemWidth,
              const [Color(0xFFF43F5E), Color(0xFFFB7185)],
              Icons.exit_to_app_rounded,
            ),
            // Row 2: Home Pass, Self Home
            _buildObxCard(
              "Home Pass",
              controller.homePassInfo,
              itemWidth,
              const [Color(0xFF3B82F6), Color(0xFF60A5FA)],
              Icons.home_rounded,
            ),
            _buildObxCard(
              "Self Home",
              controller.selfHomeInfo,
              itemWidth,
              const [Color(0xFFF59E0B), Color(0xFFFBBF24)],
              Icons.home_rounded,
            ),
          ],
        );
      },
    );
  }

  Widget _buildObxCard(
    String title,
    Rx infoRx,
    double width,
    List<Color> colors,
    IconData icon,
  ) {
    return SizedBox(
      width: width,
      child: Obx(() {
        final info = infoRx.value;
        return _outingCard(
          title,
          info?.total.toString() ?? "0",
          colors,
          icon,
          pending: info?.pending ?? 0,
          approved: info?.approved ?? 0,
          notReported: info?.notReported ?? 0,
        );
      }),
    );
  }

  Widget _outingCard(
    String title,
    String count,
    List<Color> gradientColors,
    IconData icon, {
    required int pending,
    required int approved,
    required int notReported,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -20,
            bottom: -20,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),
          Positioned(
            right: -10,
            bottom: -10,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(icon, color: Colors.white, size: 24),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                count,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildStatRow("Pending", pending),
              _buildStatRow("Approved", approved),
              _buildStatRow("Not Reported", notReported),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        "$label : $value",
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  // ================= SEARCH BAR =================
  Widget _buildSearchBar() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC084FC).withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: controller.search,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Search Student or ID",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= FILTER SECTION =================
  Widget _buildFilterSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filter Options",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          _buildDropdownWrapper(
            child: Obx(() {
              return DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedBranch,
                  isExpanded: true,
                  hint: const Text("Campus"),
                  items: [
                    const DropdownMenuItem(value: "All", child: Text("All")),
                    ...branchController.branches.map(
                      (b) => DropdownMenuItem(
                        value: b.id.toString(),
                        child: Text(b.branchName),
                      ),
                    ),
                  ],
                  onChanged: (v) {
                    setState(() => selectedBranch = v!);
                    controller.filterByBranch(v!);
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          _buildDropdownWrapper(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedStatus,
                isExpanded: true,
                hint: const Text("Status"),
                items: const ["All", "Pending", "Approved", "Not Reported"]
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) {
                  setState(() => selectedStatus = v!);
                  controller.filterByStatus(v!);
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildDropdownWrapper(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedDuration,
                isExpanded: true,
                hint: const Text("Duration"),
                items:
                    const [
                          "All",
                          "Today",
                          "Yesterday",
                          "Last 7 Days",
                          "This Month",
                          "Custom",
                        ]
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                onChanged: (v) {
                  setState(() => selectedDuration = v!);
                  if (v != "Custom") {
                    controller.filterByDate(v!.replaceAll(" ", ""));
                  }
                },
              ),
            ),
          ),
          if (selectedDuration == "Custom") ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDateChip(
                    "From: ${fromDate?.toString().substring(0, 10) ?? 'Select'}",
                    onTap: () async {
                      fromDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        initialDate: DateTime.now(),
                      );
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDateChip(
                    "To: ${toDate?.toString().substring(0, 10) ?? 'Select'}",
                    onTap: () async {
                      toDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        initialDate: DateTime.now(),
                      );
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            if (fromDate != null && toDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TextButton(
                  onPressed: () =>
                      controller.filterByCustomDate(fromDate!, toDate!),
                  child: const Text("Apply Date Range"),
                ),
              ),
          ],
          const SizedBox(height: 25),
          GestureDetector(
            onTap: () => setState(() => showStudents = true),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFC084FC), Color(0xFFA855F7)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "Apply Filters",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownWrapper({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: child,
    );
  }

  Widget _buildDateChip(String text, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Text(text, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  // ================= STUDENT LIST =================
  Widget _buildStudentList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: StaffLoadingAnimation());
      }
      if (controller.filteredList.isEmpty) {
        return const Center(
          child: Text("No records found", style: TextStyle(color: Colors.grey)),
        );
      }
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.filteredList.length,
        itemBuilder: (context, index) {
          final o = controller.filteredList[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                o.studentName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ID: ${o.admno}"),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text("${o.outDate} • ${o.outingTime}"),
                    ],
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: o.status == "Approved"
                          ? Colors.green.shade100
                          : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      o.status,
                      style: TextStyle(
                        color: o.status == "Approved"
                            ? Colors.green.shade800
                            : Colors.orange.shade800,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    o.outingType,
                    style: const TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  // ================= STICKY BOTTOM BUTTON =================
  Widget _buildStickyBottomButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            Get.to(
              () => const IssueOutingPage(studentName: '', outingType: ''),
            );
          },
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF34D399), Color(0xFF84CC16)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "Issue Outing",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
