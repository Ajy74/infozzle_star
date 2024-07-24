import 'package:breathpacer/layers/domain/models/cart_item_model.dart';

class CartState {
  List<CartItemModel> cartItems;
  bool isCouponApplied;
  bool isDataLoading;
  double discount;
  String appliedCoupon;

  CartState(
      {this.cartItems = const [],
      this.isCouponApplied = false,
      this.isDataLoading = true,
      this.discount = 0.0,
      this.appliedCoupon = ""});

  CartState.clone(CartState existingState)
      : this(
            cartItems: existingState.cartItems,
            isCouponApplied: existingState.isCouponApplied,
            isDataLoading: existingState.isDataLoading,
            discount: existingState.discount,
            appliedCoupon: existingState.appliedCoupon);
}
