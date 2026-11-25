// lib/widgets/dice/dice_group.dart

import 'package:material_ui/material_ui.dart';

import '../../models/dice_set_skin.dart';
import '../../models/dice_skin.dart';
import '../../services/dice_service.dart';
import 'dice_3d.dart';

class DiceGroup extends StatefulWidget {
  final int diceCount;
  final DiceSetSkin skinSet;
  final ValueChanged<List<int?>>? onResultsChanged;
  final ValueChanged<bool>? onRollingChanged;

  const DiceGroup({
    super.key,
    this.diceCount = 3,
    this.skinSet = DiceSetSkin.classic,
    this.onResultsChanged,
    this.onRollingChanged,
  }) : assert(diceCount > 0);

  @override
  State<DiceGroup> createState() => DiceGroupState();
}

class DiceGroupState extends State<DiceGroup> {
  late List<GlobalKey<Dice3DState>> _diceKeys;
  late List<int?> _results;

  final DiceService _diceService = DiceService();

  bool _isRolling = false;
  int _activeRolls = 0;

  bool get isRolling => _isRolling;

  List<int?> get results => List.unmodifiable(_results);

  @override
  void initState() {
    super.initState();
    _initializeDice();
  }

  void _initializeDice() {
    _diceKeys = List.generate(
      widget.diceCount,
      (_) => GlobalKey<Dice3DState>(),
    );

    _results = List.filled(widget.diceCount, null);
  }

  @override
  void didUpdateWidget(covariant DiceGroup oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.diceCount != widget.diceCount) {
      _initializeDice();
    }
  }

  bool _canRoll() => !_isRolling;

  void _startRoll(List<int> indices) {
    if (!_canRoll()) {
      debugPrint('[DiceGroup] ROLL BLOCKED: animation in progress');
      return;
    }

    setState(() {
      _isRolling = true;
      _activeRolls = indices.length;

      for (final index in indices) {
        _results[index] = null;
      }
    });

    debugPrint(
      '[DiceGroup] ROLLS LOCKED: dice ${indices.map((i) => i + 1).join(', ')}',
    );

    widget.onRollingChanged?.call(true);
    widget.onResultsChanged?.call(results);

    for (final index in indices) {
      _diceKeys[index].currentState?.roll();
    }
  }

  void rollAll() {
    _startRoll(List.generate(widget.diceCount, (index) => index));
  }

  void rollSingle(int index) {
    if (index < 0 || index >= widget.diceCount) return;

    _startRoll([index]);
  }

  void _onRollComplete(int index, int result) {
    if (!mounted) return;

    setState(() {
      _results[index] = result;
      _activeRolls--;

      if (_activeRolls == 0) {
        _isRolling = false;
      }
    });

    debugPrint('[DiceGroup] Dice ${index + 1} completed: $result');

    widget.onResultsChanged?.call(results);

    if (!_isRolling) {
      debugPrint('[DiceGroup] ROLLS UNLOCKED: all dice completed');

      widget.onRollingChanged?.call(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth = constraints.maxWidth / widget.diceCount;

        final availableHeight = constraints.maxHeight;

        final diceSize = (cellWidth / 1.6)
            .clamp(30.0, 150.0)
            .toDouble()
            .clamp(0.0, availableHeight)
            .toDouble();

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.diceCount, (index) {
            final diceSkin = index < widget.skinSet.diceSkins.length
                ? widget.skinSet.diceSkins[index]
                : DiceSkin.classic;

            return SizedBox(
              width: cellWidth,
              child: GestureDetector(
                onTap: _isRolling ? null : () => rollSingle(index),
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
            );
          }),
        );
      },
    );
  }
}
