import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/seed_data.dart';
import '../models/user_model.dart';

class AuthState {
  final UserModel? currentUser;
  final List<UserModel> registeredUsers;
  final String? errorMessage;

  const AuthState({
    this.currentUser,
    required this.registeredUsers,
    this.errorMessage,
  });

  bool get isAuthenticated => currentUser != null;

  AuthState copyWith({
    UserModel? currentUser,
    bool clearCurrentUser = false,
    List<UserModel>? registeredUsers,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      currentUser: clearCurrentUser ? null : (currentUser ?? this.currentUser),
      registeredUsers: registeredUsers ?? this.registeredUsers,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState(
      currentUser: null,
      registeredUsers: List.from(initialUsers),
    );
  }

  /// Inicia sesion con email y contrasena
  /// Retorna null si fue exitoso, o el mensaje de error si fallo
  String? login(String email, String password) {
    final normalizedEmail = email.trim().toLowerCase();
    final cleanPassword = password.trim();

    try {
      final user = state.registeredUsers.firstWhere(
        (u) =>
            u.email.toLowerCase() == normalizedEmail &&
            u.password == cleanPassword,
      );

      state = state.copyWith(
        currentUser: user,
        clearError: true,
      );
      return null;
    } catch (_) {
      const error = 'Correo electronico o contrasena incorrectos.';
      state = state.copyWith(errorMessage: error);
      return error;
    }
  }

  /// Registra un nuevo usuario
  /// Retorna null si fue exitoso, o el mensaje de error si fallo
  String? register({
    required String name,
    required String email,
    required String password,
  }) {
    final normalizedEmail = email.trim().toLowerCase();
    final cleanName = name.trim();
    final cleanPassword = password.trim();

    final exists = state.registeredUsers.any(
      (u) => u.email.toLowerCase() == normalizedEmail,
    );

    if (exists) {
      const error = 'Ya existe un usuario registrado con este correo.';
      state = state.copyWith(errorMessage: error);
      return error;
    }

    final newUser = UserModel(
      id: 'user_',
      name: cleanName,
      email: normalizedEmail,
      password: cleanPassword,
    );

    final updatedUsers = [...state.registeredUsers, newUser];
    state = state.copyWith(
      currentUser: newUser, // Inicia sesion automaticamente al registrarse
      registeredUsers: updatedUsers,
      clearError: true,
    );

    return null;
  }

  /// Cierra la sesion activa
  void logout() {
    state = state.copyWith(
      clearCurrentUser: true,
      clearError: true,
    );
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
