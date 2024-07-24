import 'package:breathpacer/layers/presentation/views/pages/cart/cart_view_model.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/star_magic/custom_button.dart';
import 'package:breathpacer/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../domain/models/cart_item_model.dart';
import '../../shared_widgets/star_magic/burger_drawer/burger_drawer_view.dart';
import 'cart_state.dart';

class CartView extends StatelessWidget {
  CartView({super.key}) {
    viewModel.fetchCart();
  }

  final CartViewModel viewModel = CartViewModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Cart"),
            titleTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppTheme.colors.appBarColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.home_filled),
                onPressed: () {
                  context.go("/home");
                },
              ),
            ],
          ),
          drawer: BurgerDrawerView(),
          body: BlocBuilder<CartViewModel, CartState>(
            bloc: viewModel,
            builder: (_, state) {
              return SafeArea(
                top: true,
                bottom: true,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.cartItems.length,
                        itemBuilder: (context, index) {
                          return buildCartItem(state.cartItems[index]);
                        },
                      ),
                    ),
                    buildTotal(context, state),
                    CustomButton(
                        buttonText: "Proceed to Checkout",
                        color: AppTheme.colors.lightBlueButton,
                        onTap: () {
                          GoRouter.of(context).push("/billing");
                        }),
                    const SizedBox(height: 20)
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildCartItem(CartItemModel cartItem) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: SizedBox(
                    height: 100,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: cartItem.event.image,
                          progressIndicatorBuilder: (context, url, downloadProgress) => Shimmer(
                              gradient: AppTheme.colors.linearLoading,
                              child: Container(color: Colors.white, height: 100)),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          width: 350,
                          height: 350,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartItem.event.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cartItem.event.date,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (cartItem.event.isDiscounted)
                            Text(
                              '\$${cartItem.event.price}',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.colors.eventPrimary,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          if (cartItem.event.isDiscounted) const SizedBox(width: 4),
                          Text(
                            '\$${cartItem.event.isDiscounted ? cartItem.event.discountedPrice : cartItem.event.price}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete, color: AppTheme.colors.eventPrimary),
                            onPressed: () {
                              viewModel.removeItem(cartItem);
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          IconButton(
                            icon: Icon(Icons.remove, color: AppTheme.colors.eventPrimary),
                            onPressed: () {
                              viewModel.decreaseQuantity(cartItem);
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                cartItem.quantity.toString(),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, color: AppTheme.colors.eventPrimary),
                            onPressed: () {
                              viewModel.increaseQuantity(cartItem);
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTotal(BuildContext context, CartState state) {
    final double availableWidth = MediaQuery.of(context).size.width - 40; // 20 padding on each side

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text('Subtotal: '),
              const Spacer(),
              Text("\$${viewModel.getSubtotalAmount()}"),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Coupon: '),
              const Spacer(),
              state.isCouponApplied
                  ? Expanded(
                      child: TextField(
                        controller: viewModel.couponController,
                        decoration: InputDecoration(
                          hintText: 'Enter Code',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () {
                              viewModel.applyCoupon(viewModel.couponController.text);
                            },
                          ),
                        ),
                      ),
                    )
                  : TextButton(
                      style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
                      onPressed: () {
                        viewModel.toggleIsCouponPress();
                      },
                      child: Text(
                        state.appliedCoupon.isEmpty ? 'Add Coupon' : state.appliedCoupon,
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              if (state.discount > 0)
                Column(children: [
                  Row(
                    children: [
                      const Text('Discount: '),
                      const Spacer(),
                      Text('-\$${state.discount.toStringAsFixed(2)}'),
                    ],
                  ),
                  const SizedBox(height: 20),
                ]),
              Dash(
                direction: Axis.horizontal,
                length: availableWidth,
                dashLength: 12,
                dashColor: Colors.grey,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const Spacer(),
                  Text(
                    '\$${(viewModel.getSubtotalAmount() - state.discount).toStringAsFixed(2)}',
                    style: TextStyle(color: AppTheme.colors.eventPrimary, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
