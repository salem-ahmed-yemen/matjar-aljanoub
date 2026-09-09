import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/home_page.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/admin/presentation/admin_page.dart';
import 'features/vendor/presentation/vendor_page.dart';

class MatjarAlJanoubApp extends StatelessWidget {
  const MatjarAlJanoubApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'متجر الجنوب الإلكتروني',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    locale: const Locale('ar'),
    home: const SplashPage(),
    routes: {'/login': (_) => const LoginPage(), '/admin': (_) => const AdminPage(), '/vendor': (_) => const VendorPage()},
  );
}

class SplashPage extends StatefulWidget { const SplashPage({super.key}); @override State<SplashPage> createState()=>_SplashPageState(); }
class _SplashPageState extends State<SplashPage> {
  @override void initState(){super.initState(); Future.delayed(const Duration(seconds: 2),(){if(mounted)Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const HomePage()));});}
  @override Widget build(BuildContext context)=>Directionality(textDirection:TextDirection.rtl,child:Scaffold(body:Stack(fit:StackFit.expand,children:[Image.asset('assets/images/matjar_background.jpg',fit:BoxFit.cover),Container(color:Colors.black.withOpacity(.35)),const Center(child:Column(mainAxisSize:MainAxisSize.min,children:[Text('متجر الجنوب',style:TextStyle(color:Colors.white,fontSize:42,fontWeight:FontWeight.bold)),SizedBox(height:8),Text('الإلكتروني',style:TextStyle(color:Colors.white,fontSize:27)),SizedBox(height:28),CircularProgressIndicator(color:Colors.white),SizedBox(height:14),Text('جاري التحميل...',style:TextStyle(color:Colors.white,fontSize:16))]))])));
}
