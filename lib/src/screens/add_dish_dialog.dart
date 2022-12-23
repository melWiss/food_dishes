import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_dishes/src/blocs/account.dart';
import 'package:food_dishes/src/blocs/dish.dart';
import 'package:food_dishes/src/models/account/account.dart';
import 'package:food_dishes/src/models/dish/dish.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class AddDishDialog extends StatefulWidget {
  const AddDishDialog({
    super.key,
    this.dish,
  });
  final Dish? dish;

  @override
  State<AddDishDialog> createState() => _AddDishDialogState();
}

class _AddDishDialogState extends State<AddDishDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController =
      TextEditingController(text: widget.dish?.title);
  late TextEditingController _descriptionController =
      TextEditingController(text: widget.dish?.description);
  late String? _imagePath = widget.dish?.imagePath;
  final pickerController = MultiImagePickerController(
      maxImages: 1,
      allowedImageTypes: ['png', 'jpg', 'jpeg'],
      images: <ImageFile>[] // array of pre/default selected images
      );
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("${widget.dish == null ? "Add" : "Update"} dish"),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                    labelText: "Title", hintText: "some dish..."),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Title cannot be empty.";
                  }
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "some dish description..."),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Description cannot be empty.";
                  }
                },
              ),
              Material(
                child: InkWell(
                  child: _imagePath == null
                      ? Icon(
                          Icons.image,
                          size: 200,
                        )
                      : Image.file(
                          File(_imagePath!),
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                  onTap: () async {
                    // var picker = ImagePicker();
                    await pickerController.pickImages();
                    if (pickerController.images.isNotEmpty) {
                      _imagePath = pickerController.images.first.path;
                      setState(() {
                        pickerController
                            .removeImage(pickerController.images.first);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate() && _imagePath != null) {
                if (widget.dish == null) {
                  DishBloc().add(Dish(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    imagePath: _imagePath,
                  ));
                } else {
                  DishBloc().update(Dish(
                    id: widget.dish!.id,
                    title: _titleController.text,
                    description: _descriptionController.text,
                    imagePath: _imagePath,
                  ));
                }
                Navigator.of(context)
                    .popUntil((route) => !route.hasActiveRouteBelow);
              }
            },
            child: Text("Submit")),
        TextButton(
          onPressed: () => Navigator.of(context)
              .popUntil((route) => !route.hasActiveRouteBelow),
          child: Text("Cancel"),
        ),
      ],
    );
  }
}
