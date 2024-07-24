import 'event_model.dart';

class CartItemModel {
  final int quantity;
  final EventModel event;

  CartItemModel({
    required this.quantity,
    required this.event,
  });

  CartItemModel copyWith({
    int? quantity,
    EventModel? event,
  }) {
    return CartItemModel(quantity: quantity ?? this.quantity, event: event ?? this.event);
  }
}
