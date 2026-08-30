import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_project/models/responses/user_response.dart';
import 'package:flutter_project/utils/navigation_utils.dart';
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

  void changePasswordModal() {
    bool obscureNew = true;
    bool obscureConfirm = true;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text("Trocar senha"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Nova senha"),
                  SizedBox(height: 8),
                  TextField(
                    obscureText: obscureNew,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setStateDialog(() {
                            obscureNew = !obscureNew;
                          });
                        },
                        icon: Icon(
                          obscureNew ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text("Confirmar senha"),
                  SizedBox(height: 8),
                  TextField(
                    obscureText: obscureConfirm,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setStateDialog(() {
                            obscureConfirm = !obscureConfirm;
                          });
                        },
                        icon: Icon(
                          obscureConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text("Cancelar"),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text("Alterar Senha"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void deleteProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Excluir conta?"),
        content: const Text("Tem certeza que deseja excluir esta conta?"),
        actions: [
          TextButton(
            style: const ButtonStyle(
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancelar",
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
          ),
          FilledButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.error,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              context.replace("/auth");
            },
            child: const Text("Excluir"),
          ),
        ],
      ),
    );
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
            ? IconButton(
                onPressed: () => NavigationUtils.onGoingBack(context),
                icon: Icon(Icons.arrow_back),
              )
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
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
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
                  child: TextButton(
                    onPressed: () {
                      changePasswordModal();
                    },
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
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.error,
                      ),
                    ),
                    onPressed: deleteProfileDialog,
                    child: Text("Excluir conta"),
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
