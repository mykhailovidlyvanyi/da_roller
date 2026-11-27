//lib/widgets/character/attributes/attribute_card.dart

import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../../models/character/character_attribute.dart';

class AttributeCard extends StatefulWidget {
  final CharacterAttribute attribute;
  final ValueChanged<CharacterAttribute> onChanged;
  final ValueChanged<int?> onRollDice;

  const AttributeCard({
    super.key,
    required this.attribute,
    required this.onChanged,
    required this.onRollDice,
  });

  @override
  State<AttributeCard> createState() => _AttributeCardState();
}

class _AttributeCardState extends State<AttributeCard> {
  final _valueController = TextEditingController();

  bool _isValueEditing = false;
  bool _isRolling = false;

  Timer? _rollTimer;

  @override
  void dispose() {
    _rollTimer?.cancel();
    _valueController.dispose();
    super.dispose();
  }

  // Dice roll

  void _rollDice() {
    if (_isValueEditing) return;

    _rollTimer?.cancel();

    setState(() {
      _isRolling = true;
    });

    widget.onRollDice(widget.attribute.value);

    _rollTimer = Timer(const Duration(milliseconds: 450), () {
      if (!mounted) return;

      setState(() {
        _isRolling = false;
      });
    });
  }

  // Attribute value

  void _startValueEditing() {
    if (_isValueEditing) return;

    _valueController.text = widget.attribute.value.toString();

    setState(() {
      _isValueEditing = true;
    });
  }

  void _saveValue() {
    final value = int.tryParse(_valueController.text.trim());

    if (value == null) return;

    widget.onChanged(widget.attribute.copyWith(value: value));

    setState(() {
      _isValueEditing = false;
    });
  }

  void _cancelValueEditing() {
    setState(() {
      _isValueEditing = false;
    });
  }

  // Focus

  Future<void> _editFocus() async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) {
        return FocusEditDialog(initialFocus: widget.attribute.focus);
      },
    );

    if (!mounted) return;

    if (result != null) {
      widget.onChanged(widget.attribute.copyWith(focus: result));
    }
  }

  @override
  Widget build(BuildContext context) {
    final attribute = widget.attribute;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _isRolling ? const Color(0xFF493D24) : const Color(0xFF242424),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _isRolling ? Colors.amberAccent : Colors.white10,
          width: _isRolling ? 1.5 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Attribute name

          SizedBox(
            width: double.infinity,
            child: Text(
              attribute.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const SizedBox(height: 2),

          // Value and Focus
          SizedBox(
            height: 42,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Attribute value

                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _isValueEditing ? null : _rollDice,
                    onDoubleTap: _isValueEditing ? null : _startValueEditing,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 30,
                                child: _isValueEditing
                                    ? TextField(
                                        controller: _valueController,
                                        autofocus: true,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        decoration: const InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                          border: InputBorder.none,
                                        ),
                                        onSubmitted: (_) => _saveValue(),
                                      )
                                    : Center(
                                        child: Text(
                                          attribute.value.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),

                        // Value editing controls
                        if (_isValueEditing)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Row(
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
                                  onTap: _cancelValueEditing,
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white54,
                                    size: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Divider
                Container(
                  width: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  color: Colors.white10,
                ),

                // Focus
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onDoubleTap: _editFocus,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'FOCUS',
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            attribute.focus.isEmpty
                                ? 'Add focus...'
                                : attribute.focus,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: attribute.focus.isEmpty
                                  ? Colors.white24
                                  : Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Focus edit dialog

class FocusEditDialog extends StatefulWidget {
  final String initialFocus;

  const FocusEditDialog({super.key, required this.initialFocus});

  @override
  State<FocusEditDialog> createState() => _FocusEditDialogState();
}

class _FocusEditDialogState extends State<FocusEditDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialFocus);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2A2A2A),
      title: const Text(
        'Edit Focus',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLines: 3,
        minLines: 1,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Enter focus...',
          hintStyle: const TextStyle(color: Colors.white38),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white54),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, _controller.text.trim());
          },
          child: const Text(
            'Save',
            style: TextStyle(color: Colors.greenAccent),
          ),
        ),
      ],
    );
  }
}
