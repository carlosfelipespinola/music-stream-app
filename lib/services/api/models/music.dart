class Music {
  final String name;
  final String audioUrl;
  final String imageUrl;

  Music({required this.name, required this.audioUrl, required this.imageUrl});

  factory Music.fromJson(Map<String, dynamic> map) {
    return Music(name: "a", audioUrl: "b", imageUrl: "c");
  }
}
