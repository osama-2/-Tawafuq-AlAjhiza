
import 'package:flutter/material.dart';
import '../services/catalog_service.dart';
import 'device_details_screen.dart';

class SearchScreen extends StatefulWidget {
  final CatalogService catalog;
  const SearchScreen({super.key, required this.catalog});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String q = '';

  @override
  Widget build(BuildContext context) {
    final results = widget.catalog.search(query: q);
    return Scaffold(
      appBar: AppBar(title: const Text('البحث الشامل')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              onChanged: (v) => setState(() => q = v),
              decoration: const InputDecoration(
                hintText: 'مثال: RMX، SM-A، iPhone 13، أو رقم البطارية',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: q.trim().isEmpty
                  ? const Center(
                      child: Text(
                        'تقدر تبحث باسم الجهاز، رقم الموديل،\nرقم إصدار البطارية أو رقم القطعة.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54),
                      ),
                    )
                  : ListView.separated(
                      itemCount: results.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final d = results[i];
                        return Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          child: ListTile(
                            title: Text('${d.brand} ${d.model}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900)),
                            subtitle: Text(
                              d.modelNumbers.isEmpty
                                  ? '${d.parts.length} قطعة'
                                  : '${d.modelNumbers.join(" / ")}\n${d.parts.length} قطعة',
                            ),
                            trailing: const Icon(Icons.chevron_left),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: DeviceDetailsScreen(device: d),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
