import 'package:app/src/domain/models/Modifier.dart';

class SelectedModifier {
  final int? id;
  final Modifier? modifier;

  SelectedModifier({
    this.id,
    this.modifier,
  });

  factory SelectedModifier.fromJson(Map<String, dynamic> json) {
    return SelectedModifier(
      id: json['id'],
      modifier:
          json['modifier'] != null ? Modifier.fromJson(json['modifier']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    if (modifier != null) {
      data['modifier'] = modifier!.toJson();
    }
    return data;
  }
}
