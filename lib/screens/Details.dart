import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:recipes_frontend/Constants.dart';
import 'package:recipes_frontend/controllers/home_screen_controller.dart';
import 'package:recipes_frontend/models/food_model.dart';
import 'package:recipes_frontend/screens/add_item.dart';
import 'package:recipes_frontend/screens/home_screen.dart';
import 'package:recipes_frontend/screens/edit_item_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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

  Future<void> deleteFoodItem(String id) async {
    //get the api key
    //await dotenv.load(fileName: "assets/.env");
    //String apiKey = dotenv.env['API_KEY'].toString();
    String apiKey = const String.fromEnvironment("API_KEY");
    var response = await http.delete(
      Uri.parse(Constants.serverUrl + '/recipes/$id?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
    );
    try {
      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON
        var data = json.decode(response.body);
      } else if (response.statusCode == 404) {
        // If the server returns a 404 status code, the recipe was not found
        throw Exception('Recipe not found');
      } else {
        // If the server did not return a 200 OK response or a 404 status code,
        // throw an exception.
        throw Exception('Failed to delete recipe');
      }
    } catch (e) {
      // Handle any exceptions here
      print(e.toString());
    }
  }

  static const String routeName = '/details';
  FoodModel? food;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<FoodModel?>(
          future: loadFoodItem(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            } else if (snapshot.hasError) {
              return const Text('Error loading food item');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Text('No food item found');
            } else {
              final food = snapshot.data!;
              return Text(
                food.getTitle,
                style: TextStyle(
                  fontFamily: Constants.exoFont,
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
              //goto the edit page
              Get.toNamed(EditItemScreen.routeName);
            },
          ),
          SizedBox(width: 10.w),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Add your delete logic here
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Confirm Delete',
                      style: TextStyle(
                        fontFamily: Constants.exoFont,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    content: Text(
                      'Are you sure you want to delete this recipe?',
                      style: TextStyle(
                        fontFamily: Constants.exoFont,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: Constants.exoFont,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                      TextButton(
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            fontFamily: Constants.exoFont,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.red,
                          ),
                        ),
                        onPressed: () {
                          deleteFoodItem(
                              food!.getId); // Call the deleteFoodItem method
                          Navigator.of(context).pop(); // Close the dialog
                          Get.offAllNamed(Homescreen.routeName, arguments: true);
                        },
                      ),
                    ],
                  );
                },
              );
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
            food = snapshot.data!;
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
                    itemCount: food!.getIngredients.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.arrow_right),
                        title: Text(food!.getIngredients[index]),
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
                    child: Text(food!.getInstructions),
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
