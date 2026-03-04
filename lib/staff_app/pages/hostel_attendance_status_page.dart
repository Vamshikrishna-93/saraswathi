import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hostel_controller.dart';
import '../widgets/skeleton.dart';

class HostelAttendanceStatusPage extends StatelessWidget {
  const HostelAttendanceStatusPage({super.key});

  // COLORS
  static const Color neon = Color(0xFF00FFF5);
  static const Color darkNavy = Color(0xFF1a1a2e);
  static const Color darkBlue = Color(0xFF16213e);
  static const Color midBlue = Color(0xFF0f3460);
  static const Color purpleDark = Color(0xFF533483);

  @override
  Widget build(BuildContext context) {
    final HostelController hostelCtrl = Get.find<HostelController>();
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── HEADER ──────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: topPad + 12,
              bottom: 28,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF7C3AED), // Premium Purple
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
                  'Hostel Attendance Status',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ── BODY LAVENDER CONTAINER ──────────────────────────────
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0FF), // Soft Lavender
                borderRadius: BorderRadius.circular(24),
              ),
              child: Obx(() {
                if (hostelCtrl.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: SkeletonList(itemCount: 5),
                  );
                }

                if (hostelCtrl.roomsSummary.isEmpty) {
                  return const Center(
                    child: Text(
                      "No data available",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  itemCount: hostelCtrl.roomsSummary.length,
                  itemBuilder: (context, index) {
                    final row = hostelCtrl.roomsSummary[index];
                    return _AttendanceStatusCard(row: row, index: index + 1);
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceStatusCard extends StatelessWidget {
  final Map<String, dynamic> row;
  final int index;

  const _AttendanceStatusCard({required this.row, required this.index});

  @override
  Widget build(BuildContext context) {
    final room = row['room']?.toString() ?? '-';
    final floor = row['floor']?.toString() ?? '-';
    final incharge = row['incharge']?.toString() ?? 'N/A';
    final total = int.tryParse(row['total']?.toString() ?? '17') ?? 17;
    final present = int.tryParse(row['present']?.toString() ?? '0') ?? 0;
    final outing = int.tryParse(row['outing']?.toString() ?? '0') ?? 0;
    final homePass = int.tryParse(row['home_pass']?.toString() ?? '0') ?? 0;
    final selfOuting = int.tryParse(row['self_outing']?.toString() ?? '0') ?? 0;
    final selfHome = int.tryParse(row['self_home']?.toString() ?? '0') ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: S.No and Room Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "S.NO: $index",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  room,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 15),

          // Floor and Incharge Info
          _buildRichInfo('Floor : ', floor),
          const SizedBox(height: 8),
          _buildRichInfo('Incharge : ', incharge),

          const SizedBox(height: 20),

          // Metrics Grid (3x2)
          Column(
            children: [
              Row(
                children: [
                  _MetricBadge(
                    label: "Total",
                    value: "$total",
                    color: const Color(0xFF2196F3),
                  ),
                  const SizedBox(width: 10),
                  _MetricBadge(
                    label: "Present",
                    value: "$present",
                    color: const Color(0xFF4CAF50),
                  ),
                  const SizedBox(width: 10),
                  _MetricBadge(
                    label: "Outing",
                    value: "$outing",
                    color: const Color(0xFFF59E0B),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _MetricBadge(
                    label: "Home Pass",
                    value: "$homePass",
                    color: const Color(0xFF7C3AED),
                  ),
                  const SizedBox(width: 10),
                  _MetricBadge(
                    label: "Self Outing",
                    value: "$selfOuting",
                    color: const Color(0xFF06B6D4),
                  ),
                  const SizedBox(width: 10),
                  _MetricBadge(
                    label: "Self Home",
                    value: "$selfHome",
                    color: const Color(0xFF3B82F6),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRichInfo(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 15),
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}

class _MetricBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.6), width: 1.2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color.withOpacity(0.9),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
