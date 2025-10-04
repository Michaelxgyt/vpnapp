import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../controller/local_controller.dart';

class ReusableLanguageBottomSheetButton extends GetView<LocaleController> {
  ReusableLanguageBottomSheetButton({
    super.key,
    this.widget,
    this.languageIconSize,
    this.dropdownIconSize,
    this.dropdownIconColor,
  });

  final Widget? widget;
  final double? languageIconSize;
  final double? dropdownIconSize;
  final Color? dropdownIconColor;

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLanguageBottomSheet(context),
      child:
      Row(
        children: [
          widget ??
              Icon(
                Icons.language_outlined,
                size: languageIconSize ?? 25,
                color: Colors.white,
              ),
          Icon(
            Icons.keyboard_arrow_down_outlined,
            size: dropdownIconSize ?? 26,
            color: dropdownIconColor ?? Colors.white,
          ),
        ],
      ),

    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E), // Dark theme background
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.45,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Drag handle
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                // Title
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Select Language',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Language list as cards
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: controller.optionsLocales.length,
                    itemBuilder: (context, index) {
                      final entry = controller.optionsLocales.entries.elementAt(index);

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: Card(
                          elevation: 3,
                          color: const Color(0xFF2A2A2A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              controller.updateLocale(entry.key);
                              box.write("ln", entry.key);
                              Navigator.of(context).pop(); // Close sheet
                              ScaffoldMessenger.of(context).removeCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Language changed to ${entry.value['description']}',
                                    style: const TextStyle(color: Colors.white, fontSize: 16.0),
                                  ),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: Colors.deepPurple,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Row(
                                children: [
                                  const Icon(Icons.language, color: Colors.white70),
                                  const SizedBox(width: 12),
                                  Text(
                                    '${entry.value['description']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
