import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/community/controller/community_controller.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModsScreen({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  void saveMods() {
    ref
        .read(communityControllerProvider.notifier)
        .addMods(widget.name, uids.toList(), context);
  }

  Set<String> uids = {};
  void addMOd(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeMOd(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  int counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: saveMods,
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) {
            return ListView.builder(
                itemCount: community.members.length,
                itemBuilder: (BuildContext context, int index) {
                  if (counter == 0) {
                    uids = community.mods.toSet();
                    counter++;
                  }
                  final member = community.members[index];
                  return ref.read(getUserDataProvider(member)).when(
                      data: (user) {
                        return CheckboxListTile(
                            secondary: CircleAvatar(
                              backgroundImage: NetworkImage(user.profilePic),
                            ),
                            value: uids.contains(user.uid),
                            onChanged: (value) {
                              if (value!) {
                                addMOd(user.uid);
                              } else {
                                removeMOd(user.uid);
                              }
                            },
                            title: Text(user.name));
                      },
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => const Loader());
                });
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
