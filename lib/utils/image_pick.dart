import 'package:file_picker/file_picker.dart';

Future<PlatformFile?> imagePicker() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom, allowedExtensions: ['jpeg', 'png', 'jpg']);
  if (result != null) {
    return result.files.first;
  } else {
    return null;
  }
}
