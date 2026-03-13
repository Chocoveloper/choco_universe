class PlutoBackupModel {
  final String name;        // 👈 Nuevo
  final String title;
  final String description; // 👈 Antes era explanation
  final String url;
  final String copyright;

  PlutoBackupModel({
    required this.name,
    required this.title,
    required this.description,
    required this.url,
    required this.copyright,
  });

  factory PlutoBackupModel.fromFirestore(Map<String, dynamic> data) {
    return PlutoBackupModel(
      name: data['name'] ?? 'Plutón',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      url: data['url'] ?? '',
      copyright: data['copyright'] ?? 'NASA / Choco-Universe',
    );
  }
}

