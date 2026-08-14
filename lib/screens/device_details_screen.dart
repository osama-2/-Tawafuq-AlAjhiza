
import 'package:flutter/material.dart';
import '../models/catalog_models.dart';

class DeviceDetailsScreen extends StatelessWidget {
  final DeviceItem device;
  final String? initialCategory;

  const DeviceDetailsScreen({
    super.key,
    required this.device,
    this.initialCategory,
  });

  @override
  Widget build(BuildContext context) {
    final parts = initialCategory == null
        ? device.parts
        : device.parts.where((p) => p.category == initialCategory).toList();

    return Scaffold(
      appBar: AppBar(title: Text('${device.brand} ${device.model}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1677FF), Color(0xFF5BA8FF)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${device.brand} ${device.model}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 7),
                if (device.modelNumbers.isNotEmpty)
                  Text('رقم الإصدار: ${device.modelNumbers.join(" / ")}',
                      style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 12),
                const Text(
                  'لا يظهر أي توافق على أنه مؤكد إلا بعد ربطه بمصدر ومراجعة فنية.',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ...parts.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  child: ExpansionTile(
                    shape: const Border(),
                    title: Text(p.name,
                        style: const TextStyle(fontWeight: FontWeight.w900)),
                    subtitle: Text(
                      '${p.category}${p.partNumber.isEmpty ? "" : " • ${p.partNumber}"}',
                    ),
                    childrenPadding:
                        const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      if (p.partNumber.isNotEmpty)
                        _row('رقم القطعة', p.partNumber),
                      if (p.compatibility.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline,
                                  size: 18, color: Colors.orange),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'لا توجد توافقات معتمدة لهذه القطعة في النسخة الحالية.',
                                ),
                              )
                            ],
                          ),
                        ),
                      ...p.compatibility.map((c) => Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F8FB),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.targetDevice,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900)),
                                const SizedBox(height: 5),
                                Text(
                                  'الحالة: ${_status(c.status)} • الثقة: ${c.confidence}%',
                                  style: TextStyle(
                                    color: _statusColor(c.status),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (c.note.isNotEmpty) ...[
                                  const SizedBox(height: 5),
                                  Text(c.note,
                                      style: const TextStyle(fontSize: 12)),
                                ],
                                if (c.sources.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text('المصادر: ${c.sources.join("، ")}',
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.black54)),
                                ],
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  static String _status(String s) {
    switch (s) {
      case 'confirmed':
        return 'مؤكد';
      case 'tested':
        return 'مجرّب';
      case 'likely':
        return 'محتمل';
      case 'incompatible':
        return 'غير متوافق';
      default:
        return 'غير موثق';
    }
  }

  static Color _statusColor(String s) {
    switch (s) {
      case 'confirmed':
        return Colors.green;
      case 'tested':
        return Colors.blue;
      case 'likely':
        return Colors.orange;
      case 'incompatible':
        return Colors.red;
      default:
        return Colors.black54;
    }
  }

  Widget _row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            SizedBox(
              width: 95,
              child: Text(k,
                  style: const TextStyle(color: Colors.black54, fontSize: 12)),
            ),
            Expanded(
                child: Text(v,
                    style: const TextStyle(fontWeight: FontWeight.w800))),
          ],
        ),
      );
}
