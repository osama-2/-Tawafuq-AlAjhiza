
import 'package:flutter/material.dart';
import '../services/catalog_service.dart';
import 'device_details_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  final CatalogService catalog;

  const CategoryScreen({
    super.key,
    required this.category,
    required this.catalog,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String? brand;
  String q = '';

  @override
  Widget build(BuildContext context) {
    final brands = widget.catalog.brands(category: widget.category);
    final devices = widget.catalog.search(
      query: q,
      category: widget.category,
      brand: brand,
    );

    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            onChanged: (v) => setState(() => q = v),
            decoration: InputDecoration(
              hintText: 'ابحث باسم الجهاز أو رقم الموديل أو رقم القطعة',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: q.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () => setState(() => q = ''),
                      icon: const Icon(Icons.close),
                    ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: const Text('كل الشركات'),
                    selected: brand == null,
                    onSelected: (_) => setState(() => brand = null),
                  ),
                ),
                ...brands.map((b) => Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: ChoiceChip(
                        label: Text(b),
                        selected: brand == b,
                        onSelected: (_) => setState(() => brand = b),
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('${devices.length} جهاز',
              style: const TextStyle(
                  fontWeight: FontWeight.w900, color: Colors.black54)),
          const SizedBox(height: 10),
          ...devices.map((d) {
            final parts = d.parts
                .where((p) => p.category == widget.category)
                .toList();
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(14),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF3FF),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.smartphone,
                        color: Color(0xFF1677FF)),
                  ),
                  title: Text('${d.brand} ${d.model}',
                      style: const TextStyle(fontWeight: FontWeight.w900)),
                  subtitle: Text([
                    if (d.modelNumbers.isNotEmpty) d.modelNumbers.join(' / '),
                    '${parts.length} نتيجة في ${widget.category}'
                  ].join('\n')),
                  isThreeLine: d.modelNumbers.isNotEmpty,
                  trailing: const Icon(Icons.chevron_left),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Directionality(
                        textDirection: TextDirection.rtl,
                        child: DeviceDetailsScreen(
                          device: d,
                          initialCategory: widget.category,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
          if (devices.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 70),
              child: Center(
                child: Text(
                  'لا توجد نتيجة في قاعدة البيانات حالياً.\nيمكن إضافتها بعد التحقق من المصدر.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
