import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/games_provider.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/game_card.dart';

class GamesListScreen extends ConsumerStatefulWidget {
  const GamesListScreen({super.key});

  @override
  ConsumerState<GamesListScreen> createState() => _GamesListScreenState();
}

class _GamesListScreenState extends ConsumerState<GamesListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose;
    super.dispose();
  }

  Future<void> _handleLogout() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Cerrar Sesion',
      content: 'Estas seguro de que deseas cerrar tu sesion?',
      confirmText: 'Cerrar Sesion',
      confirmColor: Colors.redAccent,
    );

    if (confirmed == true && mounted) {
      ref.read(authProvider.notifier).logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final games = ref.watch(gamesProvider);
    final userName = authState.currentUser?.name ?? 'Gamer';

    final filteredGames = games.where((game) {
      final query = _searchQuery.toLowerCase();
      final titleMatch = game.title.toLowerCase().contains(query);
      final genreMatch = game.genre.toLowerCase().contains(query);
      final platformMatch = game.platform.toLowerCase().contains(query);
      return titleMatch || genreMatch || platformMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(50),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.sports_esports_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'GameVault',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Hola, $userName',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Cerrar sesion',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de busqueda
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por titulo, genero o plataforma...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value.trim());
              },
            ),
          ),

          // Contador de juegos
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Row(
              children: [
                Text(
                  'Catalogo ()',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),

          // Listado
          Expanded(
            child: filteredGames.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No hay videojuegos registrados'
                              : 'No se encontraron juegos para "',
 style: TextStyle(
 fontSize: 16,
 color: Colors.grey.shade400,
 ),
 ),
 const SizedBox(height: 12),
 if (_searchQuery.isEmpty)
 ElevatedButton.icon(
 onPressed: () => context.push('/games/add'),
 icon: const Icon(Icons.add),
 label: const Text('Agregar el primer videojuego'),
 ),
 ],
 ),
 )
 : ListView.builder(
 padding: const EdgeInsets.only(bottom: 80, top: 4),
 itemCount: filteredGames.length,
 itemBuilder: (context, index) {
 final game = filteredGames[index];
 return GameCard(game: game);
 },
 ),
 ),
 ],
 ),
 floatingActionButton: FloatingActionButton.extended(
 onPressed: () => context.push('/games/add'),
 icon: const Icon(Icons.add_rounded),
 label: const Text('Nuevo Juego'),
 ),
 );
 }
}
