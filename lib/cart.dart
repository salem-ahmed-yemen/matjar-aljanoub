import 'package:flutter/material.dart';
import 'products.dart';
import 'checkout.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });
}

class Cart {
  static final List<CartItem> items = [];

  static void add(Product product) {
    final index = items.indexWhere(
      (item) => item.product.name == product.name,
    );

    if (index >= 0) {
      items[index].quantity++;
    } else {
      items.add(
        CartItem(
          product: product,
        ),
      );
    }
  }

  static void remove(Product product) {
    final index = items.indexWhere(
      (item) => item.product.name == product.name,
    );

    if (index >= 0) {
      if (items[index].quantity > 1) {
        items[index].quantity--;
      } else {
        items.removeAt(index);
      }
    }
  }

  static double get total {
    double result = 0;

    for (final item in items) {
      result += item.product.price * item.quantity;
    }

    return result;
  }

  static void clear() {
    items.clear();
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void refreshCart() {
    setState(() {});
  }

  void openCheckout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CheckoutPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('السلة'),
          centerTitle: true,
        ),
        body: Cart.items.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'السلة فارغة',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'أضف المنتجات إلى السلة للمتابعة',
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: Cart.items.length,
                      itemBuilder: (context, index) {
                        final item = Cart.items[index];

                        return Card(
                          margin: const EdgeInsets.only(
                            bottom: 12,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Icon(
                                  item.product.icon,
                                  size: 45,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.product.name,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${item.product.price.toStringAsFixed(0)} ريال يمني',
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Cart.remove(
                                          item.product,
                                        );
                                        refreshCart();
                                      },
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                      ),
                                    ),
                                    Text(
                                      '${item.quantity}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Cart.add(
                                          item.product,
                                        );
                                        refreshCart();
                                      },
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'الإجمالي:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${Cart.total.toStringAsFixed(0)} ريال يمني',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: openCheckout,
                            icon: const Icon(
                              Icons.shopping_cart_checkout,
                            ),
                            label: const Text(
                              'إتمام الطلب',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
