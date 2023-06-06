import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_group_study/controller/provider/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../models/group_model.dart';
import '../../features/common/utils.dart';

final groupRepositoryProvider = Provider<GroupRepository>(
    (ref) => GroupRepository(ref.read(firestoreProvider)));

class GroupRepository {
  final FirebaseFirestore _firestore;

  GroupRepository(this._firestore);

  CollectionReference get _groups => _firestore.collection('group_model');

  FutureEither<GroupModel> getGroupById(String id) async {
    try {
      final group = await _groups.where('id', isEqualTo: id).limit(1).get();
      if (group.docs.isEmpty) {
        return left(Failure('Group not found'));
      } else {
        return right(GroupModel.fromMap(
            group.docs.first.data() as Map<String, dynamic>));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<GroupModel> createGroup(GroupModel groupModel) async {
    try {
      await _groups.doc(groupModel.id).set(groupModel.toMap());
      return right(groupModel);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
