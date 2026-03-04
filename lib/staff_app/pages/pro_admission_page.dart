import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class ProAdmissionPage extends StatelessWidget {
  const ProAdmissionPage({super.key});

  static const List<Map<String, dynamic>> admissionsData = [
    {"pro": "SUBBARAO-HRAO", "target": 250, "achieved": 186},
    {"pro": "MEERA REDDY", "target": 200, "achieved": 137},
    {"pro": "CHIRANJEEVI - NAGARAJU", "target": 125, "achieved": 112},
    {"pro": "PARVEEN-NAGALAKSHMI", "target": 100, "achieved": 111},
    {"pro": "AO SRINIVAS-BASAVAIAH", "target": 180, "achieved": 104},
    {"pro": "RAMESH -HARI-MADDIPADU", "target": 100, "achieved": 104},
    {"pro": "N SRINU-TANGUTUR", "target": 180, "achieved": 103},
    {"pro": "B T NAIDU", "target": 125, "achieved": 100},
    {"pro": "JURI VENKATA RAO", "target": 150, "achieved": 90},
    {"pro": "ARUN KUMAR", "target": 120, "achieved": 85},
    {"pro": "SUBBARAO-HRAO", "target": 250, "achieved": 186},
    {"pro": "MEERA REDDY", "target": 200, "achieved": 137},
    {"pro": "CHIRANJEEVI - NAGARAJU", "target": 125, "achieved": 112},
    {"pro": "PARVEEN-NAGALAKSHMI", "target": 100, "achieved": 111},
    {"pro": "AO SRINIVAS-BASAVAIAH", "target": 180, "achieved": 104},
    {"pro": "RAMESH -HARI-MADDIPADU", "target": 100, "achieved": 104},
    {"pro": "N SRINU-TANGUTUR", "target": 180, "achieved": 103},
    {"pro": "B T NAIDU", "target": 125, "achieved": 100},
    {"pro": "JURI VENKATA RAO", "target": 150, "achieved": 90},
    {"pro": "ARUN KUMAR", "target": 120, "achieved": 85},
  ];

  static const List<Map<String, dynamic>> monthlyData = [
    {"month": "Jan", "current": 2, "previous": 1},
    {"month": "Feb", "current": 1, "previous": 1},
    {"month": "Mar", "current": 12, "previous": 3},
    {"month": "Apr", "current": 0, "previous": 0},
    {"month": "May", "current": 12, "previous": 3},
    {"month": "Jun", "current": 0, "previous": 0},
    {"month": "Jul", "current": 12, "previous": 3},
    {"month": "Aug", "current": 16, "previous": 3},
    {"month": "Sep", "current": 12, "previous": 3},
    {"month": "Oct", "current": 0, "previous": 0},
    {"month": "Nov", "current": 0, "previous": 0},
    {"month": "Dec", "current": 0, "previous": 0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.6,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      _buildAnalysisCard(
                        "Target",
                        "5965",
                        Icons.track_changes_sharp,
                        [const Color(0xFF7079D1), const Color(0xFF5560B9)],
                      ),
                      _buildAnalysisCard(
                        "Paid",
                        "3060",
                        Icons.monetization_on_outlined,
                        [const Color(0xFFFDB75E), const Color(0xFFF7941D)],
                      ),
                      _buildAnalysisCard(
                        "Not Paid",
                        "14",
                        Icons.wallet_outlined,
                        [const Color(0xFF4DBB91), const Color(0xFF13A871)],
                      ),
                      _buildAnalysisCard(
                        "Local",
                        "698",
                        Icons.location_on_outlined,
                        [const Color(0xFF4DC4F4), const Color(0xFF1A9FD9)],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 44) / 2,
                    child: _buildAnalysisCard(
                      "Non-Local",
                      "0",
                      Icons.directions_bus_outlined,
                      [const Color(0xFFE54D7E), const Color(0xFFD81B60)],
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildSectionHeader("Pro Admissions Analysis"),
                  const SizedBox(height: 10),
                  _buildLegend([
                    {
                      "label": "Total Admissions",
                      "color": const Color(0xFF1DB082),
                    },
                    {
                      "label": "Remaining Targets",
                      "color": const Color(0xFF6371D1),
                    },
                  ]),
                  const SizedBox(height: 20),
                  _buildScrollableChart(_buildAnalysisChart()),
                  const SizedBox(height: 40),
                  _buildSectionHeader("Pro Year on Year Analytics"),
                  const SizedBox(height: 10),
                  _buildLegend([
                    {
                      "label": "2024-2025 Admissions",
                      "color": const Color(0xFF1A9FD9),
                    },
                    {
                      "label": "2025-2026 Admissions",
                      "color": const Color(0xFF1DB082),
                    },
                  ]),
                  const SizedBox(height: 20),
                  _buildScrollableChart(_buildYearOnYearChart()),
                  const SizedBox(height: 40),
                  _buildSectionHeader(
                    "Admissions Month on Month\n(Session Wise)",
                  ),
                  const SizedBox(height: 30),
                  _buildMonthOnMonthChart(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFFC62828),
      ),
    );
  }

  Widget _buildLegend(List<Map<String, dynamic>> items) {
    return Row(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: item['color'] as Color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                item['label'] as String,
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildScrollableChart(Widget chart) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: admissionsData.length * 30.0 + 60,
        height: 300,
        padding: const EdgeInsets.only(right: 16),
        child: chart,
      ),
    );
  }

  Widget _buildAnalysisChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 320,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 80,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 &&
                    value.toInt() < admissionsData.length) {
                  return SideTitleWidget(
                    meta: meta,
                    space: 10,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        admissionsData[value.toInt()]['pro'],
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 80,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(color: Colors.black54, fontSize: 10),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(admissionsData.length, (index) {
          final data = admissionsData[index];
          final achieved = (data['achieved'] as int).toDouble();
          final target = (data['target'] as int).toDouble();
          final remaining = (target - achieved).clamp(0, 1000).toDouble();

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: achieved + remaining,
                width: 12,
                borderRadius: BorderRadius.zero,
                rodStackItems: [
                  BarChartRodStackItem(0, achieved, const Color(0xFF1DB082)),
                  BarChartRodStackItem(
                    achieved,
                    achieved + remaining,
                    const Color(0xFF6371D1),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildYearOnYearChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 1500,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 80,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 &&
                    value.toInt() < admissionsData.length) {
                  return SideTitleWidget(
                    meta: meta,
                    space: 10,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        admissionsData[value.toInt()]['pro'],
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              interval: 300,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(color: Colors.black54, fontSize: 10),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(admissionsData.length, (index) {
          // Dummy logic for Year on Year data
          double yValue = 300.0 + (index % 5) * 200.0;
          if (index == 8) yValue = 1200;
          if (index == 15) yValue = 1100;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: yValue,
                width: 12,
                color: const Color(0xFF1A9FD9),
                borderRadius: BorderRadius.zero,
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildMonthOnMonthChart() {
    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 30,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              axisNameWidget: const Text(
                "Months",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value >= 0 && value < monthlyData.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        monthlyData[value.toInt()]['month'],
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: const Text(
                "Admissions Count",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 25,
                interval: 5,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: Colors.black54, fontSize: 10),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(monthlyData.length, (index) {
            final data = monthlyData[index];
            final current = (data['current'] as int).toDouble();
            final previous = (data['previous'] as int).toDouble();

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: current + previous,
                  width: 12,
                  borderRadius: BorderRadius.zero,
                  rodStackItems: [
                    if (current > 0)
                      BarChartRodStackItem(0, current, const Color(0xFF4DC4F4)),
                    if (previous > 0)
                      BarChartRodStackItem(
                        current,
                        current + previous,
                        const Color(0xFF78909C),
                      ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 20,
        left: 16,
        right: 16,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF8147E7),
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
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            "Pro Admission",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisCard(
    String title,
    String value,
    IconData icon,
    List<Color> colors,
  ) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -15,
            right: -15,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
