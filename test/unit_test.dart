import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tp4_dap/models/game_model.dart';
import 'package:tp4_dap/providers/auth_provider.dart';
import 'package:tp4_dap/providers/games_provider.dart';

void main() {
  group('AuthProvider Tests', () {
    test('Estado inicial no esta autenticado y lista de usuarios vacia', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(authProvider);
      expect(state.isAuthenticated, isFalse);
      expect(state.currentUser, isNull);
      expect(state.registeredUsers.isEmpty, isTrue);
    });

    test('Registro de nuevo usuario e inicio de sesion automatico', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(authProvider.notifier);
      final error = notifier.register(
        name: 'Gamer Pro',
        email: 'gamer@test.com',
        password: 'password123',
      );

      expect(error, isNull);
      final state = container.read(authProvider);
      expect(state.isAuthenticated, isTrue);
      expect(state.currentUser?.name, equals('Gamer Pro'));
    });

    test('Registro falla si el email ya existe', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(authProvider.notifier);
      notifier.register(
        name: 'Primer Usuario',
        email: 'gamer@test.com',
        password: 'password123',
      );

      final error = notifier.register(
        name: 'Segundo Usuario',
        email: 'gamer@test.com',
        password: 'otraPassword',
      );

      expect(error, isNotNull);
    });

    test('Login fallido con credenciales incorrectas', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(authProvider.notifier);
      final error = notifier.login('usuario@falso.com', 'passwordErroneo');

      expect(error, isNotNull);
      expect(container.read(authProvider).isAuthenticated, isFalse);
    });

    test('Login exitoso y logout de usuario registrado', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(authProvider.notifier);
      notifier.register(
        name: 'Gamer Pro',
        email: 'gamer@test.com',
        password: 'password123',
      );
      notifier.logout();
      expect(container.read(authProvider).isAuthenticated, isFalse);

      final error = notifier.login('gamer@test.com', 'password123');
      expect(error, isNull);
      expect(container.read(authProvider).isAuthenticated, isTrue);
      expect(container.read(authProvider).currentUser?.name, equals('Gamer Pro'));
    });
  });

  group('GamesProvider CRUD Tests', () {
    test('Carga lista inicial de videojuegos', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final games = container.read(gamesProvider);
      expect(games.length, greaterThanOrEqualTo(5));
    });

    test('Alta de videojuego (addGame)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(gamesProvider.notifier);
      const newGame = GameModel(
        id: 'test_game_1',
        title: 'Super Mario Odyssey',
        description: 'Aventura 3D inolvidable de plataformas',
        imageUrl: 'https://example.com/mario.jpg',
        genre: 'Plataformas',
        platform: 'Nintendo Switch',
        releaseYear: 2017,
        rating: 9.7,
        developer: 'Nintendo',
      );

      notifier.addGame(newGame);

      final games = container.read(gamesProvider);
      expect(games.any((g) => g.id == 'test_game_1'), isTrue);
      expect(games.first.title, equals('Super Mario Odyssey'));
    });

    test('Modificacion de videojuego (updateGame)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(gamesProvider.notifier);
      final firstGame = container.read(gamesProvider).first;

      final updatedGame = firstGame.copyWith(
        title: 'Titulo Modificado',
        rating: 10.0,
      );

      notifier.updateGame(updatedGame);

      final gameAfter = container.read(gameByIdProvider(firstGame.id));
      expect(gameAfter?.title, equals('Titulo Modificado'));
      expect(gameAfter?.rating, equals(10.0));
    });

    test('Baja de videojuego (deleteGame)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(gamesProvider.notifier);
      final firstGame = container.read(gamesProvider).first;

      notifier.deleteGame(firstGame.id);

      final games = container.read(gamesProvider);
      expect(games.any((g) => g.id == firstGame.id), isFalse);
      expect(container.read(gameByIdProvider(firstGame.id)), isNull);
    });
  });
}
