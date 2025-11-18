import 'dart:async';
import '../../data/mock/mock_faqs.dart';
import '../../data/models/support_faq.dart';

class FaqController {
  final _faqStream = StreamController<List<SupportFaq>>.broadcast();
  bool isLoading = false;
  List<SupportFaq> _faqs = [];

  Stream<List<SupportFaq>> get faqStream => _faqStream.stream;

  Future<void> load() async {
    isLoading = true;
    _faqStream.add(_faqs);
    await Future.delayed(const Duration(milliseconds: 500));
    _faqs = List.from(mockFaqs);
    isLoading = false;
    _faqStream.add(_faqs);
  }

  void search(String query) {
    final lower = query.toLowerCase();
    final filtered = _faqs
        .where((f) => f.question.toLowerCase().contains(lower) || f.answer.toLowerCase().contains(lower))
        .toList();
    _faqStream.add(filtered);
  }

  void dispose() {
    _faqStream.close();
  }
}
