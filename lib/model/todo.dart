import 'package:uuid/uuid.dart';

class Todo {
  Todo({
    this.complete = false,
    String? id,
    required this.note,
    String? description,
  })  : this.description = description ?? '',
        this.id = id ?? Uuid().v4();

  final bool? complete;
  final String? id;
  final String note;
  final String? description;

  factory Todo.fromMap(Map<String, dynamic> json) => Todo(
        complete: json["complete"] == null ? null : json["complete"],
        id: json["id"] == null ? null : json["id"],
        note: json["note"] == null ? null : json["note"],
        description: json["description"] == null ? null : json["description"],
      );

  Map<String, dynamic> toMap() => {
        "complete": complete == null ? null : complete,
        "id": id == null ? null : id,
        "note": note,
        "description": description == null ? null : description,
      };

  Todo copyWith({bool? complete, String? note, String? task}) {
    return Todo(
      id: id,
      description: task ?? this.description,
      complete: complete ?? this.complete,
      note: note ?? this.note,
    );
  }
}
