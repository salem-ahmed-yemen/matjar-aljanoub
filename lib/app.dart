import 'package:flutter/material.dart';
import 'products.dart';

class MatjarAlJanoubApp extends StatelessWidget {
  const MatjarAlJanoubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'متجر الجنوب الإلكتروني',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        fontFamily: 'Arial',
      ),
      locale: const Locale('ar'),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void openCategory(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductsPage(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('متجر الجنوب'),
          centerTitle: true,
        ),
        body: GridView.count(
          padding: const EdgeInsets.all(16),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            CategoryCard(
              title: 'الملابس',
              icon: Icons.checkroom,
              onTap: () => openCategory(context, 'الملابس'),
            ),
            CategoryCard(
              title: 'الإلكترونيات',
              icon: Icons.phone_android,
              onTap: () => openCategory(context, 'الإلكترونيات'),
            ),
            CategoryCard(
              title: 'الأواني المنزلية',
              icon: Icons.kitchen,
              onTap: () => openCategory(context, 'الأواني المنزلية'),
            ),
            CategoryCard(
              title: 'العروض',
              icon: Icons.local_offer,
              onTap: () => openCategory(context, 'العروض'),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
