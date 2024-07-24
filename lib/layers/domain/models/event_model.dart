class EventModel {
  final String title;
  final String date;
  final String image;
  final bool canBook;
  final bool isDiscounted;
  final String category;
  final String text;
  final double price;
  final double discountedPrice;

  EventModel(
      {required this.title,
      required this.date,
      required this.image,
      required this.canBook,
      required this.isDiscounted,
      required this.category,
      required this.text,
      required this.price,
      required this.discountedPrice});

  EventModel copyWith(
      {String? title,
      String? date,
      String? image,
      bool? canBook,
      bool? isDiscounted,
      String? category,
      String? text,
      double? price,
      double? discountedPrice}) {
    return EventModel(
        date: date ?? this.date,
        image: image ?? this.image,
        canBook: canBook ?? this.canBook,
        isDiscounted: isDiscounted ?? this.isDiscounted,
        title: title ?? this.title,
        category: category ?? this.category,
        text: text ?? this.text,
        price: price ?? this.price,
        discountedPrice: discountedPrice ?? this.discountedPrice);
  }
}
