import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_group_study/controller/provider/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';
import '../../models/group_model.dart';
import '../../models/user_model.dart';

final groupRepositoryProvider = Provider<GroupRepository>(
    (ref) => GroupRepository(ref.read(firestoreProvider)));

class GroupRepository {
  final FirebaseFirestore _firestore;

  GroupRepository(this._firestore);

  CollectionReference get _groups => _firestore.collection('group_model');

  CollectionReference get _users => _firestore.collection('user_model');

  Stream<GroupModel> getGroupById(String id) {
    print('group_repository getGroupById($id)');
    return _groups.doc(id).snapshots().map((event) {
      if (event.exists) {
        GroupModel groupModel =
            GroupModel.fromMap(event.data() as Map<String, dynamic>);
        // print('group_repository members: ${groupModel.members}');
        return groupModel;
      }
      throw const DocumentNotFoundExeption();
    });
  }

  Future<void> createGroup(GroupModel groupModel) async {
    try {
      await _groups.doc(groupModel.id).set(groupModel.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<GroupModel>> getAllGroupsInSameTimeZone(
      int timeZoneOffset) async {
    print('group_repository getAllGroupsInSameTimeZone');
    final snapshot =
        await _groups.where('timeZoneOffset', isEqualTo: timeZoneOffset).get();
    final List<GroupModel> groupModels = snapshot.docs
        .map((e) => GroupModel.fromMap(e.data() as Map<String, dynamic>))
        .toList();
    return groupModels;
  }

  Future<List<UserModel>> getGroupMembers(GroupModel group) async {
    print('group_repository fetchGroupMembers');
    final snapshot =
        await _users.where(FieldPath.documentId, whereIn: group.members).get();
    return snapshot.docs
        .map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>))
        .toList();
  }

  Future<GroupModel> updateGroup(GroupModel group) async {
    print('group_repository updateGroup: ${group.id}');
    try {
      await _groups.doc(group.id).update(group.toMap());
      return group.copyWith();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<GroupModel>> getCreatedGroupsByUser(UserModel user) {
    print('user_repository getCreatedGroupsByUser');
    return _groups
        .where(FieldPath.documentId, whereIn: user.createdGroups)
        .snapshots()
        .map((event) {
      List<GroupModel> groupModels = [];
      for (var doc in event.docs) {
        groupModels.add(GroupModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return groupModels;
    });
  }

  Stream<List<GroupModel>> getJoinedGroupsByUser(UserModel user) {
    print('user_repository getJoinedGroupsByUser');
    return _groups
        .where(FieldPath.documentId, whereIn: user.joinedGroups)
        .snapshots()
        .map((event) {
      List<GroupModel> groupModels = [];
      for (var doc in event.docs) {
        groupModels.add(GroupModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return groupModels;
    });
  }

  Future<void> updateGroupsMembers(
    List<GroupModel> joinedGroups,
  ) async {
    final batch = _firestore.batch();
    for (final group in joinedGroups) {
      final groupRef = _groups.doc(group.id);
      batch.update(
          groupRef, {'members': group.members, 'createdBy': 'deletedAccount'});
      await _groups.doc(group.id).update(group.toMap());
    }
    await batch.commit();
  }
}
