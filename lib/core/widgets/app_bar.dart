import 'package:flutter/material.dart';
import 'package:learning_management_system/core/theming/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

   CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
     final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      bottom: PreferredSize(preferredSize: preferredSize, child: VerticalDivider(color: CustomColors.primary2,width: double.infinity,thickness: 1,)),
      iconTheme: IconThemeData(color: CustomColors.primary), 
      backgroundColor: Colors.transparent,
      foregroundColor: const Color(0xffF5F5F5),
      elevation: 0,
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              color: const Color(0xff29C3CD),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: Text(
        title,
        style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? CustomColors.white : Colors.black,
          ),
      ),
      actions: actions,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
            Color(0xFF130830),
              Color(0xFF1b1344),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}