import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijingo/components/button_widget.dart';

class DialogService {
  static void showAlert(
    BuildContext context,
    String title,
    String content, {
    String? positiveButtonTitle,
    String? positivePath,
    required final dynamic Function(dynamic) onPressedButton,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          title: Text(title),
          content: Text(content),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, bottom: 20.0, right: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: Wrap(
                  runSpacing: 4.0,
                  children: [
                    positiveButtonTitle != null
                        ? ButtonWidget(
                            type: 'primary',
                            onPressed: (res) {
                              onPressedButton(res);
                              if (positivePath == null) return;
                              context.go(positivePath);
                            },
                            title: positiveButtonTitle,
                          )
                        : Container(),
                    ButtonWidget(
                      type: 'outline',
                      onPressed: (res) {
                        context.pop();
                      },
                      title: 'Close',
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
