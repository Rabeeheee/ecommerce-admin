import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

Future<Map<String, dynamic>?> imagePicker() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom, 
    allowedExtensions: ['jpeg', 'png', 'jpg'],
    withData: true,  // Make sure to get the file data
  );
  
  if (result != null && result.files.first.bytes != null) {
    // Extract the file extension from the name
    String fileName = result.files.first.name;
    String extension = fileName.split('.').last.toLowerCase();
    
    return {
      'bytes': result.files.first.bytes,
      'extension': extension,
    };
  } else {
    return null;
  }
}