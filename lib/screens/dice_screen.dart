//lib/screens/dice_screen.dart

import 'package:material_ui/material_ui.dart';

import '../models/dice/dice_roll.dart';
import '../models/dice/dice_set_skin.dart';

import '../services/dice_roll_service.dart';

import '../widgets/dice/panel/dice_group.dart';
import '../widgets/dice/panel/dice_panel.dart';

import '../widgets/dice/stunts/dice_stunts.dart';

import '../widgets/effects/confetti_overlay.dart';

import '../widgets/character/character_controller.dart';

import 'skin_selection_screen.dart';

class DiceScreen extends StatefulWidget {
  const DiceScreen({super.key});

  @override
  State<DiceScreen> createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> {
  final _diceGroupKey = GlobalKey<DiceGroupState>();
  final _diceRollService = DiceRollService();

  List<int?> _results = [null, null, null];

  bool _isRolling = false;
  bool _showConfetti = false;

  int _stuntCount = 0;

  int _diceCount = 3;
  int? _selectedModifier;
  String _modifierLabel = '';

  int? _selectedSingleDieIndex;

  DiceRoll? _currentRoll;

  DiceSetSkin _selectedSkinSet = DiceSetSkin.classic;

  bool get _isAttackRoll => _currentRoll?.type == DiceRollType.attack;

  Future<void> _executeRoll(DiceRoll roll) async {
    if (_isRolling) return;

    setState(() {
      _currentRoll = roll;
      _diceCount = roll.diceCount;

      _selectedModifier = roll.modifierLabel == null ? null : roll.modifier;

      _modifierLabel = roll.modifierLabel ?? '';

      _selectedSingleDieIndex = roll.type == DiceRollType.single
          ? roll.targetDieIndex
          : null;

      _results = List.filled(roll.diceCount < 3 ? 3 : roll.diceCount, null);

      _isRolling = true;
      _showConfetti = false;
    });

    try {
      // Wait until DiceGroup is rebuilt with the new diceCount.
      await WidgetsBinding.instance.endOfFrame;

      if (!mounted) return;

      final diceGroup = _diceGroupKey.currentState;

      if (diceGroup == null) {
        throw StateError('DiceGroup is not mounted.');
      }

      final diceResults = await diceGroup.roll(roll);

      if (!mounted) return;

      final result = _diceRollService.createResult(
        roll: roll,
        diceResults: diceResults,
      );

      setState(() {
        if (roll.type == DiceRollType.attack && hasStunts(result.diceResults)) {
          _stuntCount = result.diceResults[2];
          _showConfetti = true;
        }
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _isRolling = false;
        });
      }

      rethrow;
    }
  }

  void _onResultsChanged(List<int?> results) {
    if (!mounted) return;

    setState(() {
      _results = List.of(results);
    });
  }

  void _onRollingChanged(bool isRolling) {
    if (!mounted) return;

    setState(() {
      _isRolling = isRolling;
    });
  }

  void _onConfettiComplete() {
    if (!mounted) return;

    setState(() {
      _showConfetti = false;
    });
  }

  Future<void> _openSkinSelection() async {
    if (_isRolling) return;

    final selectedSkinSet = await Navigator.push<DiceSetSkin>(
      context,
      MaterialPageRoute(
        builder: (_) => SkinSelectionScreen(selectedSkinSet: _selectedSkinSet),
      ),
    );

    if (!mounted || selectedSkinSet == null) return;

    if (selectedSkinSet.id != _selectedSkinSet.id) {
      setState(() {
        _selectedSkinSet = selectedSkinSet;
        _results = List.filled(_diceCount < 3 ? 3 : _diceCount, null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF181818);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Character sheet
            Positioned.fill(child: CharacterController(onRoll: _executeRoll)),

            // Dark overlay
            if (_showConfetti)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(color: Colors.black.withValues(alpha: 0.6)),
                ),
              ),

            // Confetti animation
            if (_showConfetti)
              Positioned.fill(
                child: ConfettiOverlay(
                  stuntCount: _stuntCount,
                  onComplete: _onConfettiComplete,
                ),
              ),

            // Dice panel
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: DicePanel(
                diceGroupKey: _diceGroupKey,
                results: _results,
                isRolling: _isRolling,
                selectedSkinSet: _selectedSkinSet,
                modifier: _selectedModifier,
                modifierLabel: _modifierLabel,
                diceCount: _diceCount,
                onResultsChanged: _onResultsChanged,
                onRollingChanged: _onRollingChanged,
                onOpenSkinSelection: _openSkinSelection,
                onRollAll: () {
                  _executeRoll(
                    const DiceRoll(type: DiceRollType.panel, diceCount: 3),
                  );
                },
                isAttackRoll: _isAttackRoll,
                onSingleRollRequested: (index) {
                  _executeRoll(
                    DiceRoll(
                      type: DiceRollType.single,
                      diceCount: 1,
                      targetDieIndex: index,
                    ),
                  );
                },
                selectedSingleDieIndex: _selectedSingleDieIndex,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
