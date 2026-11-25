// lib/screens/skin_selection_screen.dart

import 'package:material_ui/material_ui.dart';

import '../models/dice_set_skin.dart';

class SkinSelectionScreen extends StatefulWidget {
  final DiceSetSkin selectedSkinSet;

  const SkinSelectionScreen({super.key, required this.selectedSkinSet});

  @override
  State<SkinSelectionScreen> createState() => _SkinSelectionScreenState();
}

class _SkinSelectionScreenState extends State<SkinSelectionScreen> {
  late DiceSetSkin _selectedSkinSet;

  final List<DiceSetSkin> _skinSets = [
    DiceSetSkin.classic,
    DiceSetSkin.dragon,
    DiceSetSkin.symbol,
  ];

  @override
  void initState() {
    super.initState();
    _selectedSkinSet = widget.selectedSkinSet;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181818),
        foregroundColor: Colors.white,
        title: const Text('DICE SKINS'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: _skinSets.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final skinSet = _skinSets[index];
                    final isSelected = skinSet.id == _selectedSkinSet.id;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSkinSet = skinSet;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF292929),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFF5F2EA)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  skinSet.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Color(0xFFF5F2EA),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                skinSet.diceSkins.length,
                                (diceIndex) {
                                  final skin = skinSet.diceSkins[diceIndex];

                                  return Container(
                                    width: 55,
                                    height: 55,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: skin.faceColor,
                                      borderRadius: BorderRadius.circular(
                                        skin.cornerRadius,
                                      ),
                                      border: Border.all(
                                        color: skin.edgeColor,
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: skin.oneFaceImage != null
                                          ? Image.asset(
                                              skin.oneFaceImage!,
                                              width: 30,
                                              height: 30,
                                              fit: BoxFit.contain,
                                            )
                                          : Icon(
                                              Icons.casino,
                                              color: skin.pipColor,
                                              size: 30,
                                            ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, _selectedSkinSet);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5F2EA),
                    foregroundColor: const Color(0xFF181818),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'APPLY',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
