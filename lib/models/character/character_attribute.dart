//lib/models/character/character_attribute.dart

class CharacterAttribute {
  final String name;
  final int value;
  final String focus;

  const CharacterAttribute({
    required this.name,
    this.value = 0,
    this.focus = '',
  });

  CharacterAttribute copyWith({String? name, int? value, String? focus}) {
    return CharacterAttribute(
      name: name ?? this.name,
      value: value ?? this.value,
      focus: focus ?? this.focus,
    );
  }
}
