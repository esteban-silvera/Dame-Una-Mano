import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final VoidCallback? onProfilePressed;
  final VoidCallback? onNotificationPressed;

  const CustomAppBar({
    Key? key,
    this.height = kToolbarHeight,
    this.onProfilePressed,
    this.onNotificationPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF43c7ff),
      title: Row(
        children: [
          const Text(
            'Dame una mano',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.home, color: Color(0xFFf5f5f5)),
            onPressed: () {
              // Acción al presionar el icono de inicio
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Color(0xFFf5f5f5)),
            onPressed: onNotificationPressed,
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Color(0xFFf5f5f5)),
            onPressed: onProfilePressed,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
