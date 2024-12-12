import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToAddPostType(BuildContext context, String type) {
    Routemaster.of(context).push("/add-post/$type");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    double heightwidth = 120;
    double iconsize = 60;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => navigateToAddPostType(context, "image"),
          child: SizedBox(
            height: heightwidth,
            width: heightwidth,
            child: Card(
              elevation: 16,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: currentTheme.drawerTheme.backgroundColor,
              child: Icon(
                Icons.image_outlined,
                size: iconsize,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => navigateToAddPostType(context, "text"),
          child: SizedBox(
            height: heightwidth,
            width: heightwidth,
            child: Card(
              elevation: 16,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: currentTheme.drawerTheme.backgroundColor,
              child: Icon(
                Icons.font_download_off_outlined,
                size: iconsize,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => navigateToAddPostType(context, "link"),
          child: SizedBox(
            height: heightwidth,
            width: heightwidth,
            child: Card(
              elevation: 16,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: currentTheme.drawerTheme.backgroundColor,
              child: Icon(
                Icons.link_off_outlined,
                size: iconsize,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
