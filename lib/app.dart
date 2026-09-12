import 'package:flutter/material.dart';

void main() {
  runApp(const MatjarAlJanoubApp());
}

class MatjarAlJanoubApp extends StatelessWidget {
  const MatjarAlJanoubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'متجر الجنوب',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050505),
        fontFamily: 'Arial',
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            // الخلفية الداكنة
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF020202),
                      Color(0xFF0B0B0B),
                      Color(0xFF050505),
                    ],
                  ),
                ),
              ),
            ),

            // زخرفة ذهبية علوية
            Positioned(
              top: -90,
              right: -80,
              child: Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFB8892D),
                    width: 2,
                  ),
                ),
              ),
            ),

            // زخرفة دائرية ثانية
            Positioned(
              top: -65,
              right: -55,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF5C4318),
                    width: 1,
                  ),
                ),
              ),
            ),

            // زخرفة خلفية
            Positioned(
              left: -100,
              bottom: 80,
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 260,
                color: Colors.white.withOpacity(0.025),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 18),

                  // الشعار
                  Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFE2B84B),
                          Color(0xFF8A641F),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE2B84B).withOpacity(0.25),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.shopping_cart_rounded,
                      color: Colors.black,
                      size: 34,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'متجر الجنوب',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'كل ما تحتاجه في مكان واحد',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.65),
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // الأقسام الأربعة
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.95,
                        children: const [
                          CategoryCard(
                            title: 'الإلكترونيات',
                            icon: Icons.phone_android_rounded,
                            accent: Color(0xFF2196F3),
                          ),
                          CategoryCard(
                            title: 'الملابس',
                            icon: Icons.checkroom_rounded,
                            accent: Color(0xFFE91E63),
                          ),
                          CategoryCard(
                            title: 'العروض',
                            icon: Icons.local_offer_rounded,
                            accent: Color(0xFF4CAF50),
                          ),
                          CategoryCard(
                            title: 'الأواني المنزلية',
                            icon: Icons.soup_kitchen_rounded,
                            accent: Color(0xFF9C27B0),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // الشريط الذهبي السفلي
                  Container(
                    height: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 45),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Colors.transparent,
                          Color(0xFFD4A83E),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'تسوق بسهولة وأمان',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.45),
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 15),
                ],
              ),
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
  final Color accent;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم اختيار قسم $title',
                textAlign: TextAlign.center,
              ),
              backgroundColor: const Color(0xFF171717),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: accent.withOpacity(0.45),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(0.10),
                blurRadius: 18,
                spreadRadius: 1,
              ),
              const BoxShadow(
                color: Colors.black54,
                blurRadius: 8,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // دائرة الأيقونة
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent.withOpacity(0.15),
                    border: Border.all(
                      color: accent.withOpacity(0.65),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: accent,
                    size: 38,
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 14),

                // الخط الملون أسفل البطاقة
                Container(
                  width: 58,
                  height: 4,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withOpacity(0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
