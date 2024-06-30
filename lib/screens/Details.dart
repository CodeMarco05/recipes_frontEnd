import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:recipes_frontend/Constants.dart';
import 'package:recipes_frontend/controllers/home_screen_controller.dart';
import 'package:recipes_frontend/models/food_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsPage extends StatelessWidget {
  Future<FoodModel?> loadFoodItem() async {
    final prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString('savedFoodItem');
    if (json != null) {
      Map<String, dynamic> map = jsonDecode(json);
      return FoodModel.fromJson(map);
    }
    return null; // Return null if there's no saved item
  }

  static const String routeName = '/details';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<FoodModel?>(
          future: loadFoodItem(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            } else if (snapshot.hasError) {
              return Text('Error loading food item');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Text('No food item found');
            } else {
              final food = snapshot.data!;
              return Text(
                food.getTitle,
                style: TextStyle(
                  fontFamily: Constants.exo_font,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              );
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Add your edit logic here
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Add your delete logic here
            },
          ),
        ],
      ),
      body: FutureBuilder<FoodModel?>(
        future: loadFoodItem(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading food item'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No food item found'));
          } else {
            final food = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Ingredients:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: food.getIngredients.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.arrow_right),
                        title: Text(food.getIngredients[index]),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Instructions:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(food.getInstructions),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
