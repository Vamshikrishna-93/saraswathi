import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IssueOutingPage extends StatefulWidget {
  final String studentName;
  final String outingType;

  const IssueOutingPage({
    super.key,
    this.studentName = "",
    this.outingType = "",
  });

  @override
  State<IssueOutingPage> createState() => _IssueOutingPageState();
}

class _IssueOutingPageState extends State<IssueOutingPage> {
  String passType = "Home Pass";
  String selectedStudent = "Select Student";
  String selectedOutTime = "Select Student"; // As per image placeholder
  String selectedPurpose = "Select Purpose";

  @override
  void initState() {
    super.initState();
    if (widget.studentName.isNotEmpty) {
      selectedStudent = widget.studentName;
    }
    if (widget.outingType.isNotEmpty) {
      passType = widget.outingType;
    }
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F3FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date
                    _buildLabel("Date"),
                    _buildTextField("20/11/2025"),
                    const SizedBox(height: 12),

                    // Pass Type
                    _buildLabel("Pass Type"),
                    _buildPassTypeGrid(),
                    const SizedBox(height: 12),

                    // Select Student
                    _buildLabel("Select Student"),
                    _buildDropdown(selectedStudent, (v) {
                      setState(() => selectedStudent = v!);
                    }, ["Select Student", "John Doe", "Jane Smith"]),
                    const SizedBox(height: 12),

                    // Letter Photo
                    _buildLabel("Letter Photo"),
                    _buildPhotoUpload(),
                    const SizedBox(height: 12),

                    // Out Time
                    _buildLabel("Out Time"),
                    _buildDropdown(
                      selectedOutTime,
                      (v) {
                        setState(() => selectedOutTime = v!);
                      },
                      ["Select Student", "09:00 AM", "12:00 PM", "06:00 PM"],
                    ),
                    const SizedBox(height: 12),

                    // Purpose
                    _buildLabel("Purpose"),
                    _buildDropdown(
                      selectedPurpose,
                      (v) {
                        setState(() => selectedPurpose = v!);
                      },
                      ["Select Purpose", "Hospital", "Home Visit", "Exam"],
                    ),
                    const SizedBox(height: 20),

                    // Action Button
                    _buildGradientButton(),
                  ],
                ),
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
        bottom: 25,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF7E49FF), // Consistent Purple
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(6),
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
            "Issue Outing",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ================= FIELD UTILS =================
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const Text(
            " *",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return Container(
      height: 44, // Small height
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        hint,
        style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
      ),
    );
  }

  Widget _buildDropdown(
    String value,
    Function(String?) onChanged,
    List<String> items,
  ) {
    return Container(
      height: 44, // Small height
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black87,
            size: 20,
          ),
          items: items.map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(
                val,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildPassTypeGrid() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildRadioTile("Home Pass")),
              Expanded(child: _buildRadioTile("Outing Pass")),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildRadioTile("Self Outing")),
              Expanded(child: _buildRadioTile("Self Home")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadioTile(String label) {
    bool isSelected = passType == label;
    return GestureDetector(
      onTap: () => setState(() => passType = label),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? const Color(0xFF8B5CF6) : Colors.grey,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFF8B5CF6),
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoUpload() {
    return CustomPaint(
      painter: DashedBorderPainter(
        color: const Color(0xFF7E49FF).withOpacity(0.5),
        strokeWidth: 1.5,
        gap: 4,
      ),
      child: Container(
        height: 44, // Small height
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_rounded, color: Colors.black87, size: 18),
            SizedBox(width: 8),
            Text(
              "Take Photo (or) Upload",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientButton() {
    return GestureDetector(
      onTap: () {
        Get.snackbar(
          "Success",
          "Outing Issued Successfully",
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green.shade800,
        );
      },
      child: Container(
        width: double.infinity,
        height: 48, // Small height
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7E49FF), Color(0xFFC084FC)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7E49FF).withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Issue Outing Now",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}

// ================= CUSTOM PAINTER FOR DASHED BORDER =================
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(12),
        ),
      );

    final dashPath = Path();
    double distance = 0.0;
    for (final Metric in path.computeMetrics()) {
      while (distance < Metric.length) {
        dashPath.addPath(
          Metric.extractPath(distance, distance + gap),
          Offset.zero,
        );
        distance += gap * 2;
      }
      distance = 0.0;
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(DashedBorderPainter oldDelegate) => false;
}
