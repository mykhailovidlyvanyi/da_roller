//lib/models/ammunition/ammunition_stack.dart

import 'package:uuid/uuid.dart';

import 'ammunition.dart';

const _uuid = Uuid();

class AmmunitionStack {
  final String id;
  final Ammunition ammunition;
  final int quantity;

  AmmunitionStack({
    String? id,
    required this.ammunition,
    required this.quantity,
  }) : id = id ?? _uuid.v4();
}
