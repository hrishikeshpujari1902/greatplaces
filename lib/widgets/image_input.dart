import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function selectImage;
  ImageInput(this.selectImage);
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  final picker = ImagePicker();
  File _storedImage;

  Future<void> _getImage() async {
    final pickedfile =
        await picker.getImage(source: ImageSource.camera, maxWidth: 600);
    if (pickedfile == null) {
      return;
    }
    setState(() {
      _storedImage = File(pickedfile.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();

    final fileName = path.basename(pickedfile.path);
    final savedImage =
        await File(pickedfile.path).copy('${appDir.path}/$fileName');
    widget.selectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child:
              // ignore: deprecated_member_use
              FlatButton.icon(
            onPressed: _getImage,
            label: Text('Take Picture'),
            icon: Icon(Icons.camera),
          ),
        ),
      ],
    );
  }
}
