import 'package:couzinty/features/auth/data/repos/auth_repo.dart';
import 'package:couzinty/features/auth/presentation/viewmodel/signup/signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Signup Cubit
class SignupCubit extends Cubit<SignupState> {
  final AuthRepo authRepo;

  SignupCubit({required this.authRepo}) : super(SignupInitial());

  Future<void> signup(String email, String password, String userName) async {
    emit(SignupLoading());

    final result = await authRepo.firebaseSignUp(userName, email, password);

    result.fold(
      (error) {
        emit(SignupError(error));
      },
      (r) {
        emit(SignupSuccess());
      },
    );
  }

  void resetState() {
    emit(SignupInitial());
  }
}
