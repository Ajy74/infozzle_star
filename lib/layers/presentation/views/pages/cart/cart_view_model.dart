import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/models/cart_item_model.dart';
import '../../../../domain/models/event_model.dart';
import 'cart_state.dart';

class CartViewModel extends Cubit<CartState> {
  CartViewModel() : super(CartState());

  final TextEditingController couponController = TextEditingController();

  void fetchCart() {
    List<CartItemModel> getCart = [
      CartItemModel(
        quantity: 1,
        event: EventModel(
            title: "Infinite Wisdom 19- Grand Central Sun, Council Of Light Exploration, Online",
            date: "May 25 - May 26",
            image: "https://placehold.co/1920x1080.jpg",
            canBook: true,
            isDiscounted: false,
            category: "Category 1",
            price: 50.0,
            discountedPrice: 0,
            text:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla cursus, dolor id accumsan laoreet, justo odio viverra est, sit amet egestas elit neque in purus. Phasellus ullamcorper bibendum purus, vitae dignissim nunc commodo vel. Sed sollicitudin justo commodo enim feugiat, at dictum nibh sollicitudin. Vivamus dignissim, lorem ac aliquet euismod, felis eros congue nisi, sed pulvinar augue mi in diam. Curabitur luctus vestibulum purus, et ornare eros commodo vel. Vivamus sit amet tristique felis. Ut nec nisi ut turpis tempor tincidunt. Proin in velit purus. Maecenas mattis elit nec quam fringilla accumsan. Pellentesque in mi ullamcorper risus elementum semper. Mauris turpis ipsum, elementum at suscipit quis, aliquet non purus."),
      ),
      CartItemModel(
        quantity: 2,
        event: EventModel(
            title: "Infinity Group Call, May 2024",
            date: "May 20 @5:00 pm - 5:30 pm",
            image: "https://placehold.co/1920x1080.jpg",
            canBook: false,
            isDiscounted: true,
            category: "Call",
            price: 260.0,
            discountedPrice: 200.0,
            text:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla cursus, dolor id accumsan laoreet, justo odio viverra est, sit amet egestas elit neque in purus. Phasellus ullamcorper bibendum purus, vitae dignissim nunc commodo vel. Sed sollicitudin justo commodo enim feugiat, at dictum nibh sollicitudin. Vivamus dignissim, lorem ac aliquet euismod, felis eros congue nisi, sed pulvinar augue mi in diam. Curabitur luctus vestibulum purus, et ornare eros commodo vel. Vivamus sit amet tristique felis. Ut nec nisi ut turpis tempor tincidunt. Proin in velit purus. Maecenas mattis elit nec quam fringilla accumsan. Pellentesque in mi ullamcorper risus elementum semper. Mauris turpis ipsum, elementum at suscipit quis, aliquet non purus."),
      ),
    ];

    state.cartItems = getCart;
    emit(CartState.clone(state));
  }

  void increaseQuantity(CartItemModel item) {
    List<CartItemModel> updatedCart = List.from(state.cartItems);
    int index = updatedCart.indexOf(item);
    if (index != -1) {
      updatedCart[index] = updatedCart[index].copyWith(quantity: updatedCart[index].quantity + 1);

      state.cartItems = updatedCart;
      emit(CartState.clone(state));
    }
  }

  void decreaseQuantity(CartItemModel item) {
    List<CartItemModel> updatedCart = List.from(state.cartItems);
    int index = updatedCart.indexOf(item);
    if (index != -1 && updatedCart[index].quantity > 1) {
      updatedCart[index] = updatedCart[index].copyWith(quantity: updatedCart[index].quantity - 1);

      state.cartItems = updatedCart;
      emit(CartState.clone(state));
    }
  }

  void removeItem(CartItemModel item) {
    List<CartItemModel> updatedCart = List.from(state.cartItems);
    updatedCart.remove(item);
    state.cartItems = updatedCart;
    emit(CartState.clone(state));
  }

  double getSubtotalAmount() {
    return state.cartItems.fold(0,
        (sum, item) => sum + (item.event.isDiscounted ? item.event.discountedPrice : item.event.price) * item.quantity);
  }

  void toggleIsCouponPress() {
    state.isCouponApplied = !state.isCouponApplied;
    emit(CartState.clone(state));
  }

  void applyCoupon(String couponCode) {
    double discountAmount = 0.0;
    if (couponCode == "SAVE10") {
      discountAmount = 10.0;
      state.appliedCoupon = couponCode;
    } else {
      resetCoupon();
    }
    state.discount = discountAmount;
    state.isCouponApplied = false;

    emit(CartState.clone(state));
  }

  void resetCoupon() {
    couponController.clear();
    state.discount = 0.0;
    state.appliedCoupon = "";
    state.isCouponApplied = false;
  }

  void reset() {
    emit(CartState());
  }
}
