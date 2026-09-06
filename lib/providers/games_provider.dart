import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/seed_data.dart';
import '../models/game_model.dart';

class GamesNotifier extends Notifier<List<GameModel>> {
  @override
  List<GameModel> build() {
    return List.from(initialGames);
  }

  /// Agrega un nuevo juego a la lista
  void addGame(GameModel game) {
    state = [game, ...state];
  }

  /// Modifica un juego existente segun su ID
  void updateGame(GameModel updatedGame) {
    state = [
      for (final game in state)
        if (game.id == updatedGame.id) updatedGame else game
    ];
  }

  /// Elimina un juego por su ID
  void deleteGame(String id) {
    state = state.where((game) => game.id != id).toList();
  }
}

final gamesProvider = NotifierProvider<GamesNotifier, List<GameModel>>(
  GamesNotifier.new,
);

/// Proveedor para obtener un juego especifico por su ID reactivamente
final gameByIdProvider = Provider.family<GameModel?, String>((ref, id) {
  final games = ref.watch(gamesProvider);
  try {
    return games.firstWhere((game) => game.id == id);
  } catch (_) {
    return null;
  }
});
