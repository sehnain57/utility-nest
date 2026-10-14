import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';
import 'settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SettingsController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.lime : AppColors.violet;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Top Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 54, 22, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Preferences & App Information',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white54 : Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Settings Content
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // 1. Mini App Info Card
              GlassCard(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [AppColors.lime, AppColors.mint]
                              : [AppColors.violet, AppColors.sky],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.3),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.widgets_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Utility Nest',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Version 1.0.0 (Build 1)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white54 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.mint.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.mint.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock_outline_rounded,
                            size: 12,
                            color: AppColors.mint,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Private',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppColors.mint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // 2. Preferences Header
              _buildSectionTitle('PREFERENCES', isDark),
              const SizedBox(height: 8),

              // Dark Mode Switch Tile
              Obx(() => GlassCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      secondary: Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          c.isDarkMode.value
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          color: primaryColor,
                          size: 20,
                        ),
                      ),
                      title: const Text(
                        'Dark Appearance',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Text(
                        c.isDarkMode.value
                            ? 'Midnight space aesthetics'
                            : 'Crisp light mode theme',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
                      ),
                      value: c.isDarkMode.value,
                      activeThumbColor: Colors.white,
                      activeTrackColor: primaryColor,
                      onChanged: c.toggleTheme,
                    ),
                  )),

              const SizedBox(height: 22),

              // 3. General & Legal Section
              _buildSectionTitle('APP & LEGAL', isDark),
              const SizedBox(height: 8),

              // Privacy Policy Tile
              _buildSettingTile(
                context,
                icon: Icons.shield_outlined,
                iconColor: AppColors.sky,
                title: 'Privacy Policy',
                subtitle: 'Read our full privacy statement',
                trailing: Icons.open_in_new_rounded,
                isDark: isDark,
                onTap: c.openPrivacyPolicy,
              ),

              // Rate this App Tile
              _buildSettingTile(
                context,
                icon: Icons.star_outline_rounded,
                iconColor: AppColors.amber,
                title: 'Rate Utility Nest',
                subtitle: 'Leave a rating on Google Play',
                trailing: Icons.chevron_right_rounded,
                isDark: isDark,
                onTap: c.rateApp,
              ),

              // Share App Tile
              _buildSettingTile(
                context,
                icon: Icons.share_outlined,
                iconColor: AppColors.coral,
                title: 'Share with Friends',
                subtitle: 'Recommend this daily toolkit',
                trailing: Icons.chevron_right_rounded,
                isDark: isDark,
                onTap: c.shareApp,
              ),

              // About Tile
              _buildSettingTile(
                context,
                icon: Icons.info_outline_rounded,
                iconColor: AppColors.violet,
                title: 'About Utility Nest',
                subtitle: '8 built-in offline productivity utilities',
                trailing: Icons.chevron_right_rounded,
                isDark: isDark,
                onTap: () => _showAboutDialog(context, isDark, primaryColor),
              ),

              const SizedBox(height: 24),

              // Clean footer tagline
              Center(
                child: Text(
                  'Crafted with precision • Offline by default',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white30 : Colors.black26,
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, bottom: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: isDark ? Colors.white38 : Colors.black38,
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required IconData trailing,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              trailing,
              size: 18,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context, bool isDark, Color accentColor) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.widgets_rounded,
                      color: accentColor,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Utility Nest',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'An all-in-one daily toolkit designed with modern aesthetics and complete privacy in mind.\n\nIncludes World Clock, Habit Tracker, Water Intake, Typing Sprint, EMI Calculator, Random Picker, Event Countdown, and Device Diagnostics.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 10,
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
