import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_group_study/controller/auth_controller.dart';
import 'package:f_group_study/features/common/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../models/group_model.dart';
import '../../models/user_model.dart';
import '../provider/firebase_providers.dart';

final userRepositoryProvider = Provider<UserRepository>(
    (ref) => UserRepository(ref.read(firestoreProvider)));

class UserRepository {
  final FirebaseFirestore _firestore;
  UserRepository(this._firestore);

  CollectionReference get _users => _firestore.collection('user_model');

  FutureEither<UserModel> joinGroups(String uid, GroupModel joinedGroup,
      {GroupModel? createdGroup}) async {
    try {
      print('userRepository joinGroups');
      final userDoc = await _users.doc(uid).get();
      if (!userDoc.exists) {
        return left(Failure('userDoc does not exist'));
      }
      UserModel user =
          UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      user.joinedGroups.add(joinedGroup);
      if (createdGroup != null) {
        user.createdGroups.add(createdGroup);
      }
      await _users.doc(uid).update(user.toMap());
      return right(user);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
