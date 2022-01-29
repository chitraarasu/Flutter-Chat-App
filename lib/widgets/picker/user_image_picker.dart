import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

enum buttonType {
  camera,
  galary,
}

class UserImagePicker extends StatefulWidget {
  Function pickedImageFN;
  UserImagePicker(this.pickedImageFN);
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  @override
  Widget build(BuildContext context) {
    _pickImage(type) async {
      PickedFile? image;
      if (type == buttonType.camera) {
        image = await ImagePicker.platform.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          maxWidth: 150,
        );
      } else {
        image = await ImagePicker.platform.pickImage(
          source: ImageSource.gallery,
          imageQuality: 50,
          maxWidth: 150,
        );
      }
      if (image == null) {
        return;
      }
      setState(() {
        _pickedImage = File(image!.path);
      });
      widget.pickedImageFN(_pickedImage);
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () {
                _pickImage(buttonType.camera);
              },
              icon: const Icon(Icons.camera),
              label: const Text('Take Image'),
            ),
            TextButton.icon(
              onPressed: () {
                _pickImage(buttonType.galary);
              },
              icon: const Icon(Icons.image),
              label: const Text('Choose Image'),
            )
          ],
        )
      ],
    );
  }
}
