import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipes_frontend/models/food_model.dart';
import 'package:recipes_frontend/screens/AddItem.dart';
import 'package:recipes_frontend/screens/Details.dart';
import 'package:recipes_frontend/screens/HomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MainApp());
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
          initialRoute: Homescreen.routeName,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primaryColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
            ),
          ),
          getPages: [
            GetPage(
              name: Homescreen.routeName,
              page: () => Homescreen(),
            ),
            GetPage(
              name: DetailsPage.routeName,
              page: () => DetailsPage(),
            ),
            GetPage(name: AddItemScreen.routeName, page: () => AddItemScreen()),
          ],
        );
      },
    );
  }
}
