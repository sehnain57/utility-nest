import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/hero_tool_card.dart';
import '../../widgets/tool_card.dart';
import '../../widgets/wide_tool_card.dart';
import '../settings/settings_screen.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Soft ambient background glowing orbs for extra modern depth
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isDark ? AppColors.lime : AppColors.violet)
                    .withValues(alpha: isDark ? 0.08 : 0.05),
              ),
            ),
          ),
          Positioned(
            top: 280,
            left: -100,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.sky.withValues(alpha: isDark ? 0.06 : 0.04),
              ),
            ),
          ),

          // Main View Tabs
          Obx(
            () => IndexedStack(
              index: c.currentIndex.value,
              children: [
                _buildDashboard(context, c, isDark),
                _buildAllTools(context, c, isDark),
                _buildFavorites(context, c, isDark),
                _buildStats(context, c, isDark),
                const SettingsScreen(),
              ],
            ),
          ),

          // Floating Glass Bottom Navigation Bar
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: _buildFloatingNavBar(context, c, isDark),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // DASHBOARD TAB (MAIN SCREEN)
  // ==========================================
  Widget _buildDashboard(
    BuildContext context,
    HomeController c,
    bool isDark,
  ) {
    final now = DateTime.now();
    final dateFormatted = DateFormat('EEEE, d MMM').format(now);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // 1. Soft Modern Top Bar (Date badge + Day-wise Greeting)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 54, 22, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date & Status Pill
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.07)
                            : Colors.black.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.black.withValues(alpha: 0.06),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 13,
                            color: isDark ? AppColors.lime : AppColors.violet,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            dateFormatted,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white70 : Colors.black87,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Quick Action: Jump to All Tools / Search
                    GestureDetector(
                      onTap: () => c.changeTab(4), // Go to settings
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : Colors.black.withValues(alpha: 0.06),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.settings_outlined,
                          size: 19,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Day-Wise Greeting with Soft Modern Typography
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${c.greeting} ${c.greetingEmoji}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 27,
                                      letterSpacing: -0.8,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF141724),
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            c.greetingSubtitle,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Soft Glowing Time Period Badge Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [
                                  AppColors.lime.withValues(alpha: 0.2),
                                  AppColors.mint.withValues(alpha: 0.1),
                                ]
                              : [
                                  AppColors.violet.withValues(alpha: 0.15),
                                  AppColors.sky.withValues(alpha: 0.1),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isDark
                              ? AppColors.lime.withValues(alpha: 0.3)
                              : AppColors.violet.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Icon(
                        c.greetingIcon,
                        size: 26,
                        color: isDark ? AppColors.lime : AppColors.violet,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // 2. Day-Wise Inspiring Quote Card (Interactive & Soft)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
            child: _buildDayWiseQuoteCard(context, c, isDark),
          ),
        ),

        // 3. Soft Modern Search Bar with Category Filter Pills
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
            child: _buildSearchBarAndFilters(context, c, isDark),
          ),
        ),

        // 4. Interactive Feature Banners Carousel (When not searching)
        Obx(() {
          if (c.searchQuery.isNotEmpty) {
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          }
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 22),
              child: _buildBannerCarousel(context, c, isDark),
            ),
          );
        }),

        // 5. Daily Glance Row: Water & Habits Status (When not searching)
        Obx(() {
          if (c.searchQuery.isNotEmpty) {
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          }
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 26),
              child: _buildDailyGlanceRow(context, c, isDark),
            ),
          );
        }),

        // 6. Tools Section Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 14),
            child: Obx(() {
              final isSearching = c.searchQuery.isNotEmpty;
              final selectedCat = c.selectedCategory.value;
              final count = c.filteredTools.length;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        isSearching
                            ? 'Search Results'
                            : (selectedCat == 'All'
                                ? 'Essential Utilities'
                                : selectedCat),
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: (isDark ? AppColors.lime : AppColors.violet)
                              .withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.lime : AppColors.violet,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (isSearching)
                    TextButton(
                      onPressed: c.clearSearch,
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        foregroundColor: AppColors.coral,
                      ),
                      child: const Text(
                        'Clear',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () => c.changeTab(1),
                      child: Row(
                        children: [
                          Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.lime : AppColors.violet,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 15,
                            color: isDark ? AppColors.lime : AppColors.violet,
                          ),
                        ],
                      ),
                    ),
                ],
              );
            }),
          ),
        ),

        // 7. Tools Grid (Reactive with Search & Categories)
        Obx(() {
          final list = c.filteredTools;
          if (list.isEmpty) {
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(
                    vertical: 36,
                    horizontal: 24,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.coral.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.search_off_rounded,
                          size: 38,
                          color: AppColors.coral,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No matching tools found',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Try searching with a different keyword or switch category',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton(
                        onPressed: c.clearSearch,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 10,
                          ),
                        ),
                        child: const Text('Reset Search'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Show tool grid
          return SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.02,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final tool = list[index];
                  return ToolCard(
                    title: tool.title,
                    subtitle: tool.subtitle,
                    category: tool.category,
                    icon: tool.icon,
                    gradient: tool.gradient,
                    onTap: () => c.openTool(tool.route),
                    isFavorite: c.isFavorite(tool.route),
                    onFavoriteTap: () => c.toggleFavorite(tool.route),
                  );
                },
                childCount: list.length,
              ),
            ),
          );
        }),
      ],
    );
  }

  // ==========================================
  // DAY-WISE QUOTE CARD WIDGET
  // ==========================================
  Widget _buildDayWiseQuoteCard(
    BuildContext context,
    HomeController c,
    bool isDark,
  ) {
    return Obx(() {
      final quote = c.currentQuote;

      return GlassCard(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            // Watermark quote icon in background
            Positioned(
              right: -10,
              bottom: -15,
              child: Icon(
                Icons.format_quote_rounded,
                size: 90,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.04)
                    : Colors.black.withValues(alpha: 0.03),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tag & Refresh Action
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: (isDark ? AppColors.lime : AppColors.violet)
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.auto_awesome_rounded,
                                size: 12,
                                color:
                                    isDark ? AppColors.lime : AppColors.violet,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                c.greetingBadge,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: isDark
                                      ? AppColors.lime
                                      : AppColors.violet,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          quote.tag,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                        ),
                      ],
                    ),
                    // Tap to cycle quote
                    InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: c.cycleQuote,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.black.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.refresh_rounded,
                              size: 14,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Quote Text
                Text(
                  '“${quote.text}”',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.92)
                        : const Color(0xFF1E2235),
                  ),
                ),
                const SizedBox(height: 10),

                // Author
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '— ${quote.author}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  // ==========================================
  // SEARCH BAR & CATEGORY FILTERS
  // ==========================================
  Widget _buildSearchBarAndFilters(
    BuildContext context,
    HomeController c,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Soft Glass Search Field
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.07),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: TextField(
            controller: c.searchController,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Search tools, calculators & trackers...',
              hintStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 14, right: 10),
                child: Icon(
                  Icons.search_rounded,
                  color: isDark ? AppColors.lime : AppColors.violet,
                  size: 22,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 42,
                minHeight: 42,
              ),
              suffixIcon: Obx(() {
                if (c.searchQuery.isEmpty) return const SizedBox.shrink();
                return IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  color: isDark ? Colors.white54 : Colors.black45,
                  onPressed: c.clearSearch,
                );
              }),
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Horizontal Category Filter Pills
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: c.categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = c.categories[index];
              return Obx(() {
                final isSelected = c.selectedCategory.value == cat;
                return GestureDetector(
                  onTap: () => c.selectCategory(cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: isDark
                                  ? [AppColors.lime, AppColors.mint]
                                  : [AppColors.violet, AppColors.sky],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isSelected
                          ? null
                          : (isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.black.withValues(alpha: 0.04)),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : (isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : Colors.black.withValues(alpha: 0.06)),
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: (isDark
                                        ? AppColors.lime
                                        : AppColors.violet)
                                    .withValues(alpha: 0.28),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected
                              ? (isDark ? Colors.black : Colors.white)
                              : (isDark ? Colors.white70 : Colors.black87),
                        ),
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }

  // ==========================================
  // INTERACTIVE BANNER CAROUSEL
  // ==========================================
  Widget _buildBannerCarousel(
    BuildContext context,
    HomeController c,
    bool isDark,
  ) {
    return Column(
      children: [
        SizedBox(
          height: 168,
          child: PageView(
            physics: const BouncingScrollPhysics(),
            onPageChanged: (idx) => c.bannerIndex.value = idx,
            children: [
              // Banner 1: Daily Hydration Glow & Quick Log
              _buildSingleBanner(
                context,
                gradient: const [Color(0xFF0EA5E9), Color(0xFF10B981)],
                badge: 'HYDRATION GLOW',
                title: 'Track Your Daily Glow',
                subtitle:
                    'Stay energized with regular water pauses throughout the day.',
                icon: Icons.water_drop_rounded,
                actionLabel: '+250ml Water',
                actionIcon: Icons.add_rounded,
                onActionTap: () => c.addQuickWater(250),
                onCardTap: () => c.openTool(AppRoutes.waterTracker),
              ),

              // Banner 2: Habit Consistency
              _buildSingleBanner(
                context,
                gradient: const [Color(0xFFFF6B6B), Color(0xFFFF9F43)],
                badge: 'MOMENTUM',
                title: 'Build Unstoppable Habits',
                subtitle:
                    'Consistent micro-habits compound into massive long-term growth.',
                icon: Icons.local_fire_department_rounded,
                actionLabel: 'Check Habits',
                actionIcon: Icons.checklist_rounded,
                onActionTap: () => c.openTool(AppRoutes.habitTracker),
                onCardTap: () => c.openTool(AppRoutes.habitTracker),
              ),

              // Banner 3: Typing Speed Sprint
              _buildSingleBanner(
                context,
                gradient: const [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                badge: 'FOCUS BOOSTER',
                title: 'Speed Typing Sprint',
                subtitle:
                    'Warm up your mind with a fun 60-second typing accuracy test.',
                icon: Icons.keyboard_rounded,
                actionLabel: 'Start Sprint',
                actionIcon: Icons.play_arrow_rounded,
                onActionTap: () => c.openTool(AppRoutes.typingTest),
                onCardTap: () => c.openTool(AppRoutes.typingTest),
              ),

              // Banner 4: Quick Financial Planning
              _buildSingleBanner(
                context,
                gradient: const [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                badge: 'SMART CALCULATOR',
                title: 'Smart Loan & EMI Planner',
                subtitle:
                    'Calculate interest, amortization & monthly payouts instantly.',
                icon: Icons.account_balance_rounded,
                actionLabel: 'Calculate',
                actionIcon: Icons.calculate_rounded,
                onActionTap: () => c.openTool(AppRoutes.emiCalculator),
                onCardTap: () => c.openTool(AppRoutes.emiCalculator),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Animated Page Indicator Dots
        Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              final isActive = c.bannerIndex.value == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 5,
                width: isActive ? 22 : 6,
                decoration: BoxDecoration(
                  color: isActive
                      ? (isDark ? AppColors.lime : AppColors.violet)
                      : (isDark
                          ? Colors.white.withValues(alpha: 0.2)
                          : Colors.black.withValues(alpha: 0.15)),
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            }),
          );
        }),
      ],
    );
  }

  Widget _buildSingleBanner(
    BuildContext context, {
    required List<Color> gradient,
    required String badge,
    required String title,
    required String subtitle,
    required IconData icon,
    required String actionLabel,
    required IconData actionIcon,
    required VoidCallback onActionTap,
    required VoidCallback onCardTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onCardTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: gradient.first.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Subtle background large icon
              Positioned(
                right: -15,
                bottom: -20,
                child: Icon(
                  icon,
                  size: 140,
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top row: Badge pill & Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, color: Colors.white, size: 20),
                        ),
                      ],
                    ),

                    // Middle: Title & Subtitle
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    // Bottom Row: Action button
                    Row(
                      children: [
                        GestureDetector(
                          onTap: onActionTap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  actionIcon,
                                  size: 15,
                                  color: gradient.first,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  actionLabel,
                                  style: TextStyle(
                                    color: gradient.first,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // DAILY GLANCE ROW (WATER & HABITS CARDS)
  // ==========================================
  Widget _buildDailyGlanceRow(
    BuildContext context,
    HomeController c,
    bool isDark,
  ) {
    return Row(
      children: [
        // Water Tracker Glance Card
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(16),
            onTap: () => c.openTool(AppRoutes.waterTracker),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: AppColors.mint.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.water_drop_rounded,
                        color: AppColors.mint,
                        size: 20,
                      ),
                    ),
                    Obx(() {
                      final pct = (c.waterProgress.value * 100).toInt();
                      return Text(
                        '$pct%',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.mint,
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 14),
                Obx(
                  () => Text(
                    '${c.waterIntake.value} ml',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 21,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hydration',
                      style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.black54,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: isDark ? Colors.white30 : Colors.black26,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 14),

        // Habits Done Glance Card
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(16),
            onTap: () => c.openTool(AppRoutes.habitTracker),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: AppColors.coral.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_fire_department_rounded,
                        color: AppColors.coral,
                        size: 20,
                      ),
                    ),
                    Obx(() {
                      final total = c.totalHabits.value;
                      final done = c.habitsDoneToday.value;
                      final pct = total > 0 ? ((done / total) * 100).toInt() : 0;
                      return Text(
                        '$pct%',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.coral,
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 14),
                Obx(
                  () => Text(
                    '${c.habitsDoneToday.value} / ${c.totalHabits.value}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 21,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Habits Done',
                      style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.black54,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: isDark ? Colors.white30 : Colors.black26,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // ALL TOOLS TAB
  // ==========================================
  Widget _buildAllTools(BuildContext context, HomeController c, bool isDark) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildSectionHeader(
          context,
          isDark,
          'All Utilities',
          'Explore your daily toolkit',
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final tool = c.tools[index];
                return Obx(
                  () => WideToolCard(
                    title: tool.title,
                    subtitle: tool.subtitle,
                    icon: tool.icon,
                    gradient: tool.gradient,
                    onTap: () => c.openTool(tool.route),
                    isFavorite: c.isFavorite(tool.route),
                    onFavoriteTap: () => c.toggleFavorite(tool.route),
                  ),
                );
              },
              childCount: c.tools.length,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // FAVORITES TAB
  // ==========================================
  Widget _buildFavorites(BuildContext context, HomeController c, bool isDark) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildSectionHeader(
          context,
          isDark,
          'Favorites',
          'Quick access to your starred tools',
        ),
        Obx(() {
          final favs = c.favoriteToolsList;
          if (favs.isEmpty) {
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 80, left: 24, right: 24),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.black.withValues(alpha: 0.04),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite_border_rounded,
                          size: 56,
                          color: isDark ? Colors.white30 : Colors.black26,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No favorites pinned yet',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the heart icon on any tool to pin it here for instant access.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark ? Colors.white54 : Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final tool = favs[index];
                  return HeroToolCard(
                    title: tool.title,
                    icon: tool.icon,
                    gradient: tool.gradient,
                    onTap: () => c.openTool(tool.route),
                    isFavorite: true,
                    onFavoriteTap: () => c.toggleFavorite(tool.route),
                  );
                },
                childCount: favs.length,
              ),
            ),
          );
        }),
      ],
    );
  }

  // ==========================================
  // STATS & MISSION CONTROL TAB
  // ==========================================
  Widget _buildStats(BuildContext context, HomeController c, bool isDark) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildSectionHeader(
          context,
          isDark,
          'Mission Control',
          'Your daily wellness & productivity score',
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                // Glowing Ring Card
                GlassCard(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: (isDark
                                            ? AppColors.lime
                                            : AppColors.violet)
                                        .withValues(alpha: 0.18),
                                    blurRadius: 50,
                                    spreadRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                            Obx(() {
                              double waterRatio = c.waterGoal.value > 0
                                  ? (c.waterIntake.value / c.waterGoal.value)
                                      .clamp(0.0, 1.0)
                                  : 0;
                              double habitRatio = c.totalHabits.value > 0
                                  ? (c.habitsDoneToday.value /
                                          c.totalHabits.value)
                                      .clamp(0.0, 1.0)
                                  : 0;
                              double overall = (waterRatio + habitRatio) / 2;
                              return CircularProgressIndicator(
                                value: overall,
                                backgroundColor: isDark
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : Colors.black.withValues(alpha: 0.08),
                                color:
                                    isDark ? AppColors.lime : AppColors.violet,
                                strokeWidth: 15,
                                strokeCap: StrokeCap.round,
                              );
                            }),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.rocket_launch_rounded,
                                  color: isDark
                                      ? AppColors.lime
                                      : AppColors.violet,
                                  size: 34,
                                ),
                                const SizedBox(height: 6),
                                Obx(() {
                                  double waterRatio = c.waterGoal.value > 0
                                      ? (c.waterIntake.value /
                                              c.waterGoal.value)
                                          .clamp(0.0, 1.0)
                                      : 0;
                                  double habitRatio = c.totalHabits.value > 0
                                      ? (c.habitsDoneToday.value /
                                              c.totalHabits.value)
                                          .clamp(0.0, 1.0)
                                      : 0;
                                  double overall =
                                      (waterRatio + habitRatio) / 2;
                                  return Text(
                                    '${(overall * 100).toInt()}%',
                                    style: const TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -1.5,
                                    ),
                                  );
                                }),
                                Text(
                                  'Daily Score',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark
                                        ? Colors.white60
                                        : Colors.black54,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Detailed Progress Bars
                GlassCard(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.water_drop_rounded,
                                color: AppColors.mint,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Hydration Progress',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Obx(
                            () => Text(
                              '${c.waterIntake.value} / ${c.waterGoal.value} ml',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Obx(
                        () => ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: c.waterGoal.value > 0
                                ? (c.waterIntake.value / c.waterGoal.value)
                                    .clamp(0.0, 1.0)
                                : 0,
                            minHeight: 10,
                            backgroundColor: isDark
                                ? Colors.white10
                                : Colors.black.withValues(alpha: 0.08),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.mint,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.local_fire_department_rounded,
                                color: AppColors.coral,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Habits Completed',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Obx(
                            () => Text(
                              '${c.habitsDoneToday.value} / ${c.totalHabits.value} done',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Obx(
                        () => ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: c.totalHabits.value > 0
                                ? (c.habitsDoneToday.value /
                                        c.totalHabits.value)
                                    .clamp(0.0, 1.0)
                                : 0,
                            minHeight: 10,
                            backgroundColor: isDark
                                ? Colors.white10
                                : Colors.black.withValues(alpha: 0.08),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.coral,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // SECTION HEADER HELPER
  // ==========================================
  Widget _buildSectionHeader(
    BuildContext context,
    bool isDark,
    String title,
    String subtitle,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 56, 22, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                    color: isDark ? Colors.white : Colors.black,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white54 : Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // FLOATING BOTTOM NAVIGATION BAR
  // ==========================================
  Widget _buildFloatingNavBar(
    BuildContext context,
    HomeController c,
    bool isDark,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(35),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF161C2C).withValues(alpha: 0.85)
                : Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(35),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.12)
                  : Colors.black.withValues(alpha: 0.08),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                blurRadius: 24,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                c,
                0,
                Icons.dashboard_rounded,
                Icons.dashboard_outlined,
                'Home',
              ),
              _buildNavItem(
                context,
                c,
                1,
                Icons.grid_view_rounded,
                Icons.grid_view_outlined,
                'Tools',
              ),
              _buildNavItem(
                context,
                c,
                2,
                Icons.favorite_rounded,
                Icons.favorite_outline_rounded,
                'Favorites',
              ),
              _buildNavItem(
                context,
                c,
                3,
                Icons.donut_large_rounded,
                Icons.donut_large_outlined,
                'Stats',
              ),
              _buildNavItem(
                context,
                c,
                4,
                Icons.settings_rounded,
                Icons.settings_outlined,
                'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    HomeController c,
    int index,
    IconData activeIcon,
    IconData inactiveIcon,
    String label,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final isSelected = c.currentIndex.value == index;
      final color = isSelected
          ? (isDark ? AppColors.lime : AppColors.violet)
          : (isDark ? Colors.white38 : Colors.black38);

      return GestureDetector(
        onTap: () => c.changeTab(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Icon(
                  isSelected ? activeIcon : inactiveIcon,
                  key: ValueKey<bool>(isSelected),
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 3,
                width: isSelected ? 14 : 0,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
