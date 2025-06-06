// 📄 complete_profile_page.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:poke_app/components/common/constants.dart';
import 'package:poke_app/features/auth/provider/auth_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:poke_app/services/router/router_provider.dart';

class CompleteProfilePage extends ConsumerStatefulWidget {
  const CompleteProfilePage({super.key, this.tutorialData});
  final Map<String, dynamic>? tutorialData;

  @override
  ConsumerState<CompleteProfilePage> createState() =>
      _CompleteProfilePageState();
}

class _CompleteProfilePageState extends ConsumerState<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  File? _selectedImage;
  bool _isUploading = false;
  String? _error;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  Future<String?> _uploadImage(User user) async {
    if (_selectedImage == null) return null;
    final compressedFile = await _compressImage(_selectedImage!, user.uid);

    final ref = FirebaseStorage.instance
        .ref()
        .child('avatars')
        .child('${user.uid}.jpg');

    await ref.putFile(compressedFile!);
    return await ref.getDownloadURL();
  }

  Future<File?> _compressImage(File imageFile, String fileName) async {
    final originalBytes = await imageFile.readAsBytes();
    final decodedImage = img.decodeImage(originalBytes);
    if (decodedImage == null) return null;

    // Resize proportionally to fit within 1280x720
    const maxWidth = 1280;
    const maxHeight = 720;

    int targetWidth = decodedImage.width;
    int targetHeight = decodedImage.height;

    final widthRatio = maxWidth / targetWidth;
    final heightRatio = maxHeight / targetHeight;
    final scale = widthRatio < heightRatio ? widthRatio : heightRatio;

    if (scale < 1) {
      targetWidth = (decodedImage.width * scale).round();
      targetHeight = (decodedImage.height * scale).round();
    }

    final dir = await getTemporaryDirectory();
    final targetPath = path.join(dir.path, '${fileName}_compressed.jpg');

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      imageFile.path,
      targetPath,
      quality: 90,
      minWidth: targetWidth,
      minHeight: targetHeight,
      format: CompressFormat.jpeg,
      keepExif: true,
    );
    return compressedFile != null ? File(compressedFile.path) : null;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Complete Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null,
                  child:
                      _selectedImage == null
                          ? const Icon(Icons.camera_alt, size: 40)
                          : null,
                ),
              ),
              Gaps.h16,
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                //Let's assume that username not unique(e.g., "nickname#{hash_id}" is valid)
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Username is required'
                            : null,
              ),
              TextFormField(
                initialValue: user?.email ?? '',
                decoration: const InputDecoration(labelText: 'Email'),
                enabled: false,
              ),
              if (_error != null) ...[
                Gaps.h8,
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              Gaps.h16,
              ElevatedButton(
                onPressed:
                    _isUploading
                        ? null
                        : () async {
                          if (!_formKey.currentState!.validate()) return;
                          setState(() => _isUploading = true);
                          try {
                            final avatarUrl = await _uploadImage(user!);
                            await ref
                                .read(authControllerProvider.notifier)
                                .completeProfile(
                                  username: _usernameController.text.trim(),
                                  email: user.email!,
                                  avatar: avatarUrl,
                                  discovered: widget.tutorialData,
                                );
                            if (!context.mounted) return;
                            ref.context.goNamed(rPokedex);
                          } catch (e) {
                            setState(() => _error = e.toString());
                          } finally {
                            setState(() => _isUploading = false);
                          }
                        },
                child:
                    _isUploading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
