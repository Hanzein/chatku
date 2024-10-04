import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository _userRepository;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SignInBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SignInInitial()) {
    on<SignInRequired>((event, emit) async {
      emit(SignInProcess());
      try {
        await _userRepository.signIn(event.email, event.password);

        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: event.email, password: event.password);

        print('Trying to write to Firestore');
        _firestore.collection("Users").doc(userCredential.user!.uid).set(
            {
              'uid': userCredential.user!.uid,
              'email': event.email
            }
        ).then((value) => print("User added successfully"))
            .catchError((error) => print("Failed to add user: $error"));

        emit(SignInSuccess());
      } on FirebaseAuthException catch (e) {
        emit(SignInFailure(message: e.code));
      } catch (e) {
        emit(const SignInFailure());
      }
    });
    on<SignOutRequired>((event, emit) async {
      await _userRepository.logOut();
    });
  }
}
