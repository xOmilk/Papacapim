import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_project/models/responses/user_response.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final UserResponse user = UserResponse(
    login: "luan",
    name: "Luan Coelho",
    profileImage:
        "https://upload.wikimedia.org/wikipedia/commons/4/49/Panthera_tigris_tigris.jpg",
  );
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String? imagePath;

  void onGoingBack() {
    context.pop();
  }

  void onImageTap() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      File imageFile = File(image.path);

      setState(() {
        imagePath = imageFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: context.canPop()
            ? IconButton(onPressed: onGoingBack, icon: Icon(Icons.arrow_back))
            : null,
        title: Text("Editar perfil"),
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.all(
                          Radius.circular(100),
                        ),
                        child: InkWell(
                          onTap: onImageTap,
                          child: user.profileImage != null
                              ? imagePath != null
                                    ? Image.file(File(imagePath!))
                                    : Image.network(
                                        user.profileImage!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.broken_image,
                                                size: 64,
                                              );
                                            },
                                      )
                              : ColoredBox(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: onImageTap,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(Icons.edit),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                TextField(decoration: InputDecoration(hintText: "Login")),
                SizedBox(height: 8),
                TextField(decoration: InputDecoration(hintText: "Nome")),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text("Mudar senha"),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
                    child: Text("Atualizar"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
