import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_repository/src/entities/entities.dart';
import 'package:user_repository/src/models/models.dart';
import 'package:user_repository/src/user_repo.dart';

class FirebaseUserRepo implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final userCollection = FirebaseFirestore.instance.collection('users');

  FirebaseUserRepo({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<MyUser?> get user {
    return _firebaseAuth.authStateChanges().flatMap((fireBaseUser) async* {
      if (fireBaseUser == null) {
        yield MyUser.empty;
      } else {
        try {
          final doc = await userCollection.doc(fireBaseUser.uid).get();
          if (doc.data() != null) {
            yield MyUser.fromEntity(MyUserEntity.fromJson(doc.data()!));
          } else {
            // Firestore document missing — fall back to Auth data
            log('No Firestore document for ${fireBaseUser.uid}, using Auth data');
            yield MyUser(
              userId: fireBaseUser.uid,
              email: fireBaseUser.email ?? '',
              name: fireBaseUser.displayName ?? '',
              hasActiveCart: false,
            );
          }
        } catch (e) {
          log('Error fetching user document: $e');
          yield MyUser(
            userId: fireBaseUser.uid,
            email: fireBaseUser.email ?? '',
            name: fireBaseUser.displayName ?? '',
            hasActiveCart: false,
          );
        }
      }
    });
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  signUp(MyUser myUser, String password) async {
    try {
      UserCredential userFirebase =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: myUser.email, password: password);

      myUser.userId = userFirebase.user!.uid;
      return myUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> setUserData(myUser) async {
    try {
      await userCollection.doc(myUser.userId).set(myUser.toEntity().toJson());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
