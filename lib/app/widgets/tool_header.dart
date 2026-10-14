import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Ultra-modern glassmorphic header with a soft glowing orb behind
/// a frosted-glass bar. Used at the top of every tool screen.
class ToolHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final IconData icon;
  final List<Widget>? actions;

  const ToolHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.icon,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(110);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -50,
            left: -30,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: gradient),
                boxShadow: [BoxShadow(color: gradient.first.withOpacity(0.35), blurRadius: 70, spreadRadius: 6)],
              ),
            ),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                padding: const EdgeInsets.fromLTRB(4, 4, 16, 14),
                color: Colors.transparent,
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    children: [
                      IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20)),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(icon, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 2),
                            Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                          ],
                        ),
                      ),
                      if (actions != null) ...actions!,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
