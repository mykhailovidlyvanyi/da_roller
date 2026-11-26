//lib/widgets/character/attributes_section.dart

import 'package:material_ui/material_ui.dart';

import '../../models/character_attribute.dart';
import 'attribute_card.dart';
import 'section_title.dart';

class AttributesSection extends StatefulWidget {
  final ValueChanged<int?> onRollDice;

  const AttributesSection({super.key, required this.onRollDice});

  @override
  State<AttributesSection> createState() => _AttributesSectionState();
}

class _AttributesSectionState extends State<AttributesSection> {
  late final List<CharacterAttribute> _attributes;

  @override
  void initState() {
    super.initState();

    _attributes = [
      'COMMUNICATION',
      'CONSTITUTION',
      'CUNNING',
      'DEXTERITY',
      'MAGIC',
      'PERCEPTION',
      'STRENGTH',
      'WILLPOWER',
    ].map((name) => CharacterAttribute(name: name)).toList();
  }

  void _updateAttribute(int index, CharacterAttribute updatedAttribute) {
    setState(() {
      _attributes[index] = updatedAttribute;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              itemCount: _attributes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final attribute = _attributes[index];

                return SizedBox(
                  height: 90,
                  child: AttributeCard(
                    key: ValueKey(attribute.name),
                    attribute: attribute,
                    onChanged: (updatedAttribute) {
                      _updateAttribute(index, updatedAttribute);
                    },
                    onRollDice: widget.onRollDice,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
