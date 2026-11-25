// /lib/widgets/character/attributes_section.dart

import 'package:material_ui/material_ui.dart';

import 'attribute_card.dart';
import 'section_title.dart';

class AttributesSection extends StatelessWidget {
  final ValueChanged<int?> onRollDice;

  const AttributesSection({super.key, required this.onRollDice});

  @override
  Widget build(BuildContext context) {
    final attributes = [
      'COMMUNICATION',
      'CONSTITUTION',
      'CUNNING',
      'DEXTERITY',
      'MAGIC',
      'PERCEPTION',
      'STRENGTH',
      'WILLPOWER',
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 0, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'ATTRIBUTES',
            subtitle: 'Character abilities',
          ),

          const SizedBox(height: 16),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 180),
              itemCount: attributes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final name = attributes[index];

                return SizedBox(
                  height: 90,
                  child: AttributeCard(name: name, onRollDice: onRollDice),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
