import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'glass_card.dart';

class WideToolCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  const WideToolCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        padding: const EdgeInsets.all(0), // Custom padding inside
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: gradient.first.withValues(alpha: 0.3), blurRadius: 15, spreadRadius: -2)],
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(subtitle ?? 'Launch this tool', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black54, fontSize: 13)),
                  ],
                ),
              ),
              if (onFavoriteTap != null)
                GestureDetector(
                  onTap: onFavoriteTap,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                      child: Icon(
                        isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                        key: ValueKey(isFavorite),
                        color: isFavorite ? AppColors.coral : (Theme.of(context).brightness == Brightness.dark ? Colors.white30 : Colors.black26),
                        size: 26,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
