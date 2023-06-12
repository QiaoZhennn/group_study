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
  CollectionReference get _groups => _firestore.collection('group_model');

  Future<UserModel> updateUser(UserModel user) async {
    print('user_repository updateUser');
    try {
      await _users.doc(user.id).update(user.toMap());
      return user.copyWith();
    } catch (e) {
      print('user_repository updateUser error: $e');
      rethrow;
    }
  }

  Future<void> updateCreatedGroups(UserModel user) async {
    print('user_repository updateCreatedGroups');
    try {
      await _users.doc(user.id).update({'createdGroups': user.createdGroups});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateJoinedGroups(UserModel user) async {
    print('user_repository updateJoinedGroups');
    try {
      await _users.doc(user.id).update({'joinedGroups': user.joinedGroups});
    } catch (e) {
      rethrow;
    }
  }

  // FutureEither<UserModel> joinGroups(UserModel user, GroupModel joinedGroup,
  //     {GroupModel? createdGroup}) async {
  //   try {
  //     joinedGroup.users.add(user.id);
  //     user.joinedGroups.add(joinedGroup);
  //     if (createdGroup != null) {
  //       user.createdGroups.add(createdGroup);
  //     }
  //     await _users.doc(uid).update(user.toMap());
  //     return right(user);
  //   } catch (e) {
  //     return left(Failure(e.toString()));
  //   }
  // }

  Stream<UserModel> getUserById(String id) {
    print('user_repository getUserById');
    try {
      return _users.doc(id).snapshots().map(
          (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUserById(String id) {
    print('user_repository deleteUserById');
    try {
      return _users.doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }
}
