import 'package:breathpacer/layers/presentation/views/pages/faq/faq_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/models/faq_model.dart';

class FaqViewModel extends Cubit<FaqState> {
  FaqViewModel() : super(FaqState()) {
    populateFaqList();
  }

  void populateFaqList() {
    final List<FaqModel> faqList = [
      FaqModel(
        category: "Events",
        items: [
          FaqItemModel(
              question: "Can you find someone I can have a lift with to attend an event?",
              answer: "Yes, you can find someone to share a lift with.",
              isExpanded: false),
          FaqItemModel(
              question: "I have purchased an event and have not received anything.",
              answer: "Please contact support for assistance.",
              isExpanded: false),
          FaqItemModel(
            question:
                "Is it possible to start the Advanced Frequency Upgrade straight after Facilitator Training Level 1?",
            isExpanded: false,
            answer:
                "Yes, it is possible to start the Advanced Frequency Upgrade straight after Facilitator Training Level 1.",
          ),
        ],
      ),
      FaqModel(
        category: "General",
        items: [
          FaqItemModel(
              question: "Can you find someone I can have a lift with to attend an event?",
              answer: "Yes, you can find someone to share a lift with.",
              isExpanded: false),
          FaqItemModel(
              question: "I have purchased an event and have not received anything.",
              answer: "Please contact support for assistance.",
              isExpanded: false),
          FaqItemModel(
              question:
                  "Is it possible to start the Advanced Frequency Upgrade straight after Facilitator Training Level 1?",
              answer:
                  "Yes, it is possible to start the Advanced Frequency Upgrade straight after Facilitator Training Level 1.",
              isExpanded: false),
        ],
      ),
    ];
    state.faqList = faqList;
    emit(FaqState.clone(state));
  }

  void toggleExpansion(int categoryIndex, int itemIndex) {
    final faqList = List<FaqModel>.from(state.faqList);
    final items = List<FaqItemModel>.from(faqList[categoryIndex].items);
    final item = items[itemIndex];
    items[itemIndex] = item.copyWith(isExpanded: !item.isExpanded);
    faqList[categoryIndex] = FaqModel(category: faqList[categoryIndex].category, items: items);

    state.faqList = faqList;

    emit(FaqState.clone(state));
  }

  void reset() {
    emit(FaqState());
  }
}
