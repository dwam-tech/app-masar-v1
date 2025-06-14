import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:saba2v2/router/app_router.dart';
import 'package:saba2v2/providers/service_category_provider.dart';
import 'package:saba2v2/providers/restaurant_provider.dart';
import 'package:saba2v2/providers/real_estate_provider.dart';
import 'package:saba2v2/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة مدير الحالة
  final authProvider = AuthProvider();
  await authProvider.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => ServiceCategoryProvider()),
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
        ChangeNotifierProvider(create: (_) => RealEstateProvider()),
      ],
      child: MaterialApp.router(
        title: 'تطبيق سابا',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          fontFamily: 'Cairo',
          scaffoldBackgroundColor: Colors.white,
        ),
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        locale: const Locale('ar', 'SA'),
      ),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServiceCategoryProvider()),
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
        ChangeNotifierProvider(create: (_) => RealEstateProvider()),
      ],
      child: MaterialApp.router(
        title: 'تطبيق سابا',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          fontFamily: 'Cairo',
          scaffoldBackgroundColor: Colors.white,
        ),
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        locale: const Locale('ar', 'SA'),
      ),
    );
  }
}