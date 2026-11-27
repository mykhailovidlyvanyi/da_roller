//lib/widgets/character/combat/combat_stat_card.dart

import 'package:material_ui/material_ui.dart';

class CombatStatCard extends StatefulWidget {
  final String title;
  final int? value;
  final ValueChanged<int?>? onValueChanged;
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
  final _valueFocusNode = FocusNode();

  bool _isEditing = false;

  bool get _showTextField => _isEditing || widget.isAlwaysEditing;

  @override
  void initState() {
    super.initState();

    _valueController.text = widget.value?.toString() ?? '';
    _valueFocusNode.addListener(_handleFocusChange);
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
    _valueFocusNode.removeListener(_handleFocusChange);
    _valueFocusNode.dispose();
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
    final text = _valueController.text.trim();
    final int? value = text.isEmpty ? null : int.tryParse(text);

    if (text.isNotEmpty && value == null) return;

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

  void _handleFocusChange() {
    if (!_valueFocusNode.hasFocus && widget.isAlwaysEditing) {
      _saveAlwaysEditingValue();
    }
  }

  void _saveAlwaysEditingValue() {
    final text = _valueController.text.trim();
    final int? value = text.isEmpty ? null : int.tryParse(text);

    if (text.isNotEmpty && value == null) {
      _valueController.text = widget.value?.toString() ?? '';
      return;
    }

    widget.onValueChanged?.call(value);
    _valueController.clear();
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
              width: _showTextField && !widget.isAlwaysEditing ? 100 : 52,
              child: _showTextField
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 24,
                          child: TextField(
                            controller: _valueController,
                            focusNode: widget.isAlwaysEditing
                                ? _valueFocusNode
                                : null,
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
                            onSubmitted: widget.isAlwaysEditing
                                ? (_) => _valueFocusNode.unfocus()
                                : (_) => _saveValue(),
                          ),
                        ),
                        if (!widget.isAlwaysEditing)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: _saveValue,
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.greenAccent,
                                  size: 14,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints.tightFor(
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                              IconButton(
                                onPressed: _cancelEditing,
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white54,
                                  size: 14,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints.tightFor(
                                  width: 24,
                                  height: 24,
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
      onTap: _startEditing,
      child: card,
    );
  }
}
