import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/games_provider.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/game_image.dart';

class GameDetailScreen extends ConsumerWidget {
  final String gameId;

  const GameDetailScreen({super.key, required this.gameId});

  Future<void> _handleDelete(BuildContext context, WidgetRef ref, String title) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Eliminar Videojuego',
      content: 'Estas seguro de que deseas eliminar "? Esta accion no se puede deshacer.',
 confirmText: 'Eliminar',
 confirmColor: Colors.redAccent,
 );

 if (confirmed == true && context.mounted) {
 ref.read(gamesProvider.notifier).deleteGame(gameId);
 context.go('/');
 ScaffoldMessenger.of(context).showSnackBar(
 SnackBar(
 content: Text('Videojuego  eliminado correctamente.'),
 backgroundColor: Colors.redAccent,
 ),
 );
 }
 }

 @override
 Widget build(BuildContext context, WidgetRef ref) {
 final game = ref.watch(gameByIdProvider(gameId));

 if (game == null) {
 return Scaffold(
 appBar: AppBar(title: const Text('Detalle')),
 body: Center(
 child: Column(
 mainAxisAlignment: MainAxisAlignment.center,
 children: [
 const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
 const SizedBox(height: 16),
 const Text(
 'Videojuego no encontrado',
 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
 ),
 const SizedBox(height: 12),
 ElevatedButton(
 onPressed: () => context.go('/'),
 child: const Text('Volver al catalogo'),
 ),
 ],
 ),
 ),
 );
 }

 return Scaffold(
 body: CustomScrollView(
 slivers: [
 // Cabecera con imagen expandible
 SliverAppBar(
 expandedHeight: 280,
 pinned: true,
 flexibleSpace: FlexibleSpaceBar(
 background: Stack(
 fit: StackFit.expand,
 children: [
 GameImage(
 imageUrl: game.imageUrl,
 width: double.infinity,
 height: double.infinity,
 fit: BoxFit.cover,
 ),
 Container(
 decoration: BoxDecoration(
 gradient: LinearGradient(
 colors: [
 Colors.transparent,
 const Color(0xFF121421).withAlpha(230),
 ],
 begin: Alignment.topCenter,
 end: Alignment.bottomCenter,
 ),
 ),
 ),
 ],
 ),
 ),
 actions: [
 IconButton(
 icon: const Icon(Icons.edit_rounded),
 tooltip: 'Editar',
 onPressed: () => context.push('/games//edit'),
 ),
 IconButton(
 icon: const Icon(Icons.delete_outline_rounded),
 tooltip: 'Eliminar',
 onPressed: () => _handleDelete(context, ref, game.title),
 ),
 ],
 ),

 // Contenido con detalles
 SliverToBoxAdapter(
 child: Padding(
 padding: const EdgeInsets.all(20),
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 // Titulo y Calificacion
 Row(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Expanded(
 child: Text(
 game.title,
 style: const TextStyle(
 fontSize: 26,
 fontWeight: FontWeight.bold,
 color: Colors.white,
 ),
 ),
 ),
 const SizedBox(width: 12),
 Container(
 padding: const EdgeInsets.symmetric(
 horizontal: 12,
 vertical: 8,
 ),
 decoration: BoxDecoration(
 color: const Color(0xFF1E2235),
 borderRadius: BorderRadius.circular(12),
 border: Border.all(
 color: Colors.amber.withAlpha(180),
 width: 1.5,
 ),
 ),
 child: Row(
 mainAxisSize: MainAxisSize.min,
 children: [
 const Icon(
 Icons.star_rounded,
 color: Colors.amber,
 size: 22,
 ),
 const SizedBox(width: 6),
 Text(
 game.rating.toStringAsFixed(1),
 style: const TextStyle(
 color: Colors.white,
 fontWeight: FontWeight.bold,
 fontSize: 16,
 ),
 ),
 ],
 ),
 ),
 ],
 ),
 const SizedBox(height: 20),

 // Fila de metadatos (Genero, Plataformas, Anio, Desarrollador)
 _buildInfoTile(
 icon: Icons.category_rounded,
 label: 'Genero',
 value: game.genre,
 ),
 const SizedBox(height: 12),
 _buildInfoTile(
 icon: Icons.devices_rounded,
 label: 'Plataformas',
 value: game.platform,
 ),
 const SizedBox(height: 12),
 _buildInfoTile(
 icon: Icons.calendar_today_rounded,
 label: 'Ano de Lanzamiento',
 value: '${game.releaseYear}',
 ),
 const SizedBox(height: 12),
 _buildInfoTile(
 icon: Icons.business_rounded,
 label: 'Desarrollador',
 value: game.developer,
 ),
 const SizedBox(height: 24),

 // Descripcion
 const Text(
 'Descripcion',
 style: TextStyle(
 fontSize: 18,
 fontWeight: FontWeight.bold,
 color: Colors.white,
 ),
 ),
 const SizedBox(height: 10),
 Container(
 padding: const EdgeInsets.all(16),
 width: double.infinity,
 decoration: BoxDecoration(
 color: const Color(0xFF1E2235),
 borderRadius: BorderRadius.circular(14),
 border: Border.all(color: Colors.white.withAlpha(20)),
 ),
 child: Text(
 game.description,
 style: TextStyle(
 fontSize: 15,
 color: Colors.grey.shade300,
 height: 1.5,
 ),
 ),
 ),
 const SizedBox(height: 32),

 // Botones de accion
 Row(
 children: [
 Expanded(
 child: OutlinedButton.icon(
 style: OutlinedButton.styleFrom(
 side: const BorderSide(color: Colors.redAccent),
 foregroundColor: Colors.redAccent,
 padding: const EdgeInsets.symmetric(vertical: 14),
 shape: RoundedRectangleBorder(
 borderRadius: BorderRadius.circular(12),
 ),
 ),
 onPressed: () => _handleDelete(context, ref, game.title),
 icon: const Icon(Icons.delete_outline_rounded),
 label: const Text('Eliminar'),
 ),
 ),
 const SizedBox(width: 16),
 Expanded(
 child: ElevatedButton.icon(
 style: ElevatedButton.styleFrom(
 padding: const EdgeInsets.symmetric(vertical: 14),
 shape: RoundedRectangleBorder(
 borderRadius: BorderRadius.circular(12),
 ),
 ),
 onPressed: () => context.push('/games//edit'),
 icon: const Icon(Icons.edit_rounded),
 label: const Text('Editar'),
 ),
 ),
 ],
 ),
 const SizedBox(height: 20),
 ],
 ),
 ),
 ),
 ],
 ),
 );
 }

 Widget _buildInfoTile({
 required IconData icon,
 required String label,
 required String value,
 }) {
 return Container(
 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
 decoration: BoxDecoration(
 color: const Color(0xFF1E2235),
 borderRadius: BorderRadius.circular(12),
 border: Border.all(color: Colors.white.withAlpha(15)),
 ),
 child: Row(
 children: [
 Icon(icon, size: 20, color: const Color(0xFF6366F1)),
 const SizedBox(width: 12),
 Text(
 label,
 style: TextStyle(
 fontSize: 14,
 color: Colors.grey.shade400,
 fontWeight: FontWeight.w500,
 ),
 ),
 const Spacer(),
 Flexible(
 child: Text(
 value,
 textAlign: TextAlign.right,
 style: const TextStyle(
 fontSize: 14,
 color: Colors.white,
 fontWeight: FontWeight.w600,
 ),
 overflow: TextOverflow.ellipsis,
 ),
 ),
 ],
 ),
 );
 }
}
