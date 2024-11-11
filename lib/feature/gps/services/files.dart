import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileHelper {
  // Get the downloads directory path
  static Future<Directory?> getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      return Directory('/storage/emulated/0/Download');
    } else {
      return await getApplicationDocumentsDirectory();
    }
  }

  // Request permission to access external storage
  static Future<bool> requestPermission() async {
    var status = await Permission.storage.status;

    // Check if permission is permanently denied (user selected "Don't Ask Again")
    if (status.isPermanentlyDenied) {
      print("Denied permission---");

      // Open app settings to allow the user to enable permissions
      await openAppSettings();
      return false;
    }

    // If permission is not granted, request it
    if (!status.isGranted) {
      print("Request permission---");
      status = await Permission.storage.request();
    }

    return status.isGranted;
  }

  // Create a text file and append content to it
  static Future<void> createAndAppendText(String text) async {
    if (await requestPermission()) {
      final directory = await getDownloadsDirectory();
      if (directory != null) {
        final filePath = '${directory.path}/example_file.txt';
        final file = File(filePath);

        // Check if file exists, create if it doesn't
        if (!await file.exists()) {
          await file.create(recursive: true);
        }

        // Append text to the file
        await file.writeAsString('$text\n', mode: FileMode.append);
        print('Text appended to ${file.path}');
      } else {
        print('Could not find the downloads directory');
      }
    } else {
      print('Storage permission not granted');
    }
  }
}
