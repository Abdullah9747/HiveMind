import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/user_profile/controller/user_profile_controller.dart';
import 'package:reddit/theme/pallete.dart';

class EditUserProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditUserProfileScreen({super.key, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends ConsumerState<EditUserProfileScreen> {
  File? bannerFile;
  File? profileFile;

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      bannerFile = File(res.paths.first!);
      setState(() {});
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      profileFile = File(res.paths.first!);
      setState(() {});
    }
  }

  void save() {
    ref.read(userProfileControllerProvider.notifier).editUserProfile(
        profileFile: profileFile,
        bannerFile: bannerFile,
        context: context,
        name: nameController.text.trim());
  }

  late TextEditingController nameController;
  @override
  void initState() {
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return ref.watch(getUserDataProvider(widget.uid)).when(
          data: (user) => Scaffold(
            backgroundColor: currentTheme.drawerTheme.backgroundColor,
            appBar: AppBar(
              title: const Text("Edit Community"),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: save,
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            body: isLoading
                ? const Loader()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: selectBannerImage,
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(10),
                                  strokeCap: StrokeCap.round,
                                  dashPattern: const [10, 4],
                                  color: Pallete.darkModeAppTheme.textTheme
                                      .bodyMedium!.color!,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    width: double.infinity,
                                    height: 150,
                                    child: bannerFile != null
                                        ? Image.file(bannerFile!)
                                        : user.banner.isEmpty ||
                                                user.banner ==
                                                    Constants.bannerDefault
                                            ? const Icon(
                                                Icons.camera_alt_outlined)
                                            : Image.network(user.banner),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: GestureDetector(
                                  onTap: selectProfileImage,
                                  child: profileFile != null
                                      ? CircleAvatar(
                                          radius: 35,
                                          backgroundImage:
                                              FileImage(profileFile!),
                                        )
                                      : CircleAvatar(
                                          radius: 35,
                                          backgroundImage:
                                              NetworkImage(user.profilePic),
                                        ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                                hintText: "Name",
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(10)),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(18))),
                      ],
                    ),
                  ),
          ),
          loading: () => const Loader(),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
        );
  }
}
