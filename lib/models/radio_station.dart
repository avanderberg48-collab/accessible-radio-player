class RadioStation {
  final String id;
  final String name;
  final String url;
  final bool isFavorite;

  RadioStation({
    required this.id,
    required this.name,
    required this.url,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'isFavorite': isFavorite,
    };
  }

  factory RadioStation.fromJson(Map<String, dynamic> json) {
    return RadioStation(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  RadioStation copyWith({
    String? id,
    String? name,
    String? url,
    bool? isFavorite,
  }) {
    return RadioStation(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
