import 'package:awesome_music/services/api/api_client.dart';
import 'package:awesome_music/services/api/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthCubitState {}

class AuthCubitStatePending extends AuthCubitState {}

class AuthCubitStateError extends AuthCubitState {}

class AuthCubitStateSuccess extends AuthCubitState {
  User? authenticatedUser;
  User get requireAuthenticatedUser => authenticatedUser!;
  bool get isAuthenticated => authenticatedUser != null;
  bool get isNotAuthenticated => !isAuthenticated;

  AuthCubitStateSuccess(this.authenticatedUser);
}

class AuthCubit extends Cubit<AuthCubitState> {
  final ApiClient _apiClient;
  AuthCubit(AuthCubitState initialState, {required ApiClient apiClient})
      : _apiClient = apiClient,
        super(initialState);

  /// this method never returns error. If user is not authenticated,
  /// it returns success with null user
  void checkAuthenticationState() async {
    try {
      emit(AuthCubitStatePending());
      final user = await _apiClient.fetchAuthenticatedUser();
      emit(AuthCubitStateSuccess(user));
    } catch (_) {
      emit(AuthCubitStateSuccess(null));
    }
  }

  void authenticate(String email, String password) async {
    try {
      emit(AuthCubitStatePending());
      final user = await _apiClient.authenticate(email, password);
      emit(AuthCubitStateSuccess(user));
    } catch (_) {
      emit(AuthCubitStateError());
    }
  }
}
