import 'package:flutter/material.dart';
import 'package:flutter_project/models/responses/user_response.dart';
import 'package:flutter_project/ui/components/change_password_modal.dart';
import 'package:flutter_project/ui/components/delete_profile_dialog.dart';
import 'package:flutter_project/ui/components/user_avatar.dart';
import 'package:flutter_project/utils/navigation_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_project/models/requests/update_user_request.dart';
import 'package:flutter_project/notifiers/prefs_provider.dart';
import 'package:flutter_project/repositories/auth_repository.dart';
import 'package:flutter_project/repositories/user_repository.dart';
import 'package:flutter_project/ui/components/show_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'dart:io';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  late Future<UserResponse> user;

  final ImagePicker _picker = ImagePicker();
  String? imagePath;
  String? imageBase64;
  String? profileImageUrl;
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _nameController = TextEditingController();

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

      final bytes = await imageFile.readAsBytes();
      imageBase64 = base64Encode(bytes);

      setState(() {
        imagePath = imageFile.path;
      });
    }
  }

  Future<void> onSubmit() async {
    final updateUserRequest = UpdateUserRequest(
      login: _loginController.text,
      name: _nameController.text,
      imageData: imageBase64,
    );
    final userRepository = ref.read(usersRepositoryProvider);
    final preferences = ref.read(prefsProvider);

    try {
      await userRepository.updateUser(updateUserRequest);
      if (profileImageUrl != null) {
        await NetworkImage(profileImageUrl!).evict();
      }
      await preferences.clearAuth();
      ref.invalidate(tokenProvider);

      if (mounted) {
        showMessage(
          context,
          "Usuário alterado com sucesso, efetue login novamente",
        );
        context.replace("/auth");
      }
    } catch (e) {
      if (mounted) {
        showMessage(context, "Erro ao alterar usuário", isError: true);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    final authRepo = ref.read(authRepositoryProvider);
    user = authRepo.getMyProfile();

    user.then((data) {
      if (!mounted) return;

      _loginController.text = data.login;
      _nameController.text = data.name;

      profileImageUrl = data.profileImage;
    });
  }

  @override
  void dispose() {
    _loginController.dispose();
    _nameController.dispose();
    super.dispose();
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
                    FutureBuilder(
                      future: user,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text("Erro: ${snapshot.error}"));
                        }

                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text("Perfil não encontrado."),
                          );
                        }

                        final data = snapshot.data!;
                        profileImageUrl = data.profileImage;

                        return SizedBox(
                          width: 90,
                          height: 90,
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.all(
                              Radius.circular(100),
                            ),
                            child: InkWell(
                              onTap: onImageTap,
                              child: UserAvatar(
                                imageUrl: data.profileImage,
                                imageFile: imagePath != null
                                    ? File(imagePath!)
                                    : null,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: onImageTap,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(100),
                            ),
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.edit),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (imagePath != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Nova foto (não salva)",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _loginController,
                  decoration: InputDecoration(
                    labelText: "Login",
                    hintText: "Ex: seu_usuario",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(
                      Icons.alternate_email,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Nome",
                    hintText: "Ex: Gabriel Silva",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => changePasswordModal(ref, context),
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
                    onPressed: onSubmit,
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
                    onPressed: () => deleteProfileDialog(ref, context),
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
