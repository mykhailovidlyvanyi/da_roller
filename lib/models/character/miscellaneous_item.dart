//lib/models/character/miscellaneous_item.dart

import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class MiscellaneousItem {
  final String id;
  final String name;
  final int quantity;
  final int? cost;
  final String details;

  MiscellaneousItem({
    String? id,
    required this.name,
    this.quantity = 1,
    this.cost,
    this.details = '',
  }) : id = id ?? _uuid.v4();
}
