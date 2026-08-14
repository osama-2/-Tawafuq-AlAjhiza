
import 'package:flutter/material.dart';
import '../services/catalog_service.dart';
import '../widgets/common_widgets.dart';
import 'category_screen.dart';
import 'search_screen.dart';
import 'camera_recognition_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final catalog = CatalogService();
  bool loading = true;

  static const sections = [
    ('الشاشات', 'LCD / OLED / Touch', Icons.smartphone),
    ('البطاريات', 'رقم البطارية والتوافقات', Icons.battery_full),
    ('الكاميرات', 'أمامية وخلفية', Icons.camera_alt_outlined),
    ('الشحن', 'بورد وفلاتة ومنفذ الشحن', Icons.bolt),
    ('السماعات', 'Earpiece / Loudspeaker', Icons.volume_up_outlined),
    ('المايكروفون', 'Mic / Flex / Modules', Icons.mic_none),
    ('الفلاتات', 'Power / Volume / Main Flex', Icons.cable),
    ('البصمة', 'Fingerprint Modules', Icons.fingerprint),
    ('الظهر والفريم', 'Back Cover / Housing', Icons.layers_outlined),
    ('اللزقات', 'Screen / Battery / Back Adhesive', Icons.grid_4x4),
    ('الشواحن', 'Adapters / Protocols', Icons.electrical_services),
    ('الكابلات', 'USB-C / Lightning وغيرها', Icons.usb),
  ];

  @override
  void initState() {
    super.initState();
    catalog.load().then((_) {
      if (mounted) setState(() => loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: const Row(
          children: [
            AppLogo(),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('توافقات الأجهزة',
                    style:
                        TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                Text('قاعدة توافق احترافية للفنيين',
                    style: TextStyle(fontSize: 11, color: Colors.black54)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Directionality(
                          textDirection: TextDirection.rtl,
                          child: SearchScreen(catalog: catalog),
                        ),
                      ),
                    ),
                    child: IgnorePointer(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'ابحث باسم الجهاز أو رقم الإصدار أو رقم القطعة',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: const Icon(Icons.tune),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Material(
                    color: const Color(0xFF1677FF),
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Directionality(
                            textDirection: TextDirection.rtl,
                            child: CameraRecognitionScreen(catalog: catalog),
                          ),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white24,
                              child:
                                  Icon(Icons.center_focus_strong, color: Colors.white),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('تعرّف على الجهاز بالكاميرا',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900)),
                                  SizedBox(height: 3),
                                  Text(
                                    'صوّر ملصق الجهاز أو رقم الموديل وسنبحث عنه تلقائياً',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_left, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('أقسام قطع الغيار',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 19)),
                      Text('اختر القسم',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 26),
            sliver: SliverGrid.builder(
              itemCount: sections.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.18,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, i) {
                final s = sections[i];
                return SectionTile(
                  title: s.$1,
                  subtitle: s.$2,
                  icon: s.$3,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Directionality(
                        textDirection: TextDirection.rtl,
                        child: CategoryScreen(
                          category: s.$1,
                          catalog: catalog,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavigationBar(
        selectedIndex: 0,
        destinations: [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'الرئيسية'),
          NavigationDestination(
              icon: Icon(Icons.compare_arrows), label: 'التوافقات'),
          NavigationDestination(
              icon: Icon(Icons.bookmark_border), label: 'المحفوظة'),
          NavigationDestination(
              icon: Icon(Icons.person_outline), label: 'حسابي'),
        ],
      ),
    );
  }
}
