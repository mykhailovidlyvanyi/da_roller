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

  int? _selectedAttributeValue;

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

  // Roll all three dice
  void _rollDice(int? attributeValue) {
    if (_isRolling) return;

    setState(() {
      _selectedAttributeValue = attributeValue;
    });

    _diceGroupKey.currentState?.rollAll();
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
        _results = [null, null, null];
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
            // Main content: two columns
            Positioned.fill(child: CharacterSheet(onRollDice: _rollDice)),

            // Dice panel: floating above both columns
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: DicePanel(
                diceGroupKey: _diceGroupKey,
                results: _results,
                isRolling: _isRolling,
                selectedSkinSet: _selectedSkinSet,
                attributeValue: _selectedAttributeValue,
                onResultsChanged: _onResultsChanged,
                onRollingChanged: _onRollingChanged,
                onOpenSkinSelection: _openSkinSelection,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
