import 'package:flutter/material.dart';
import 'package:student_app/student_app/model/exam_item.dart';
import 'package:student_app/student_app/exam_details_page.dart';
import 'package:student_app/student_app/theme/student_theme.dart';

class StandardExamCard extends StatelessWidget {
  final ExamModel exam;

  const StandardExamCard({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: StudentTheme.containerBorderColor(context)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Exam Name
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(exam.board, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.computer,
                      size: 14,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Online Exam",
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Date, Time & Progress in a Row (wrapped in Wrap/Column if needed)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date & Time Column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            exam.date,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            exam.time,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Progress Column
                  SizedBox(
                    width: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: exam.progress / 100,
                                  backgroundColor:
                                      theme.brightness == Brightness.dark
                                      ? Colors.grey[800]
                                      : Colors.grey.shade200,
                                  color: theme.colorScheme.primary,
                                  minHeight: 6,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${exam.progress.toInt()}%",
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Prepared",
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 2. Action Button (Span full width or aligned right)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ExamDetailsPage(exam: exam.toMap()),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.textTheme.bodyLarge?.color,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    side: BorderSide(
                      color: StudentTheme.containerBorderColor(context),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.description_outlined, size: 16),
                      SizedBox(width: 6),
                      Text(
                        "View Exam Details",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
