import 'dart:convert';

class Dish {
  int? id;
  String? title;
  String? description;
  String? imagePath;
  Dish({
    this.id,
    this.title,
    this.description,
    this.imagePath,
  });

  Dish copyWith({
    int? id,
    String? title,
    String? description,
    String? imagePath,
  }) {
    return Dish(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imagePath': imagePath,
    };
  }

  factory Dish.fromMap(Map<String, dynamic> map) {
    return Dish(
      id: map['id']?.toInt(),
      title: map['title'],
      description: map['description'],
      imagePath: map['imagePath'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Dish.fromJson(String source) => Dish.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Dish(id: $id, title: $title, description: $description, imagePath: $imagePath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Dish &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.imagePath == imagePath;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        imagePath.hashCode;
  }
}
