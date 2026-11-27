//lib/widgets/character/character_info/expandable_character_field.dart

import 'package:material_ui/material_ui.dart';

import 'character_field.dart';

class ExpandableCharacterField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool initiallyExpanded;

  const ExpandableCharacterField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.initiallyExpanded = true,
  });

  @override
  State<ExpandableCharacterField> createState() =>
      _ExpandableCharacterFieldState();
}

class _ExpandableCharacterFieldState extends State<ExpandableCharacterField> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 10,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              icon: Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.white54,
              ),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        if (_isExpanded) ...[
          const SizedBox(height: 8),
          CharacterField(
            label: '',
            controller: widget.controller,
            hint: widget.hint,
            keyboardType: widget.keyboardType,
          ),
        ],
      ],
    );
  }
}
