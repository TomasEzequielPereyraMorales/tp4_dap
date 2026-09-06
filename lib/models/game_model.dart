class GameModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String genre;
  final String platform;
  final int releaseYear;
  final double rating;
  final String developer;

  const GameModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.genre,
    required this.platform,
    required this.releaseYear,
    required this.rating,
    required this.developer,
  });

  GameModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? genre,
    String? platform,
    int? releaseYear,
    double? rating,
    String? developer,
  }) {
    return GameModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      genre: genre ?? this.genre,
      platform: platform ?? this.platform,
      releaseYear: releaseYear ?? this.releaseYear,
      rating: rating ?? this.rating,
      developer: developer ?? this.developer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'genre': genre,
      'platform': platform,
      'releaseYear': releaseYear,
      'rating': rating,
      'developer': developer,
    };
  }

  factory GameModel.fromMap(Map<String, dynamic> map) {
    return GameModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      genre: map['genre'] ?? '',
      platform: map['platform'] ?? '',
      releaseYear: map['releaseYear']?.toInt() ?? 2000,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      developer: map['developer'] ?? '',
    );
  }
}
