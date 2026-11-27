//lib/screens/dice_screen.dart

import 'package:material_ui/material_ui.dart';

import '../models/dice_set_skin.dart';
import '../widgets/dice/dice_group.dart';
import '../widgets/dice/dice_panel.dart';
import '../widgets/character/character_sheet.dart';

import 'skin_selection_screen.dart';

class DiceScreen extends StatefulWidget {
  const DiceScreen({super.key});

  @override
  State<DiceScreen> createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> {
  final _diceGroupKey = GlobalKey<DiceGroupState>();

  List<int?> _results = [null, null, null];
  bool _isRolling = false;
  bool _isAttackRoll = false;

  int _diceCount = 3;
  int? _selectedModifier;
  String _modifierLabel = 'Attribute';

  DiceSetSkin _selectedSkinSet = DiceSetSkin.classic;

  void _onResultsChanged(List<int?> results) {
    setState(() {
      _results = List.of(results);
    });
  }

  void _onRollingChanged(bool isRolling) {
    setState(() {
      _isRolling = isRolling;
    });
  }

  void _startRoll({
    required int diceCount,
    required int modifier,
    required String modifierLabel,
    required bool isAttackRoll,
  }) {
    if (_isRolling || diceCount <= 0) return;

    setState(() {
      _diceCount = diceCount;
      _selectedModifier = modifier;
      _modifierLabel = modifierLabel;
      _isAttackRoll = isAttackRoll;
      _results = List.filled(diceCount < 3 ? 3 : diceCount, null);
      _isRolling = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _diceGroupKey.currentState?.rollAll();
    });
  }

  // Attribute roll: 3d6 + attribute value.
  void _rollDice(int? attributeValue) {
    _startRoll(
      diceCount: 3,
      modifier: attributeValue ?? 0,
      modifierLabel: 'Attribute',
      isAttackRoll: false,
    );
  }

  // Custom roll: used by weapon attacks and damage.
  void _rollCustomDice(
    int diceCount,
    int modifier,
    String modifierLabel,
    bool isAttackRoll,
  ) {
    _startRoll(
      diceCount: diceCount,
      modifier: modifier,
      modifierLabel: modifierLabel,
      isAttackRoll: isAttackRoll,
    );
  }

  // Roll all three dice from the dice panel.
  void _rollAllThreeDice() {
    if (_isRolling) return;
    _isAttackRoll = false;

    setState(() {
      _diceCount = 3;
      _selectedModifier = null;
      _modifierLabel = '';
      _results = [null, null, null];
      _isRolling = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _diceGroupKey.currentState?.rollAll();
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
            Positioned.fill(
              child: CharacterSheet(
                onRollDice: _rollDice,
                onRollCustomDice: _rollCustomDice,
              ),
            ),
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
                onRollAll: _rollAllThreeDice,
                isAttackRoll: _isAttackRoll,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
