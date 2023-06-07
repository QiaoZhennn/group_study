import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_group_study/controller/provider/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../constants.dart';
import '../../models/group_model.dart';
import '../../features/common/utils.dart';

final groupRepositoryProvider = Provider<GroupRepository>(
    (ref) => GroupRepository(ref.read(firestoreProvider)));

class GroupRepository {
  final FirebaseFirestore _firestore;

  GroupRepository(this._firestore);

  CollectionReference get _groups => _firestore.collection('group_model');

  Future<GroupModel> getGroupById(String id) async {
    print('group_repository getGroupById($id)');
    final group = await _groups.doc(id).get();
    if (group.exists) {
      GroupModel groupModel =
          GroupModel.fromMap(group.data() as Map<String, dynamic>);
      return groupModel;
    }
    throw const DocumentNotFoundExeption();
  }

  FutureVoid createGroup(GroupModel groupModel) async {
    try {
      return right(await _groups.doc(groupModel.id).set(groupModel.toMap()));
    } catch (e) {
      return left(Failure(e.toString()));
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
}
