import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:utility_nest/app/modules/home/home_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    GetStorage.init();
    Get.put(HomeController());
  });

  tearDown(() {
    Get.reset();
  });

  test('HomeController initializes tools and greetings', () {
    final c = Get.find<HomeController>();

    // Verify all 8 utilities are registered
    expect(c.tools.length, equals(8));

    // Verify dynamic greeting is populated
    expect(c.greeting.isNotEmpty, isTrue);
    expect(c.greetingSubtitle.isNotEmpty, isTrue);

    // Verify day-wise quote is available
    expect(c.currentQuote.text.isNotEmpty, isTrue);
    expect(c.currentQuote.author.isNotEmpty, isTrue);

    // Verify search and category filtering
    c.selectCategory('Productivity');
    expect(c.filteredTools.every((t) => t.category == 'Productivity'), isTrue);

    c.selectCategory('All');
    c.searchQuery.value = 'Water';
    expect(c.filteredTools.length, equals(1));
    expect(c.filteredTools.first.title, equals('Water Tracker'));
  });
}
