import 'package:image_picker/image_picker.dart';
import 'package:riverpod/riverpod.dart';

class ImagePickerController extends Notifier<XFile?> {
  @override
  XFile? build() => null;

  final _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      state = pickedFile;
    }
  }
}

final imagePickerControllerProvider = NotifierProvider.autoDispose<ImagePickerController, XFile?>(
  ImagePickerController.new,
);