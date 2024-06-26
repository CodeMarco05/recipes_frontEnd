class FoodModel {
  String id;
  String title;
  List<String> ingredients;
  String instructions;
  final DateTime createdAt;
  final DateTime updatedAt;

  FoodModel({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.createdAt,
    required this.updatedAt,
  });

  //empty constructor

  FoodModel.withoutId({
    required this.title,
    required this.ingredients,
    required this.instructions,
  })  : id = 'default_id', // Consider generating a unique ID instead
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  String get getId => id;

  String get getTitle => title;

  List<String> get getIngredients => ingredients;

  String get getInstructions => instructions;

  DateTime get getCreatedAt => createdAt;

  DateTime get getUpdatedAt => updatedAt;

  set setId(String newId) {
    id = newId;
  }

  set setTitle(String newTitle) {
    title = newTitle;
  }

  set setIngredients(List<String> newIngredients) {
    ingredients = newIngredients;
  }

  set setInstructions(String newInstructions) {
    instructions = newInstructions;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
    };
  }

  static Future<FoodModel?> fromJson(Map<String, dynamic> map) {
    try {
      return Future.value(FoodModel(
        id: map['id'],
        title: map['title'],
        ingredients: map['ingredients'].cast<String>(),
        instructions: map['instructions'],
        createdAt: DateTime.parse(map['createdAt']),
        updatedAt: DateTime.parse(map['updatedAt']),
      ));
    } catch (e) {
      return Future.error(e);
    }
  }
}
