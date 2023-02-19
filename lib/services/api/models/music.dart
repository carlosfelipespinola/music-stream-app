class Music {
  final String name;
  final String description;
  final String genre;
  final String audioUrl;
  final String imageUrl;

  Music(
      {required this.name,
      required this.description,
      required this.genre,
      required this.audioUrl,
      required this.imageUrl});

  factory Music.fromJson(Map<dynamic, dynamic> map, String hostUrl) {
    return Music(
        name: map['name'],
        description: map['description'],
        genre: map['genre'],
        audioUrl: "$hostUrl/${map['audioFileName']}",
        imageUrl: "$hostUrl/${map['photoFileName']}");
  }
}
