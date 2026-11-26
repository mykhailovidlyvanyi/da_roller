//lib/widgets/character/combat_stat_card_test.dart

import 'package:material_ui/material_ui.dart';

class CombatStatCard extends StatefulWidget {
  final String title;
  final int? value;
  final ValueChanged<int>? onValueChanged;
  final bool isEditable;
  final bool isAlwaysEditing;

  final bool isToggle;
  final bool toggleValue;
  final ValueChanged<bool>? onToggleChanged;

  const CombatStatCard({
    super.key,
    required this.title,
    this.value,
    this.onValueChanged,
    this.isEditable = true,
    this.isAlwaysEditing = false,
    this.isToggle = false,
    this.toggleValue = false,
    this.onToggleChanged,
  });

  @override
  State<CombatStatCard> createState() => _CombatStatCardState();
}

class _CombatStatCardState extends State<CombatStatCard> {
  final _valueController = TextEditingController();

  bool _isEditing = false;

  bool get _showTextField => _isEditing || widget.isAlwaysEditing;

  @override
  void initState() {
    super.initState();
    _valueController.text = widget.value?.toString() ?? '';
  }

  @override
  void didUpdateWidget(covariant CombatStatCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAlwaysEditing && oldWidget.value != widget.value) {
      final newValue = widget.value?.toString() ?? '';

      if (_valueController.text != newValue) {
        _valueController.value = TextEditingValue(
          text: newValue,
          selection: TextSelection.collapsed(offset: newValue.length),
        );
      }
    }
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  void _startEditing() {
    if (!widget.isEditable ||
        widget.isToggle ||
        widget.isAlwaysEditing ||
        _isEditing) {
      return;
    }

    _valueController.text = widget.value?.toString() ?? '';

    setState(() {
      _isEditing = true;
    });
  }

  void _saveValue() {
    final value = int.tryParse(_valueController.text.trim());

    if (value == null) return;

    widget.onValueChanged?.call(value);

    setState(() {
      _isEditing = false;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
    });
  }

  void _onAlwaysEditingChanged(String text) {
    final value = int.tryParse(text.trim());

    if (value != null) {
      widget.onValueChanged?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF383838)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 9,
                letterSpacing: 0.6,
              ),
            ),
          ),

          if (widget.isToggle)
            Switch(value: widget.toggleValue, onChanged: widget.onToggleChanged)
          else
            SizedBox(
              width: 52,
              child: _showTextField
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 24,
                          child: TextField(
                            controller: _valueController,
                            autofocus: widget.isAlwaysEditing,
                            keyboardType: const TextInputType.numberWithOptions(
                              signed: true,
                            ),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                            onChanged: widget.isAlwaysEditing
                                ? _onAlwaysEditingChanged
                                : null,
                            onSubmitted: widget.isAlwaysEditing
                                ? null
                                : (_) => _saveValue(),
                          ),
                        ),
                        if (!widget.isAlwaysEditing)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: _saveValue,
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.greenAccent,
                                  size: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: _cancelEditing,
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white54,
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                      ],
                    )
                  : Text(
                      widget.value?.toString() ?? '-',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
        ],
      ),
    );

    if (widget.isToggle || widget.isAlwaysEditing) {
      return card;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onDoubleTap: _startEditing,
      child: card,
    );
  }
}
