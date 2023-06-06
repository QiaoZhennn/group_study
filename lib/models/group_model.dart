import 'dart:convert';

import 'package:flutter/foundation.dart';

class GroupModel {
  final String id;
  final String name;
  final String description;
  final List<String> users;
  final String createdBy;
  final DateTime createdAt; // UTC
  final int timeZoneOffset; // CreatorTimeZone - UTC
  final bool isPublic;
  final String studyContent;
  final int checkResultCount;
  final int checkResultTimeCount;
  final String checkResultTimeUnit;
  final double checkResultPerPenalty;
  GroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.users,
    required this.createdBy,
    required this.createdAt,
    required this.timeZoneOffset,
    required this.isPublic,
    required this.studyContent,
    required this.checkResultCount,
    required this.checkResultTimeCount,
    required this.checkResultTimeUnit,
    required this.checkResultPerPenalty,
  });

  GroupModel copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? users,
    String? createdBy,
    DateTime? createdAt,
    int? timeZoneOffset,
    bool? isPublic,
    String? studyContent,
    int? checkResultCount,
    int? checkResultTimeCount,
    String? checkResultTimeUnit,
    double? checkResultPerPenalty,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      users: users ?? this.users,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      timeZoneOffset: timeZoneOffset ?? this.timeZoneOffset,
      isPublic: isPublic ?? this.isPublic,
      studyContent: studyContent ?? this.studyContent,
      checkResultCount: checkResultCount ?? this.checkResultCount,
      checkResultTimeCount: checkResultTimeCount ?? this.checkResultTimeCount,
      checkResultTimeUnit: checkResultTimeUnit ?? this.checkResultTimeUnit,
      checkResultPerPenalty:
          checkResultPerPenalty ?? this.checkResultPerPenalty,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'users': users,
      'createdBy': createdBy,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'timeZoneOffset': timeZoneOffset,
      'isPublic': isPublic,
      'studyContent': studyContent,
      'checkResultCount': checkResultCount,
      'checkResultTimeCount': checkResultTimeCount,
      'checkResultTimeUnit': checkResultTimeUnit,
      'checkResultPerPenalty': checkResultPerPenalty,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      users: List<String>.from(map['users']),
      createdBy: map['createdBy'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      timeZoneOffset: map['timeZoneOffset']?.toInt() ?? 0,
      isPublic: map['isPublic'] ?? false,
      studyContent: map['studyContent'] ?? '',
      checkResultCount: map['checkResultCount']?.toInt() ?? 0,
      checkResultTimeCount: map['checkResultTimeCount']?.toInt() ?? 0,
      checkResultTimeUnit: map['checkResultTimeUnit'] ?? '',
      checkResultPerPenalty: map['checkResultPerPenalty']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupModel.fromJson(String source) =>
      GroupModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GroupModel(id: $id, name: $name, description: $description, users: $users, createdBy: $createdBy, createdAt: $createdAt, timeZoneOffset: $timeZoneOffset, isPublic: $isPublic, studyContent: $studyContent, checkResultCount: $checkResultCount, checkResultTimeCount: $checkResultTimeCount, checkResultTimeUnit: $checkResultTimeUnit, checkResultPerPenalty: $checkResultPerPenalty)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroupModel &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        listEquals(other.users, users) &&
        other.createdBy == createdBy &&
        other.createdAt == createdAt &&
        other.timeZoneOffset == timeZoneOffset &&
        other.isPublic == isPublic &&
        other.studyContent == studyContent &&
        other.checkResultCount == checkResultCount &&
        other.checkResultTimeCount == checkResultTimeCount &&
        other.checkResultTimeUnit == checkResultTimeUnit &&
        other.checkResultPerPenalty == checkResultPerPenalty;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        users.hashCode ^
        createdBy.hashCode ^
        createdAt.hashCode ^
        timeZoneOffset.hashCode ^
        isPublic.hashCode ^
        studyContent.hashCode ^
        checkResultCount.hashCode ^
        checkResultTimeCount.hashCode ^
        checkResultTimeUnit.hashCode ^
        checkResultPerPenalty.hashCode;
  }
}
