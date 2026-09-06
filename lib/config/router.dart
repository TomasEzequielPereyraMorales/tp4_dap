import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/games/games_list_screen.dart';
import '../screens/games/game_detail_screen.dart';
import '../screens/games/game_form_screen.dart';

class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(Ref ref) {
    ref.listen(authProvider, (previous, next) {
      notifyListeners();
    });
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = GoRouterRefreshNotifier(ref);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isAuthenticated = authState.isAuthenticated;

      final isLoginRoute = state.matchedLocation == '/login';
      final isRegisterRoute = state.matchedLocation == '/register';
      final isAuthRoute = isLoginRoute || isRegisterRoute;

      // Si no esta autenticado y no esta en una ruta de auth, redirigir a login
      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      // Si ya esta autenticado e intenta ir a login o registro, redirigir al catalogo
      if (isAuthenticated && isAuthRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const GamesListScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/games/add',
        builder: (context, state) => const GameFormScreen(),
      ),
      GoRoute(
        path: '/games/:id',
        builder: (context, state) {
          final gameId = state.pathParameters['id']!;
          return GameDetailScreen(gameId: gameId);
        },
      ),
      GoRoute(
        path: '/games/:id/edit',
        builder: (context, state) {
          final gameId = state.pathParameters['id']!;
          return GameFormScreen(gameId: gameId);
        },
      ),
    ],
  );
});
