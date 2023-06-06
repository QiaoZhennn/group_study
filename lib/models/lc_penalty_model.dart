import 'dart:convert';

class LcPenaltyModel {
  final String id;
  final String userId;
  final String groupId;
  final DateTime createdAt;
  final double unitPrice;
  final int quantity;

  LcPenaltyModel({
    required this.id,
    required this.userId,
    required this.groupId,
    required this.createdAt,
    required this.unitPrice,
    required this.quantity,
  });

  LcPenaltyModel copyWith({
    String? id,
    String? userId,
    String? groupId,
    DateTime? createdAt,
    double? unitPrice,
    int? quantity,
  }) {
    return LcPenaltyModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      createdAt: createdAt ?? this.createdAt,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'groupId': groupId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'unitPrice': unitPrice,
      'quantity': quantity,
    };
  }

  factory LcPenaltyModel.fromMap(Map<String, dynamic> map) {
    return LcPenaltyModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      groupId: map['groupId'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      unitPrice: map['unitPrice']?.toDouble() ?? 0.0,
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory LcPenaltyModel.fromJson(String source) =>
      LcPenaltyModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LcPenaltyModel(id: $id, userId: $userId, groupId: $groupId, createdAt: $createdAt, unitPrice: $unitPrice, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LcPenaltyModel &&
        other.id == id &&
        other.userId == userId &&
        other.groupId == groupId &&
        other.createdAt == createdAt &&
        other.unitPrice == unitPrice &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        groupId.hashCode ^
        createdAt.hashCode ^
        unitPrice.hashCode ^
        quantity.hashCode;
  }
}
