import 'dart:convert';

class LcSubmissionModel {
  final String id;
  final String problemId;
  final String userId;
  final String groupId;
  final DateTime createdAt;
  LcSubmissionModel({
    required this.id,
    required this.problemId,
    required this.userId,
    required this.groupId,
    required this.createdAt,
  });

  LcSubmissionModel copyWith({
    String? id,
    String? problemId,
    String? userId,
    String? groupId,
    DateTime? createdAt,
  }) {
    return LcSubmissionModel(
      id: id ?? this.id,
      problemId: problemId ?? this.problemId,
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'problemId': problemId,
      'userId': userId,
      'groupId': groupId,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory LcSubmissionModel.fromMap(Map<String, dynamic> map) {
    return LcSubmissionModel(
      id: map['id'] ?? '',
      problemId: map['problemId'] ?? '',
      userId: map['userId'] ?? '',
      groupId: map['groupId'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory LcSubmissionModel.fromJson(String source) =>
      LcSubmissionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LcSubmissionModel(id: $id, problemId: $problemId, userId: $userId, groupId: $groupId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LcSubmissionModel &&
        other.id == id &&
        other.problemId == problemId &&
        other.userId == userId &&
        other.groupId == groupId &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        problemId.hashCode ^
        userId.hashCode ^
        groupId.hashCode ^
        createdAt.hashCode;
  }
}
