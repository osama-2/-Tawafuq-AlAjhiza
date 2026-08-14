
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/catalog_models.dart';

class CatalogService {
  List<DeviceItem> _devices = [];

  List<DeviceItem> get devices => _devices;

  Future<void> load() async {
    final raw = await rootBundle.loadString('assets/data/catalog.json');
    final j = json.decode(raw) as Map<String, dynamic>;
    _devices = (j['devices'] as List)
        .map((e) => DeviceItem.fromJson(e))
        .toList();
  }

  List<String> brands({String? category}) {
    final set = <String>{};
    for (final d in _devices) {
      if (category == null || d.parts.any((p) => p.category == category)) {
        set.add(d.brand);
      }
    }
    final result = set.toList()..sort();
    return result;
  }

  List<DeviceItem> search({
    String query = '',
    String? category,
    String? brand,
  }) {
    return _devices.where((d) {
      final okBrand = brand == null || d.brand == brand;
      final okCategory =
          category == null || d.parts.any((p) => p.category == category);
      return okBrand && okCategory && d.matches(query);
    }).toList();
  }
}
