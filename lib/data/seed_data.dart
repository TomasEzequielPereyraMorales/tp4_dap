import '../models/game_model.dart';
import '../models/user_model.dart';

final List<UserModel> initialUsers = [];

final List<GameModel> initialGames = [
  const GameModel(
    id: 'game_1',
    title: 'The Witcher 3: Wild Hunt',
    description:
        'Geralt de Rivia es un cazador de monstruos a sueldo que recorre un mundo devastado por la guerra en busca de Ciri, la nina de la profecia. Combate dinamicamente, toma decisiones morales y explora vastos reinos.',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSGsklQtbsmk4o6whFb4ZRRzVolY8NVRTGMdtO-qtq0NIW14rSJpxEI728y&s=10',
    genre: 'Accion / RPG',
    platform: 'PC, PS5, Xbox Series, Switch',
    releaseYear: 2015,
    rating: 9.8,
    developer: 'CD Projekt Red',
  ),
  const GameModel(
    id: 'game_2',
    title: 'Elden Ring',
    description:
        'Alzate, Tiznado, y dejate guiar por la gracia para esgrimir el poder del Anillo de Elden y convertirte en el Senor del Circulo en las Tierras Intermedias. Un colosal mundo abierto lleno de secretos y temibles jefes.',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPRtwQm_vlfyh31EPftGqEbctZLQchQ8BBjK2FRSo8XgllFqLR5UpWcoM&s=10',
    genre: 'Accion RPG / Souls-like',
    platform: 'PC, PS4, PS5, Xbox One, Xbox Series',
    releaseYear: 2022,
    rating: 9.7,
    developer: 'FromSoftware',
  ),
  const GameModel(
    id: 'game_3',
    title: 'The Legend of Zelda: Tears of the Kingdom',
    description:
        'Una aventura sin limites en la que crearas tus propios artefactos y vehiculos para surcar los cielos y las profundidades del reino de Hyrule, enfrentando una nueva amenaza cataclismica.',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRb7vIT2RTLsoEz6YheDWo-Lb73f1UbTFhY6xiOKbljWpSDPX-Oj92o5rnV&s=10',
    genre: 'Aventura / Accion',
    platform: 'Nintendo Switch',
    releaseYear: 2023,
    rating: 9.6,
    developer: 'Nintendo EPD',
  ),
  const GameModel(
    id: 'game_4',
    title: 'Cyberpunk 2077',
    description:
        'Una historia de accion y aventura en el mundo abierto de Night City, una megalopolis obsesionada con el poder, el glamour y la modificacion corporal. Juega como V tras un implante que concede la inmortalidad.',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR0GpkVbd_p8GyTYHwRXy1eFg77ikDvwe7_3dLBsgg-Gm5-DJvwYJzNTSJg&s=10',
    genre: 'RPG / Cyberpunk',
    platform: 'PC, PS5, Xbox Series X/S',
    releaseYear: 2020,
    rating: 8.9,
    developer: 'CD Projekt Red',
  ),
  const GameModel(
    id: 'game_5',
    title: 'Hollow Knight',
    description:
        'Desciende al reino en ruinas de Hallownest, combate criaturas corrompidas y haz amistad con extranos insectos en este desafiante y bello juego de accion y exploracion 2D dibujado a mano.',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSFo_hdPRyfqGkLoR4yH1cv4Gfhh49dK4TZeHXTHplTRhsVvd7prRFSLs&s=10',
    genre: 'Metroidvania / Plataformas',
    platform: 'PC, Switch, PS4, Xbox One',
    releaseYear: 2017,
    rating: 9.5,
    developer: 'Team Cherry',
  ),
  const GameModel(
    id: 'game_6',
    title: 'Red Dead Redemption 2',
    description:
        'America, 1899. El ocaso del salvaje oeste ha comenzado. Tras un atraco fallido, Arthur Morgan y la banda de Van der Linde deben huir, asaltando y sobreviviendo en el despiadado corazon de Norteamerica.',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTf1Zfn85_0RLccd3xscDzJEQtqHT2mLauMlkorFdEuUsNDP3Vtdo7En657&s=10',
    genre: 'Mundo Abierto / Accion',
    platform: 'PC, PS4, Xbox One',
    releaseYear: 2018,
    rating: 9.9,
    developer: 'Rockstar Games',
  ),
];
