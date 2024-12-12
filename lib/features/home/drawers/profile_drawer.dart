import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});
  void navigateToProfileScreen(String uid, BuildContext context) {
    Routemaster.of(context).push('/u/$uid');
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              radius: 70,
            ),
            const SizedBox(height: 10),
            Text(
              'u/${user.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            ListTile(
              onTap: () {
                navigateToProfileScreen(user.uid, context);
              },
              title: const Text("My Profile"),
              leading: const Icon(Icons.person),
            ),
            ListTile(
              onTap: () {
                return ref.watch(authConrollerProvider.notifier).logout();
              },
              title: const Text("Log Out"),
              leading: Icon(
                Icons.logout,
                color: Pallete.redColor,
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Icon(
                        Icons.light_mode,
                        color: ref.watch(themeNotifierProvider.notifier).mode ==
                                ThemeMode.light
                            ? Colors
                                .blue // Assuming you want to change the color based on the theme
                            : null, // Default color
                      ),
                    ),
                    Switch.adaptive(
                        value: ref.watch(themeNotifierProvider.notifier).mode ==
                            ThemeMode.dark,
                        onChanged: (val) => toggleTheme(ref)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Icon(
                        Icons.dark_mode,
                        color: ref.watch(themeNotifierProvider.notifier).mode ==
                                ThemeMode.dark
                            ? const Color.fromARGB(255, 80, 207,
                                205) // Assuming you want to change the color based on the theme
                            : null, // Default color
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
