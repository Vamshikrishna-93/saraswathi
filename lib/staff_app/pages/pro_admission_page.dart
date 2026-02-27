import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class ProAdmissionPage extends StatelessWidget {
  const ProAdmissionPage({super.key});

  static const List<Map<String, dynamic>> admissionsData = [
    {
      "pro": "SUBBARAO-HRAO",
      "phone": "9951573913",
      "target": 250,
      "achieved": 186,
      "paid": 185,
      "npaid": 1,
    },
    {
      "pro": "MEERA REDDY",
      "phone": "9398049086",
      "target": 200,
      "achieved": 137,
      "paid": 137,
      "npaid": 0,
    },
    {
      "pro": "CHIRANJEEVI - NAGARAJU",
      "phone": "9666377759",
      "target": 125,
      "achieved": 112,
      "paid": 112,
      "npaid": 0,
    },
    {
      "pro": "PARVEEN-NAGALAKSHMI",
      "phone": "9966126183",
      "target": 100,
      "achieved": 111,
      "paid": 111,
      "npaid": 0,
    },
    {
      "pro": "AO SRINIVAS-BASAVAIAH",
      "phone": "9848798892",
      "target": 180,
      "achieved": 104,
      "paid": 103,
      "npaid": 1,
    },
    {
      "pro": "RAMESH -HARI-MADDIPADU",
      "phone": "9848218021",
      "target": 100,
      "achieved": 104,
      "paid": 104,
      "npaid": 0,
    },
    {
      "pro": "N SRINU-TANGUTUR",
      "phone": "9948283887",
      "target": 180,
      "achieved": 103,
      "paid": 102,
      "npaid": 1,
    },
    {
      "pro": "B T NAIDU",
      "phone": "9908404003",
      "target": 125,
      "achieved": 100,
      "paid": 100,
      "npaid": 0,
    },
    {
      "pro": "JURI VENKATA RAO",
      "phone": "9908404003",
      "target": 150,
      "achieved": 90,
      "paid": 90,
      "npaid": 0,
    },
    {
      "pro": "ARUN KUMAR",
      "phone": "9908404003",
      "target": 120,
      "achieved": 85,
      "paid": 80,
      "npaid": 5,
    },
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
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      _buildAnalysisCard(
                        "Target",
                        "5965",
                        Icons.track_changes_rounded,
                        [const Color(0xFF6366F1), const Color(0xFF4F46E5)],
                      ),
                      _buildAnalysisCard(
                        "Paid",
                        "3060",
                        Icons.monetization_on_outlined,
                        [const Color(0xFFFBBF24), const Color(0xFFD97706)],
                      ),
                      _buildAnalysisCard(
                        "Not Paid",
                        "14",
                        Icons.account_balance_wallet_outlined,
                        [const Color(0xFF34D399), const Color(0xFF059669)],
                      ),
                      _buildAnalysisCard(
                        "Local",
                        "698",
                        Icons.location_on_outlined,
                        [const Color(0xFF60A5FA), const Color(0xFF2563EB)],
                      ),
                      _buildAnalysisCard(
                        "Non-Local",
                        "0",
                        Icons.directions_bus_outlined,
                        [const Color(0xFFF472B6), const Color(0xFFDB2777)],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildSectionHeader("PRO ADMISSIONS ANALYSIS"),
                  const SizedBox(height: 10),
                  _buildLegend(),
                  const SizedBox(height: 20),
                  _buildScrollableChart(),
                  const SizedBox(height: 30),
                  _buildDataTable(),
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
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF3F51B5),
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem("Total Admissions", const Color(0xFF10B981)),
        const SizedBox(width: 20),
        _legendItem("Remaining Target", const Color(0xFF6366F1)),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildScrollableChart() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: admissionsData.length * 50.0 + 60, // Base width on data
        height: 280,
        padding: const EdgeInsets.only(top: 20, right: 20, bottom: 10),
        child: BarChart(
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
                              fontWeight: FontWeight.bold,
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
                  interval: 80,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 10,
                      ),
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
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.grey.withValues(alpha: 0.2),
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(admissionsData.length, (index) {
              final data = admissionsData[index];
              final achieved = data['achieved'] as int;
              final target = data['target'] as int;
              final remaining = (target - achieved).clamp(0, 500);

              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: (achieved + remaining).toDouble(),
                    width: 15,
                    color: Colors.transparent, // Background managed by stack
                    rodStackItems: [
                      BarChartRodStackItem(
                        0,
                        achieved.toDouble(),
                        const Color(0xFF10B981),
                      ),
                      BarChartRodStackItem(
                        achieved.toDouble(),
                        (achieved + remaining).toDouble(),
                        const Color(0xFF6366F1),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(const Color(0xFF43A047)),
          headingTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          dataRowMinHeight: 40,
          dataRowMaxHeight: 50,
          columnSpacing: 20,
          horizontalMargin: 15,
          columns: const [
            DataColumn(label: Text('S.no')),
            DataColumn(label: Text('Pro')),
            DataColumn(label: Text('Phone')),
            DataColumn(label: Text('Target')),
            DataColumn(label: Text('Achieved')),
            DataColumn(label: Text('Achieved%')),
            DataColumn(label: Text('Paid')),
            DataColumn(label: Text('N.Paid')),
            DataColumn(label: Text('Paid%')),
          ],
          rows: List.generate(admissionsData.length, (index) {
            final data = admissionsData[index];
            final target = data['target'] as int;
            final achieved = data['achieved'] as int;
            final paid = data['paid'] as int;
            final npaid = data['npaid'] as int;

            final achievedPct = ((achieved / target) * 100).toStringAsFixed(0);
            final paidPct = ((paid / (paid + npaid)) * 100).toStringAsFixed(0);

            return DataRow(
              cells: [
                DataCell(Text((index + 1).toString())),
                DataCell(
                  Text(data['pro'], style: const TextStyle(fontSize: 11)),
                ),
                DataCell(
                  Text(
                    data['phone'],
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                ),
                DataCell(Text(target.toString())),
                DataCell(
                  Text("$achieved/$achieved"),
                ), // Showing as current/total achieved or similar to image
                DataCell(Text("$achievedPct%")),
                DataCell(Text(paid.toString())),
                DataCell(Text(npaid.toString())),
                DataCell(Text("$paidPct%")),
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
        color: Color(0xFF8B5CF6),
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
                color: Colors.white.withValues(alpha: 0.2),
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
        boxShadow: [
          BoxShadow(
            color: colors[1].withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Circle 1
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Background Circle 2
          Positioned(
            bottom: -10,
            left: -10,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
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
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
