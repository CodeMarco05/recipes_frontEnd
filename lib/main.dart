import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipes_frontend/auth_middleware';
import 'package:recipes_frontend/controllers/auth_controller.dart';
import 'package:recipes_frontend/screens/add_item.dart';
import 'package:recipes_frontend/screens/details.dart';
import 'package:recipes_frontend/screens/edit_item_screen.dart';
import 'package:recipes_frontend/screens/home_screen.dart';
import 'package:recipes_frontend/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MainApp());
  Get.put(AuthController());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: LoginScreen.routeName,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primaryColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
            ),
          ),
          /*routingCallback: (routing) async {
            final prefs = await SharedPreferences.getInstance();
            final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
            if (!isLoggedIn) {
              routing?.current = LoginScreen.routeName;
            }
          },*/
          getPages: [
            GetPage(
                name: Homescreen.routeName,
                page: () => Homescreen(),
                middlewares: [AuthMiddleware()]),
            GetPage(
                name: DetailsPage.routeName,
                page: () => DetailsPage(),
                middlewares: [AuthMiddleware()]),
            GetPage(
                name: AddItemScreen.routeName,
                page: () => AddItemScreen(),
                middlewares: [AuthMiddleware()]),
            GetPage(
                name: EditItemScreen.routeName,
                page: () => EditItemScreen(),
                middlewares: [AuthMiddleware()]),
            GetPage(name: LoginScreen.routeName, page: () => LoginScreen()),
          ],
        );
      },
    );
  }
}
