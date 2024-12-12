// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/failure.dart';
import 'package:reddit/core/providers/firebase_providers.dart';
import 'package:reddit/core/type_defs.dart';
import 'package:reddit/models/user_model.dart';

final userProfileRepositoryProvider = Provider(
  (ref) => UserProfileRepository(
    firestore: ref.read(fireStoreProvider),
  ),
);

class UserProfileRepository {
  final FirebaseFirestore _firestore;
  UserProfileRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;
  CollectionReference get _users => _firestore.collection("users");
  FutureVoid editProfile(UserModel user) async {
    try {
      return right(
        _users.doc(user.uid).update(user.toMap()),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }
}
