class CategoryModel {
  final String id;
  final String userId;
  final String name;
  final String color;

  CategoryModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.color,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      color: json['color'] as String? ?? '#6366f1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'color': color,
    };
  }
}
