class FaqModel {
  final String category;
  List<FaqItemModel> items;

  FaqModel({
    required this.category,
    required this.items,
  });
}

class FaqItemModel {
  final String question;
  final String answer;
  final bool isExpanded;

  FaqItemModel({
    required this.question,
    required this.answer,
    required this.isExpanded,
  });

  FaqItemModel copyWith({String? question, String? answer, bool? isExpanded}) {
    return FaqItemModel(
      question: question ?? this.question,
      answer: answer ?? this.answer,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
