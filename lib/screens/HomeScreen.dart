import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:recipes_frontend/screens/AddItem.dart';
import 'package:recipes_frontend/screens/Details.dart';

import '../Constants.dart';
import '../controllers/home_screen_controller.dart';
import '../models/food_model.dart';

class Homescreen extends StatelessWidget {
  Homescreen({super.key});

  final homescreenController = Get.put(HomescreenController());

  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                    expandedHeight: 100.0,
                    floating: false,
                    pinned: false,
                    flexibleSpace: Container(
                      width: 100.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/images/home_screen_background.jpg"),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.5),
                                  BlendMode.darken))),
                      child: Padding(
                        padding: EdgeInsets.all(Constants.defaultPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Constants.appName,
                              style: TextStyle(
                                  fontFamily: Constants.playwrite_font,
                                  color: Colors.white,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w900),
                            ),
                            Container(
                              height: 50.h,
                              width: 50.w,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors
                                        .black, // Adjust icon color for visibility
                                    size: 30.sp,
                                  ),
                                  onPressed: () {
                                    Get.toNamed(AddItemScreen.routeName);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
              ];
            },
            body: Padding(
                padding: EdgeInsets.all(Constants.defaultPadding),
                child: FutureBuilder<List<FoodModel>>(
                    future: homescreenController.getFoodItems(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: InkWell(
                                onTap: () {
                                  homescreenController.saveFoodItem(snapshot.data![index]);
                                  Get.toNamed(DetailsPage.routeName,
                                      arguments: snapshot.data![index]);
                                },
                                child: ListTile(
                                  title: Text(
                                    snapshot.data![index].title,
                                    style: TextStyle(
                                        fontFamily: Constants.exo_font,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                      snapshot.data![index].getIngredients
                                          .join(', '),
                                      style: TextStyle(
                                        fontFamily: Constants.exo_font,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey,
                                      )),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                        color: Colors.black, width: 2),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return Center(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: const CircularProgressIndicator(
                              color: Colors.orange),
                        ),
                      );
                    }))));
  }
}
