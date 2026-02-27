import 'package:get/get.dart';
import '../model/exam_model.dart';
import '../api/api_service.dart';

class ExamsController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<ExamModel> exams = <ExamModel>[].obs;
  RxString query = ''.obs;
  RxString selectedCategory = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    loadExams();
  }

  Future<void> loadExams() async {
    try {
      isLoading.value = true;

      final response = await ApiService.getRequest("/exams_list");

      // 🔍 DEBUG (IMPORTANT)
      print("EXAMS RESPONSE => $response");

      List list = [];

      if (response is List) {
        // API returns list directly
        list = response;
      } else if (response['indexdata'] != null) {
        list = response['indexdata'];
      } else if (response['data'] != null) {
        list = response['data'];
      } else if (response['exams'] != null) {
        list = response['exams'];
      }

      exams.value = list.map<ExamModel>((e) => ExamModel.fromJson(e)).toList();

      print("TOTAL EXAMS LOADED => ${exams.length}");
    } catch (e) {
      print("EXAMS ERROR => $e");
      Get.snackbar(
        "Error",
        "Failed to load exams",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 🔍 SEARCH & CATEGORY FILTER
  List<ExamModel> get filteredExams {
    final q = query.value.toLowerCase();
    final cat = selectedCategory.value;

    return exams.where((e) {
      final matchesSearch =
          q.isEmpty ||
          e.examName.toLowerCase().contains(q) ||
          e.category.toLowerCase().contains(q) ||
          e.branchName.toLowerCase().contains(q);

      final matchesCategory =
          cat == 'All' || e.category.toUpperCase() == cat.toUpperCase();

      return matchesSearch && matchesCategory;
    }).toList();
  }
}
