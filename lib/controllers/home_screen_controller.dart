import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:recipes_frontend/Constants.dart';
import 'package:recipes_frontend/models/food_model.dart';

class HomescreenController extends GetxController {
  Future<List<FoodModel>> getFoodItems() async {
    //get the api key
    //await dotenv.load(fileName: "assets/.env");
    //String apiKey = dotenv.env['API_KEY'].toString();

    String apiKey = const String.fromEnvironment("API_KEY");

    List<FoodModel> foodItems = [];

    var response = await http.get(
      Uri.parse(Constants.server_url + '/recipes?key=$apiKey'),
      //Uri.parse(Constants.server_url + '/recipes'),
      headers: {'Content-Type': 'application/json'},
    );

    try {
      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON
        var data = json.decode(response.body);
        // Do something with the data

        for (var item in data) {
          foodItems.add(FoodModel(
            id: item['_id'],
            title: item['title'],
            ingredients: item['ingredients'].cast<String>(),
            instructions: item['instructions'],
            createdAt: DateTime.parse(item['createdAt']),
            updatedAt: DateTime.parse(item['updatedAt']),
          ));
        }
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      // Handle any exceptions here
      print(e.toString());
    }
    return foodItems;
  }

  Future<void> addFoodItem(FoodModel foodItem) async {
    //get the api key
    //await dotenv.load(fileName: "assets/.env");
    //String apiKey = dotenv.env['API_KEY'].toString();

    String apiKey = const String.fromEnvironment("API_KEY");

    var response = await http.post(
      Uri.parse(Constants.server_url + '/recipes?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': foodItem.title,
        'ingredients': foodItem.ingredients,
        'instructions': foodItem.instructions,
      }),
    );

    try {
      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON
        var data = json.decode(response.body);
        // Do something with the data
        print(data);
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to add recipe');
      }
    } catch (e) {
      // Handle any exceptions here
      print(e.toString());
    }
  }

  //delete item
  Future<void> deleteFoodItem(String id) async {
    //get the api key
    //await dotenv.load(fileName: "assets/.env");
    //String apiKey = dotenv.env['API_KEY'].toString();
    String apiKey = const String.fromEnvironment("API_KEY");
    var response = await http.delete(
      Uri.parse(Constants.server_url + '/recipes/$id?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
    );
    try {
      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON
        var data = json.decode(response.body);
        // Do something with the data
        print(data);
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
        print(data);
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
