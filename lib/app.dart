import 'package:flutter/material.dart';
import 'cart.dart';

class Product {
  final String name;
  final String category;
  final double price;
  final IconData icon;

  const Product({
    required this.name,
    required this.category,
    required this.price,
    required this.icon,
  });
}

const List<Product> products = [
  Product(
    name: 'قميص رجالي',
    category: 'الملابس',
    price: 15000,
    icon: Icons.checkroom,
  ),
  Product(
    name: 'هاتف ذكي',
    category: 'الإلكترونيات',
    price: 85000,
    icon: Icons.phone_android,
  ),
  Product(
    name: 'طقم أواني منزلي',
    category: 'الأواني المنزلية',
    price: 25000,
    icon: Icons.kitchen,
  ),
  Product(
    name: 'عرض خاص',
    category: 'العروض',
    price: 10000,
    icon: Icons.local_offer,
  ),
];

class ProductsPage extends StatelessWidget {
  final String category;

  const ProductsPage({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final items = products
        .where((product) => product.category == category)
        .toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(category),
          centerTitle: true,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final product = items[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(
                  product.icon,
                  size: 40,
                ),
                title: Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${product.price.toStringAsFixed(0)} ريال يمني',
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    Cart.add(product);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'تمت إضافة المنتج إلى السلة',
                        ),
                      ),
                    );
                  },
                  child: const Text('أضف للسلة'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
