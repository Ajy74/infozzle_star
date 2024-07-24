import 'package:breathpacer/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String hint;
  final Function(String) onTap;
  final TextEditingController controller = TextEditingController();

  CustomDialog({super.key, required this.title, required this.onTap, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(hintText: hint),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration:
                      BoxDecoration(color: AppTheme.colors.lightBlueButton, borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                    onPressed: () {
                      onTap(controller.text);
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
