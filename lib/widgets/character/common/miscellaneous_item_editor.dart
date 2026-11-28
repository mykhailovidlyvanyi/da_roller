//lib/widgets/character/common/miscellaneous_item_editor.dart

import 'package:material_ui/material_ui.dart';

import 'package:da_roller/models/character/miscellaneous_item.dart';

import 'package:da_roller/widgets/character/common/form_input.dart';

class MiscellaneousItemEditor {
  static Future<MiscellaneousItem?> show(
    BuildContext context, {
    MiscellaneousItem? existingItem,
  }) async {
    final nameController = TextEditingController(
      text: existingItem?.name ?? '',
    );
    final quantityController = TextEditingController(
      text: (existingItem?.quantity ?? 1).toString(),
    );
    final costController = TextEditingController(
      text: existingItem?.cost?.toString() ?? '',
    );
    final detailsController = TextEditingController(
      text: existingItem?.details ?? '',
    );

    final formKey = GlobalKey<FormState>();

    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = (screenWidth - 128).clamp(160.0, 512.0);
    final isWide = contentWidth >= 440;

    try {
      final result = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          title: Text(
            existingItem == null
                ? 'Add Miscellaneous Item'
                : 'Edit Miscellaneous Item',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: contentWidth,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FormInput(
                      controller: nameController,
                      label: 'Name',
                      isRequired: true,
                    ),
                    const SizedBox(height: 8),
                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FormInput(
                              controller: quantityController,
                              label: 'Quantity',
                              keyboardType: TextInputType.number,
                              isRequired: true,
                              isInteger: true,
                              minValue: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FormInput(
                              controller: costController,
                              label: 'Cost',
                              keyboardType: TextInputType.number,
                              isInteger: true,
                              minValue: 0,
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          FormInput(
                            controller: quantityController,
                            label: 'Quantity',
                            keyboardType: TextInputType.number,
                            isRequired: true,
                            isInteger: true,
                            minValue: 1,
                          ),
                          const SizedBox(height: 8),
                          FormInput(
                            controller: costController,
                            label: 'Cost',
                            keyboardType: TextInputType.number,
                            isInteger: true,
                            minValue: 0,
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    FormInput(
                      controller: detailsController,
                      label: 'Details',
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            TextButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.greenAccent),
              ),
            ),
          ],
        ),
      );

      if (result != true) return null;

      return MiscellaneousItem(
        id: existingItem?.id,
        name: nameController.text.trim(),
        quantity: int.parse(quantityController.text.trim()),
        cost: int.tryParse(costController.text.trim()),
        details: detailsController.text.trim(),
      );
    } finally {
      Future<void>.delayed(const Duration(milliseconds: 300), () {
        nameController.dispose();
        quantityController.dispose();
        costController.dispose();
        detailsController.dispose();
      });
    }
  }
}
