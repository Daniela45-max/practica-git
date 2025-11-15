class Note {
  String id;
  String title;
  String body;
  DateTime updated;

  Note({
    required this.id,
    required this.title,
    required this.body,
    required this.updated,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'updated': updated.toIso8601String(),
      };

  factory Note.fromJson(Map data) {
    return Note(
      id: data['id'] as String,
      title: data['title'] as String,
      body: data['body'] as String,
      updated: DateTime.parse(data['updated'] as String),
    );
  }
}
