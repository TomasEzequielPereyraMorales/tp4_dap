import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/game_model.dart';
import '../../providers/games_provider.dart';

class GameFormScreen extends ConsumerStatefulWidget {
  final String? gameId;

  const GameFormScreen({super.key, this.gameId});

  @override
  ConsumerState<GameFormScreen> createState() => _GameFormScreenState();
}

class _GameFormScreenState extends ConsumerState<GameFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _genreController = TextEditingController();
  final _platformController = TextEditingController();
  final _yearController = TextEditingController();
  final _ratingController = TextEditingController();
  final _developerController = TextEditingController();

  bool _isInitialized = false;

  bool get isEditing => widget.gameId != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized && isEditing) {
      final game = ref.read(gameByIdProvider(widget.gameId!));
      if (game != null) {
        _titleController.text = game.title;
        _descriptionController.text = game.description;
        _imageUrlController.text = game.imageUrl;
        _genreController.text = game.genre;
        _platformController.text = game.platform;
        _yearController.text = game.releaseYear.toString();
        _ratingController.text = game.rating.toString();
        _developerController.text = game.developer;
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose;
    _descriptionController.dispose;
    _imageUrlController.dispose;
    _genreController.dispose;
    _platformController.dispose;
    _yearController.dispose;
    _ratingController.dispose;
    _developerController.dispose;
    super.dispose();
  }

  void _saveGame() {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final imageUrl = _imageUrlController.text.trim();
    final genre = _genreController.text.trim();
    final platform = _platformController.text.trim();
    final releaseYear = int.parse(_yearController.text.trim());
    final rating = double.parse(_ratingController.text.trim());
    final developer = _developerController.text.trim();

    if (isEditing) {
      final updatedGame = GameModel(
        id: widget.gameId!,
        title: title,
        description: description,
        imageUrl: imageUrl,
        genre: genre,
        platform: platform,
        releaseYear: releaseYear,
        rating: rating,
        developer: developer,
      );

      ref.read(gamesProvider.notifier).updateGame(updatedGame);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Videojuego actualizado con exito.'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } else {
      final newGame = GameModel(
        id: 'game_',
        title: title,
        description: description,
        imageUrl: imageUrl,
        genre: genre,
        platform: platform,
        releaseYear: releaseYear,
        rating: rating,
        developer: developer,
      );

      ref.read(gamesProvider.notifier).addGame(newGame);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Videojuego agregado con exito al catalogo.'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleText = isEditing ? 'Editar Videojuego' : 'Nuevo Videojuego';

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Titulo
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Titulo del videojuego *',
                  hintText: 'Ej. The Witcher 3: Wild Hunt',
                  prefixIcon: Icon(Icons.videogame_asset_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El titulo es obligatorio';
                  }
                  if (value.trim().length < 2) {
                    return 'El titulo debe tener al menos 2 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Genero y Plataforma en dos columnas o seguidos
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _genreController,
                      decoration: const InputDecoration(
                        labelText: 'Genero *',
                        hintText: 'Ej. RPG, Accion',
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Obligatorio';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _platformController,
                      decoration: const InputDecoration(
                        labelText: 'Plataforma *',
                        hintText: 'Ej. PC, PS5, Xbox',
                        prefixIcon: Icon(Icons.devices_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Obligatorio';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Desarrollador
              TextFormField(
                controller: _developerController,
                decoration: const InputDecoration(
                  labelText: 'Estudio / Desarrollador *',
                  hintText: 'Ej. CD Projekt Red, FromSoftware',
                  prefixIcon: Icon(Icons.business_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El desarrollador es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Anio y Rating
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _yearController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Ano de Lanzamiento *',
                        hintText: 'Ej. 2023',
                        prefixIcon: Icon(Icons.calendar_today_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Obligatorio';
                        }
                        final year = int.tryParse(value.trim());
                        if (year == null || year < 1950 || year > 2035) {
                          return 'Ano no valido (1950-2035)';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _ratingController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Puntuacion (0 - 10) *',
                        hintText: 'Ej. 9.5',
                        prefixIcon: Icon(Icons.star_outline_rounded),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Obligatorio';
                        }
                        final rating = double.tryParse(value.trim());
                        if (rating == null || rating < 0.0 || rating > 10.0) {
                          return '0.0 a 10.0';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // URL Imagen
              TextFormField(
                controller: _imageUrlController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'URL de la imagen de portada *',
                  hintText: 'https://...',
                  prefixIcon: Icon(Icons.image_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La URL de la imagen es obligatoria';
                  }
                  final uri = Uri.tryParse(value.trim());
                  if (uri == null || !uri.hasScheme) {
                    return 'Ingresa una URL valida (http o https)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Descripcion
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descripcion detallada *',
                  hintText: 'Escribe la sinopsis o descripcion del videojuego...',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La descripcion es obligatoria';
                  }
                  if (value.trim().length < 10) {
                    return 'Debe tener al menos 10 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),

              // Boton Guardar
              ElevatedButton.icon(
                onPressed: _saveGame,
                icon: Icon(isEditing ? Icons.save_rounded : Icons.add_rounded),
                label: Text(
                  isEditing ? 'Guardar Cambios' : 'Crear Videojuego',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
