// /lib/widgets/character/combat_section.dart

import 'package:material_ui/material_ui.dart';

import 'combat_stat_card.dart';
import 'section_title.dart';

class CombatSection extends StatelessWidget {
  const CombatSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'COMBAT', subtitle: 'Combat statistics'),
        const SizedBox(height: 16),
        Row(
          children: const [
            Expanded(child: CombatStatCard(title: 'HEALTH')),
            SizedBox(width: 10),
            Expanded(child: CombatStatCard(title: 'DEFENSE')),
            SizedBox(width: 10),
            Expanded(child: CombatStatCard(title: 'ARMOR')),
          ],
        ),
      ],
    );
  }
}
