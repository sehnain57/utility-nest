import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';

class ToolItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final String route;
  final String category;

  ToolItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.route,
    required this.category,
  });
}

class QuoteItem {
  final String text;
  final String author;
  final String tag;

  QuoteItem({required this.text, required this.author, required this.tag});
}

class HomeController extends GetxController {
  final _box = GetStorage();

  final currentIndex = 0.obs;
  final favoriteRoutes = <String>{}.obs;

  // Search & Filtering
  final searchQuery = ''.obs;
  final selectedCategory = 'All'.obs;
  final searchController = TextEditingController();

  // Banner carousel
  final bannerIndex = 0.obs;

  // Quote index for cycling
  final currentQuoteIndex = 0.obs;

  final categories = const [
    'All',
    'Productivity',
    'Health',
    'Utilities',
    'Finance',
  ];

  final tools = <ToolItem>[
    ToolItem(
      title: 'World Clock',
      subtitle: 'Global time zones & city clocks',
      icon: Icons.public_rounded,
      gradient: AppColors.gradSky,
      route: AppRoutes.worldClock,
      category: 'Utilities',
    ),
    ToolItem(
      title: 'Habit Tracker',
      subtitle: 'Build daily streaks & consistency',
      icon: Icons.local_fire_department_rounded,
      gradient: AppColors.gradCoral,
      route: AppRoutes.habitTracker,
      category: 'Productivity',
    ),
    ToolItem(
      title: 'Water Tracker',
      subtitle: 'Hydration goal & glass logs',
      icon: Icons.water_drop_rounded,
      gradient: AppColors.gradMint,
      route: AppRoutes.waterTracker,
      category: 'Health',
    ),
    ToolItem(
      title: 'Random Picker',
      subtitle: 'Coin flip, dice & lucky wheel',
      icon: Icons.casino_rounded,
      gradient: AppColors.gradViolet,
      route: AppRoutes.randomPicker,
      category: 'Utilities',
    ),
    ToolItem(
      title: 'EMI Calculator',
      subtitle: 'Loan breakdown & interest charts',
      icon: Icons.account_balance_rounded,
      gradient: AppColors.gradDeep,
      route: AppRoutes.emiCalculator,
      category: 'Finance',
    ),
    ToolItem(
      title: 'Typing Test',
      subtitle: 'Real-time WPM & accuracy speed',
      icon: Icons.keyboard_rounded,
      gradient: AppColors.gradAmber,
      route: AppRoutes.typingTest,
      category: 'Productivity',
    ),
    ToolItem(
      title: 'Event Countdown',
      subtitle: 'Milestones & special dates',
      icon: Icons.event_rounded,
      gradient: AppColors.gradRose,
      route: AppRoutes.eventCountdown,
      category: 'Productivity',
    ),
    ToolItem(
      title: 'Device Info',
      subtitle: 'Hardware, battery & OS insights',
      icon: Icons.phone_android_rounded,
      gradient: AppColors.gradLime,
      route: AppRoutes.deviceInfo,
      category: 'Utilities',
    ),
  ];

  final waterProgress = 0.0.obs;
  final waterIntake = 0.obs;
  final waterGoal = 2000.obs;

  final totalHabits = 0.obs;
  final habitsDoneToday = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
    _loadStats();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // --- Greetings & Day-wise Logic ---
  int get currentHour => DateTime.now().hour;

  String get greeting {
    if (currentHour >= 5 && currentHour < 12) {
      return 'Good Morning';
    } else if (currentHour >= 12 && currentHour < 17) {
      return 'Good Afternoon';
    } else if (currentHour >= 17 && currentHour < 22) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  String get greetingEmoji {
    if (currentHour >= 5 && currentHour < 12) {
      return '☀️';
    } else if (currentHour >= 12 && currentHour < 17) {
      return '🌤️';
    } else if (currentHour >= 17 && currentHour < 22) {
      return '🌇';
    } else {
      return '🌙';
    }
  }

  IconData get greetingIcon {
    if (currentHour >= 5 && currentHour < 12) {
      return Icons.wb_sunny_rounded;
    } else if (currentHour >= 12 && currentHour < 17) {
      return Icons.wb_sunny_outlined;
    } else if (currentHour >= 17 && currentHour < 22) {
      return Icons.wb_twilight_rounded;
    } else {
      return Icons.bedtime_rounded;
    }
  }

  String get greetingSubtitle {
    if (currentHour >= 5 && currentHour < 12) {
      return 'Start fresh with focused energy today';
    } else if (currentHour >= 12 && currentHour < 17) {
      return 'Keep your momentum strong and steady';
    } else if (currentHour >= 17 && currentHour < 22) {
      return 'Celebrate your wins and unwind peacefully';
    } else {
      return 'Quiet your mind & recharge for tomorrow';
    }
  }

  String get greetingBadge {
    if (currentHour >= 5 && currentHour < 12) {
      return 'MORNING GLOW';
    } else if (currentHour >= 12 && currentHour < 17) {
      return 'PEAK FOCUS';
    } else if (currentHour >= 17 && currentHour < 22) {
      return 'GOLDEN HOUR';
    } else {
      return 'NIGHT CALM';
    }
  }

  List<QuoteItem> get _morningQuotes => [
    QuoteItem(
      text: 'Every morning gives us 24 brand new hours to make a difference.',
      author: 'Thich Nhat Hanh',
      tag: 'Fresh Start',
    ),
    QuoteItem(
      text: 'Small daily improvements over time lead to stunning results.',
      author: 'Robin Sharma',
      tag: 'Growth',
    ),
    QuoteItem(
      text: 'Smile in the mirror. Do that every morning and you will see a big difference.',
      author: 'Yoko Ono',
      tag: 'Mindset',
    ),
    QuoteItem(
      text: 'Your future is created by what you do today, not tomorrow.',
      author: 'Robert Kiyosaki',
      tag: 'Action',
    ),
  ];

  List<QuoteItem> get _afternoonQuotes => [
    QuoteItem(
      text: 'Focus is not about doing more; it is about eliminating distractions.',
      author: 'Cal Newport',
      tag: 'Deep Work',
    ),
    QuoteItem(
      text: 'It does not matter how slowly you go as long as you do not stop.',
      author: 'Confucius',
      tag: 'Perseverance',
    ),
    QuoteItem(
      text: 'Drink water, stretch your spine, and tackle the afternoon with clarity.',
      author: 'Wellness Daily',
      tag: 'Hydrate & Reset',
    ),
    QuoteItem(
      text: 'Momentum is created by action, not by waiting for inspiration.',
      author: 'James Clear',
      tag: 'Momentum',
    ),
  ];

  List<QuoteItem> get _eveningQuotes => [
    QuoteItem(
      text: 'Reflect on today\'s wins. Even small steps forward are milestones.',
      author: 'Marcus Aurelius',
      tag: 'Reflection',
    ),
    QuoteItem(
      text: 'The day’s work is done; unwind, disconnect, and enjoy the present.',
      author: 'Henry David Thoreau',
      tag: 'Unwind',
    ),
    QuoteItem(
      text: 'Peace of mind begins when you choose not to let others control your thoughts.',
      author: 'Epictetus',
      tag: 'Tranquility',
    ),
    QuoteItem(
      text: 'Be proud of the effort you gave today. Tomorrow brings new grace.',
      author: 'Maya Angelou',
      tag: 'Gratitude',
    ),
  ];

  List<QuoteItem> get _nightQuotes => [
    QuoteItem(
      text: 'Sleep is the best meditation. Let go of today and rest deeply.',
      author: 'Dalai Lama',
      tag: 'Deep Rest',
    ),
    QuoteItem(
      text: 'Tomorrow is a clean slate waiting for your best thoughts and actions.',
      author: 'Lao Tzu',
      tag: 'Renewal',
    ),
    QuoteItem(
      text: 'Rest is not idleness; it is the foundation of tomorrow\'s strength.',
      author: 'John Lubbock',
      tag: 'Recharge',
    ),
    QuoteItem(
      text: 'End each day with a thankful heart and a tranquil spirit.',
      author: 'Ralph Marston',
      tag: 'Serenity',
    ),
  ];

  QuoteItem get currentQuote {
    List<QuoteItem> list;
    if (currentHour >= 5 && currentHour < 12) {
      list = _morningQuotes;
    } else if (currentHour >= 12 && currentHour < 17) {
      list = _afternoonQuotes;
    } else if (currentHour >= 17 && currentHour < 22) {
      list = _eveningQuotes;
    } else {
      list = _nightQuotes;
    }
    return list[currentQuoteIndex.value % list.length];
  }

  void cycleQuote() {
    currentQuoteIndex.value++;
  }

  // --- Search & Filter ---
  List<ToolItem> get filteredTools {
    final query = searchQuery.value.trim().toLowerCase();
    final cat = selectedCategory.value;

    return tools.where((tool) {
      final matchesCategory = (cat == 'All' || tool.category == cat);
      final matchesQuery = query.isEmpty ||
          tool.title.toLowerCase().contains(query) ||
          tool.subtitle.toLowerCase().contains(query) ||
          tool.category.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  void selectCategory(String cat) {
    selectedCategory.value = cat;
  }

  // --- Quick Water Action from Banner ---
  void addQuickWater(int ml) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    waterIntake.value += ml;
    waterProgress.value = (waterIntake.value / waterGoal.value).clamp(0.0, 1.0);
    _box.write('water_intake_ml', waterIntake.value);
    _box.write('water_intake_date', today);

    Get.snackbar(
      'Hydration Logged! 💧',
      '+$ml ml added. Total: ${waterIntake.value} / ${waterGoal.value} ml',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF161C2C).withValues(alpha: 0.95),
      colorText: Colors.white,
      icon: const Icon(Icons.water_drop_rounded, color: AppColors.mint),
      margin: const EdgeInsets.only(bottom: 96, left: 20, right: 20),
      borderRadius: 16,
      duration: const Duration(seconds: 2),
    );
  }

  // --- Existing Favorites & Stats ---
  void _loadFavorites() {
    final list = _box.read<List>('favorite_tools');
    if (list != null) {
      favoriteRoutes.addAll(list.cast<String>());
    }
  }

  void toggleFavorite(String route) {
    if (favoriteRoutes.contains(route)) {
      favoriteRoutes.remove(route);
    } else {
      favoriteRoutes.add(route);
    }
    _box.write('favorite_tools', favoriteRoutes.toList());
  }

  bool isFavorite(String route) => favoriteRoutes.contains(route);

  List<ToolItem> get favoriteToolsList =>
      tools.where((t) => favoriteRoutes.contains(t.route)).toList();

  void _loadStats() {
    final savedDate = _box.read('water_intake_date');
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    waterGoal.value = _box.read('water_goal_ml') ?? 2000;

    if (savedDate == today) {
      waterIntake.value = _box.read('water_intake_ml') ?? 0;
    } else {
      waterIntake.value = 0;
    }
    waterProgress.value = (waterIntake.value / waterGoal.value).clamp(0.0, 1.0);

    final rawHabits = _box.read<String>('habits_list');
    if (rawHabits != null && rawHabits.isNotEmpty) {
      final decoded = jsonDecode(rawHabits) as List;
      totalHabits.value = decoded.length;
      habitsDoneToday.value = decoded.where((h) {
        final dates = h['completedDates'] as List?;
        return dates != null && dates.contains(today);
      }).length;
    }
  }

  void openTool(String route) {
    Get.toNamed(route)?.then((_) {
      _loadStats();
    });
  }

  void changeTab(int index) {
    currentIndex.value = index;
    if (index == 0 || index == 3) {
      _loadStats();
    }
  }
}
