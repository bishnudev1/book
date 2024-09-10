import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

Future<bool> showExitConfirmationDialog(BuildContext context) async {
  return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Exit App',
            style: GoogleFonts.abel(),
          ),
          content: Text(
            'Do you want to exit the app?',
            style: GoogleFonts.lato(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Exit'),
            ),
          ],
        ),
      )) ??
      false;
}

onback(BuildContext context) async {
  // bool? exitApp =
  await showDialog(
    context: context,
    builder: ((context) {
      return AlertDialog(
        title: Text('Are you sure you want to exit the app ?',
            style: GoogleFonts.lato(
              fontSize: 15,
            )),
        actions: [
          TextButton(
              onPressed: () {
                if (context.mounted) {
                  Navigator.of(context).pop(false);
                }
              },
              child: const Text('No')),
          TextButton(
              onPressed: () {
                if (context.mounted) {
                  SystemNavigator.pop();
                }
              },
              child: const Text('Yes'))
        ],
      );
    }),
  );

  // return exitApp ?? false;
}
