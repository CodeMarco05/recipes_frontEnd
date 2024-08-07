import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipes_frontend/Constants.dart';
import 'package:recipes_frontend/models/food_model.dart';
import 'package:recipes_frontend/screens/home_screen.dart';
import 'package:http/http.dart' as http;

class AddItemScreen extends StatefulWidget {
  static final String routeName = '/add-item';
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  //q: for what is the form key used?
  //a
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

  Future<void> _addItem() async {
    if (_formKey.currentState!.validate()) {
      /*final newItem = FoodModel(
        title: _titleController.text,
        ingredients: _ingredientsController.text.split(','),
        instructions: _instructionsController.text,
      );*/

      final foodItem = FoodModel.withoutId(
        title: _titleController.text,
        //trim leading spaced
        ingredients: _ingredientsController.text.split(',').map((e) => e.trim()).toList(),
        instructions: _instructionsController.text,
      );

      //call the api for inser
      String apiKey = const String.fromEnvironment("API_KEY");

      var response = await http.post(
        Uri.parse('${Constants.serverUrl}/insertRecipe?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': foodItem.title,
          'ingredients': foodItem.ingredients,
          'instructions': foodItem.instructions,
        }),
      );

      try {
        if (response.statusCode == 201) {
          //Server was okay
        } else {
          // If the server did not return a 200 OK response,
          // throw an exception.
          throw Exception('Failed to add recipe');
        }
      } catch (e) {
        // Handle any exceptions here
        print(e.toString());
      }

      //homescreenController.addFoodItem(newItem);
      Get.toNamed(Homescreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAllNamed(Homescreen.routeName);
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
                      // Default border
                      borderRadius: BorderRadius.circular(8.0), // Rounded edges
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width:
                              1.0), // Solid border with specified color and width
                    ),
                    enabledBorder: OutlineInputBorder(
                      // Border when TextFormField is enabled
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // Border when TextFormField is focused
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Colors.blue,
                          width:
                              2.0), // Typically a different color or width to indicate focus
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextFormField(
                  controller: _ingredientsController,
                  decoration: InputDecoration(
                    labelText: 'Ingredients (comma-separated)',
                    border: OutlineInputBorder(
                      // Default border
                      borderRadius: BorderRadius.circular(8.0), // Rounded edges
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width:
                              1.0), // Solid border with specified color and width
                    ),
                    enabledBorder: OutlineInputBorder(
                      // Border when TextFormField is enabled
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // Border when TextFormField is focused
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Colors.blue,
                          width:
                              2.0), // Typically a different color or width to indicate focus
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
                SizedBox(
                  height: 20.h,
                ),
                TextFormField(
                  controller: _instructionsController,
                  decoration: InputDecoration(
                    labelText: 'Instructions',
                    border: OutlineInputBorder(
                      // Default border
                      borderRadius: BorderRadius.circular(8.0), // Rounded edges
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width:
                              1.0), // Solid border with specified color and width
                    ),
                    enabledBorder: OutlineInputBorder(
                      // Border when TextFormField is enabled
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // Border when TextFormField is focused
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: Colors.blue,
                          width:
                              2.0), // Typically a different color or width to indicate focus
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
                  onTap: _addItem,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        'Add Item',
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
}
