
class CompatibilityRecord {
  final String targetDevice;
  final String status;
  final int confidence;
  final String note;
  final List<String> sources;

  CompatibilityRecord({
    required this.targetDevice,
    required this.status,
    required this.confidence,
    required this.note,
    required this.sources,
  });

  factory CompatibilityRecord.fromJson(Map<String, dynamic> j) =>
      CompatibilityRecord(
        targetDevice: j['target_device'] ?? '',
        status: j['status'] ?? 'unverified',
        confidence: j['confidence'] ?? 0,
        note: j['note'] ?? '',
        sources: List<String>.from(j['sources'] ?? const []),
      );
}

class PartItem {
  final String id;
  final String category;
  final String name;
  final String partNumber;
  final List<String> aliases;
  final List<CompatibilityRecord> compatibility;

  PartItem({
    required this.id,
    required this.category,
    required this.name,
    required this.partNumber,
    required this.aliases,
    required this.compatibility,
  });

  factory PartItem.fromJson(Map<String, dynamic> j) => PartItem(
        id: j['id'],
        category: j['category'],
        name: j['name'],
        partNumber: j['part_number'] ?? '',
        aliases: List<String>.from(j['aliases'] ?? const []),
        compatibility: (j['compatibility'] as List? ?? const [])
            .map((e) => CompatibilityRecord.fromJson(e))
            .toList(),
      );
}

class DeviceItem {
  final String id;
  final String brand;
  final String model;
  final List<String> modelNumbers;
  final List<String> aliases;
  final List<PartItem> parts;

  DeviceItem({
    required this.id,
    required this.brand,
    required this.model,
    required this.modelNumbers,
    required this.aliases,
    required this.parts,
  });

  factory DeviceItem.fromJson(Map<String, dynamic> j) => DeviceItem(
        id: j['id'],
        brand: j['brand'],
        model: j['model'],
        modelNumbers: List<String>.from(j['model_numbers'] ?? const []),
        aliases: List<String>.from(j['aliases'] ?? const []),
        parts: (j['parts'] as List? ?? const [])
            .map((e) => PartItem.fromJson(e))
            .toList(),
      );

  bool matches(String q) {
    final s = q.toLowerCase().trim();
    if (s.isEmpty) return true;
    final deviceText = [
      brand, model, ...modelNumbers, ...aliases,
      ...parts.expand((p) => [p.name, p.partNumber, ...p.aliases]),
    ].join(' ').toLowerCase();
    return deviceText.contains(s);
  }
}
