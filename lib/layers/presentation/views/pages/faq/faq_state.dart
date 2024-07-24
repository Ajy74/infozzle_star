import '../../../../domain/models/faq_model.dart';

class FaqState {
  List<FaqModel> faqList;

  FaqState({
    this.faqList = const [],
  });

  FaqState.clone(FaqState existingState) : this(faqList: existingState.faqList);
}
