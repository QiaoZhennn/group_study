import 'dart:convert';

class LcProblemModel {
  final String id;
  final String name;
  final String? difficulty;
  final String? category;
  LcProblemModel({
    required this.id,
    required this.name,
    this.difficulty,
    this.category,
  });

  LcProblemModel copyWith({
    String? id,
    String? name,
    String? difficulty,
    String? category,
  }) {
    return LcProblemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'difficulty': difficulty,
      'category': category,
    };
  }

  factory LcProblemModel.fromMap(Map<String, dynamic> map) {
    return LcProblemModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      difficulty: map['difficulty'],
      category: map['category'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LcProblemModel.fromJson(String source) =>
      LcProblemModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LcProblemModel(id: $id, name: $name, difficulty: $difficulty, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LcProblemModel &&
        other.id == id &&
        other.name == name &&
        other.difficulty == difficulty &&
        other.category == category;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        difficulty.hashCode ^
        category.hashCode;
  }
}
