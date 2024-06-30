import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipes_frontend/Constants.dart';
import 'package:recipes_frontend/models/food_model.dart';
import 'package:recipes_frontend/screens/Details.dart';
import 'package:recipes_frontend/screens/HomeScreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditItemScreen extends StatefulWidget {
  static final String routeName = '/edit-item';
  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadItemFromSharedPreferences();
  }

  void _loadItemFromSharedPreferences() async {
    // Retrieve the saved item from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
     String? savedItem = prefs.getString('savedFoodItem');

    if (savedItem != null) {
      // Parse the saved item as a FoodModel object
      FoodModel? foodModel = await FoodModel.fromJson(jsonDecode(savedItem) as Map<String, dynamic>);

      // Set the text for the text editing controllers
      setState(() {
        _titleController.text = foodModel?.title ?? '';
        _ingredientsController.text = foodModel?.ingredients.join(', ') ?? '';
        _instructionsController.text = foodModel?.instructions ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: _ingredientsController,
                  decoration: InputDecoration(
                    labelText: 'Ingredients (comma-separated)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  minLines: 1,
                  maxLines: 20,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter ingredients';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: _instructionsController,
                  decoration: InputDecoration(
                    labelText: 'Instructions',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  minLines: 3,
                  maxLines: 50,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter instructions';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: _editItem,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _editItem() async {
    //update
    if (_formKey.currentState!.validate()) {
      // Create a new FoodModel object with the updated values
      FoodModel updatedFoodItem = FoodModel.withoutId(
        title: _titleController.text,
        ingredients: _ingredientsController.text.split(',').map((e) => e.trim()).toList(),
        instructions: _instructionsController.text,
      );

      // Retrieve the saved item from SharedPreferences
      SharedPreferences.getInstance().then((prefs) async {
        String? savedItem = prefs.getString('savedFoodItem');
        if (savedItem != null) {
          // Parse the saved item as a FoodModel object
          FoodModel? foodModel = await FoodModel.fromJson(jsonDecode(savedItem) as Map<String, dynamic>);

          // Update the saved item with the new values
          updatedFoodItem.id = foodModel!.id;
          updateFoodItem(updatedFoodItem.id, updatedFoodItem);
        }
      });

      // Navigate back to the home screen
      Get.offAllNamed(Homescreen.routeName);
    }
  }

  Future<void> updateFoodItem(String id, FoodModel updatedFoodItem) async {
    //get the api key
    //await dotenv.load(fileName: "assets/.env");
    //String apiKey = dotenv.env['API_KEY'].toString();
    String apiKey = const String.fromEnvironment("API_KEY");
    var response = await http.put(
      Uri.parse(Constants.server_url + '/recipes/$id?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedFoodItem.toJson()),
    );
    try {
      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON
        var data = json.decode(response.body);
        // Do something with the data
      } else if (response.statusCode == 404) {
        // If the server returns a 404 status code, the recipe was not found
        throw Exception('Recipe not found');
      } else {
        // If the server did not return a 200 OK response or a 404 status code,
        // throw an exception.
        throw Exception('Failed to update recipe');
      }
    } catch (e) {
      // Handle any exceptions here
      print(e.toString());
    }
  }
}
