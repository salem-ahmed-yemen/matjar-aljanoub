import 'package:flutter/material.dart';
import 'products.dart';

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
      items.add(CartItem(product: product));
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
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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
                child: Text(
                  'السلة فارغة',
                  style: TextStyle(fontSize: 20),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: Cart.items.length,
                      itemBuilder: (context, index) {
                        final item = Cart.items[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: Icon(
                              item.product.icon,
                              size: 40,
                            ),
                            title: Text(
                              item.product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${item.product.price.toStringAsFixed(0)} ريال يمني',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      Cart.remove(item.product);
                                    });
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                                Text('${item.quantity}'),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      Cart.add(item.product);
                                    });
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'الإجمالي: ${Cart.total.toStringAsFixed(0)} ريال يمني',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
