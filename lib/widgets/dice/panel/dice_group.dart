//lib/widgets/dice/panel/dice_group.dart

import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../../models/dice/dice_roll.dart';
import '../../../models/dice/dice_set_skin.dart';
import '../../../models/dice/dice_skin.dart';

import '../../../services/dice_service.dart';

import '../rendering/dice_3d.dart';

class DiceGroup extends StatefulWidget {
  final int diceCount;
  final DiceSetSkin skinSet;
  final ValueChanged<List<int?>>? onResultsChanged;
  final ValueChanged<bool>? onRollingChanged;
  final ValueChanged<int>? onSingleRollRequested;

  const DiceGroup({
    super.key,
    this.diceCount = 3,
    this.skinSet = DiceSetSkin.classic,
    this.onResultsChanged,
    this.onRollingChanged,
    this.onSingleRollRequested,
  }) : assert(diceCount > 0);

  @override
  State<DiceGroup> createState() => DiceGroupState();
}

class DiceGroupState extends State<DiceGroup> {
  static const int _minimumDiceCount = 3;

  final DiceService _diceService = DiceService();

  late List<GlobalKey<Dice3DState>> _diceKeys;
  late List<int?> _results;

  bool _isRolling = false;
  int _activeRolls = 0;

  int? _selectedSingleDieIndex;

  List<int> _activeIndices = [];
  Completer<List<int>>? _rollCompleter;

  bool get isRolling => _isRolling;

  List<int?> get results => List.unmodifiable(_results);

  int get _displayDiceCount => widget.diceCount > _minimumDiceCount
      ? widget.diceCount
      : _minimumDiceCount;

  @override
  void initState() {
    super.initState();
    _initializeDice();
  }

  void _initializeDice() {
    final count = _displayDiceCount;

    _diceKeys = List.generate(count, (_) => GlobalKey<Dice3DState>());

    _results = List.filled(count, null);
  }

  @override
  void didUpdateWidget(covariant DiceGroup oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.diceCount != widget.diceCount) {
      final requiredCount = _displayDiceCount;

      if (requiredCount != _diceKeys.length) {
        _initializeDice();
      } else {
        _results = List.filled(requiredCount, null);
      }

      _selectedSingleDieIndex = null;
    }
  }

  /// Universal method for executing any dice roll.
  Future<List<int>> roll(DiceRoll roll) {
    if (_isRolling) {
      return Future.error(StateError('A dice roll is already in progress.'));
    }

    final indices = _getDiceIndices(roll);

    if (indices.isEmpty ||
        indices.length != roll.diceCount ||
        indices.any((index) => index < 0 || index >= _diceKeys.length)) {
      return Future.error(
        ArgumentError('Invalid dice selection for this roll.'),
      );
    }

    final diceStates = indices
        .map((index) => _diceKeys[index].currentState)
        .toList();

    if (diceStates.any((state) => state == null)) {
      return Future.error(StateError('One or more dice are not mounted.'));
    }

    final completer = Completer<List<int>>();

    setState(() {
      _isRolling = true;
      _activeRolls = indices.length;
      _activeIndices = List.of(indices);
      _rollCompleter = completer;

      _selectedSingleDieIndex = roll.type == DiceRollType.single
          ? roll.targetDieIndex
          : null;

      _results = List.filled(_diceKeys.length, null);
    });

    widget.onRollingChanged?.call(true);
    widget.onResultsChanged?.call(results);

    for (final diceState in diceStates) {
      diceState!.roll();
    }

    return completer.future;
  }

  List<int> _getDiceIndices(DiceRoll roll) {
    switch (roll.type) {
      case DiceRollType.single:
        return [roll.targetDieIndex!];

      case DiceRollType.attribute:
      case DiceRollType.attack:
      case DiceRollType.damage:
      case DiceRollType.panel:
        return List.generate(roll.diceCount, (index) => index);
    }
  }

  void _onRollComplete(int index, int result) {
    if (!mounted || !_isRolling || !_activeIndices.contains(index)) {
      return;
    }

    setState(() {
      _results[index] = result;
      _activeRolls--;
    });

    widget.onResultsChanged?.call(results);

    if (_activeRolls == 0) {
      final rollResults = _activeIndices
          .map((diceIndex) => _results[diceIndex]!)
          .toList();

      final completer = _rollCompleter;

      setState(() {
        _isRolling = false;
        _activeIndices = [];
        _rollCompleter = null;
      });

      widget.onRollingChanged?.call(false);

      if (completer != null && !completer.isCompleted) {
        completer.complete(rollResults);
      }
    }
  }

  void _onDieTapped(int index) {
    if (_isRolling) return;

    widget.onSingleRollRequested?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth = constraints.maxWidth / _displayDiceCount;

        final diceSize = (cellWidth / 1.6)
            .clamp(30.0, 150.0)
            .toDouble()
            .clamp(0.0, constraints.maxHeight)
            .toDouble();

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_displayDiceCount, (index) {
            final diceSkin = index < widget.skinSet.diceSkins.length
                ? widget.skinSet.diceSkins[index]
                : DiceSkin.classic;

            final isInactive = _selectedSingleDieIndex != null
                ? index != _selectedSingleDieIndex
                : index >= widget.diceCount;

            // During Single mode, all three panel dice remain selectable.
            final canSelect = index < _minimumDiceCount;

            return SizedBox(
              width: cellWidth,
              child: GestureDetector(
                onTap: _isRolling || !canSelect
                    ? null
                    : () => _onDieTapped(index),
                child: Opacity(
                  opacity: isInactive ? 0.45 : 1,
                  child: Dice3D(
                    key: _diceKeys[index],
                    size: diceSize,
                    skin: diceSkin,
                    diceService: _diceService,
                    onRollComplete: (result) {
                      _onRollComplete(index, result);
                    },
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
