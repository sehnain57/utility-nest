import 'package:flutter/material.dart';

class HeroToolCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  const HeroToolCard({
    super.key,
    required this.title,
    required this.icon,
    required this.gradient,
    required this.onTap,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32),
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [BoxShadow(color: gradient.first.withValues(alpha: 0.4), blurRadius: 30, offset: const Offset(0, 15))],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -40,
                bottom: -40,
                child: Icon(icon, size: 200, color: Colors.white.withValues(alpha: 0.15)),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(icon, color: Colors.white, size: 36),
                        ),
                        if (onFavoriteTap != null)
                          GestureDetector(
                            onTap: onFavoriteTap,
                            behavior: HitTestBehavior.opaque,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                              child: Icon(
                                isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                                key: ValueKey(isFavorite),
                                color: isFavorite ? Colors.white : Colors.white54,
                                size: 32,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
