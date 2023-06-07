import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:f_group_study/models/group_model.dart';
import 'package:f_group_study/models/lc_submission_model.dart';

import 'lc_penalty_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  final int timeZoneOffset;
  final String lcAccountName;
  final List<LcSubmissionModel> lcSubmissions;
  final List<LcPenaltyModel> lcPenalties;
  final double lcBalance;
  final List<GroupModel> joinedGroups;
  final List<GroupModel> createdGroups;
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.timeZoneOffset,
    required this.lcAccountName,
    required this.lcSubmissions,
    required this.lcPenalties,
    required this.lcBalance,
    required this.joinedGroups,
    required this.createdGroups,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? createdAt,
    int? timeZoneOffset,
    String? lcAccountName,
    List<LcSubmissionModel>? lcSubmissions,
    List<LcPenaltyModel>? lcPenalties,
    double? lcBalance,
    List<GroupModel>? joinedGroups,
    List<GroupModel>? createdGroups,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      timeZoneOffset: timeZoneOffset ?? this.timeZoneOffset,
      lcAccountName: lcAccountName ?? this.lcAccountName,
      lcSubmissions: lcSubmissions ?? this.lcSubmissions,
      lcPenalties: lcPenalties ?? this.lcPenalties,
      lcBalance: lcBalance ?? this.lcBalance,
      joinedGroups: joinedGroups ?? this.joinedGroups,
      createdGroups: createdGroups ?? this.createdGroups,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'timeZoneOffset': timeZoneOffset,
      'lcAccountName': lcAccountName,
      'lcSubmissions': lcSubmissions.map((x) => x.toMap()).toList(),
      'lcPenalties': lcPenalties.map((x) => x.toMap()).toList(),
      'lcBalance': lcBalance,
      'joinedGroups': joinedGroups.map((x) => x.toMap()).toList(),
      'createdGroups': createdGroups.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      timeZoneOffset: map['timeZoneOffset']?.toInt() ?? 0,
      lcAccountName: map['lcAccountName'] ?? '',
      lcSubmissions: List<LcSubmissionModel>.from(
          map['lcSubmissions']?.map((x) => LcSubmissionModel.fromMap(x))),
      lcPenalties: List<LcPenaltyModel>.from(
          map['lcPenalties']?.map((x) => LcPenaltyModel.fromMap(x))),
      lcBalance: map['lcBalance']?.toDouble() ?? 0.0,
      joinedGroups: List<GroupModel>.from(
          map['joinedGroups']?.map((x) => GroupModel.fromMap(x))),
      createdGroups: List<GroupModel>.from(
          map['createdGroups']?.map((x) => GroupModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, createdAt: $createdAt, timeZoneOffset: $timeZoneOffset, lcAccountName: $lcAccountName, lcSubmissions: $lcSubmissions, lcPenalties: $lcPenalties, lcBalance: $lcBalance, joinedGroups: $joinedGroups, createdGroups: $createdGroups)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.createdAt == createdAt &&
        other.timeZoneOffset == timeZoneOffset &&
        other.lcAccountName == lcAccountName &&
        listEquals(other.lcSubmissions, lcSubmissions) &&
        listEquals(other.lcPenalties, lcPenalties) &&
        other.lcBalance == lcBalance &&
        listEquals(other.joinedGroups, joinedGroups) &&
        listEquals(other.createdGroups, createdGroups);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        createdAt.hashCode ^
        timeZoneOffset.hashCode ^
        lcAccountName.hashCode ^
        lcSubmissions.hashCode ^
        lcPenalties.hashCode ^
        lcBalance.hashCode ^
        joinedGroups.hashCode ^
        createdGroups.hashCode;
  }
}
