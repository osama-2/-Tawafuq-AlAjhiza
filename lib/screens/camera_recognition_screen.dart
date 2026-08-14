
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/catalog_service.dart';
import '../services/recognition_service.dart';
import 'device_details_screen.dart';

class CameraRecognitionScreen extends StatefulWidget {
  final CatalogService catalog;
  const CameraRecognitionScreen({super.key, required this.catalog});

  @override
  State<CameraRecognitionScreen> createState() =>
      _CameraRecognitionScreenState();
}

class _CameraRecognitionScreenState extends State<CameraRecognitionScreen> {
  final picker = ImagePicker();
  final recognizer = RecognitionService();

  XFile? image;
  bool busy = false;
  String rawText = '';
  dynamic matchedDevice;

  Future<void> pick(ImageSource source) async {
    final x = await picker.pickImage(
      source: source,
      imageQuality: 88,
      maxWidth: 1800,
    );
    if (x == null) return;

    setState(() {
      image = x;
      busy = true;
      rawText = '';
      matchedDevice = null;
    });

    try {
      final result =
          await recognizer.recognizeLabel(x.path, widget.catalog.devices);
      if (!mounted) return;
      setState(() {
        rawText = result.rawText;
        matchedDevice = result.device;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => rawText = 'تعذر تحليل الصورة: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التعرّف بالكاميرا')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'النسخة الأولى تتعرف على اسم/رقم الموديل المكتوب في الملصق أو الصورة. '
              'التعرف البصري من شكل الهاتف وحده مهيأ للربط بمحرك AI في النسخة التالية.',
              style: TextStyle(height: 1.5),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: busy ? null : () => pick(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('التقاط صورة'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: busy ? null : () => pick(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('من الصور'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                File(image!.path),
                height: 260,
                fit: BoxFit.cover,
              ),
            ),
          if (busy) ...[
            const SizedBox(height: 18),
            const LinearProgressIndicator(),
            const SizedBox(height: 8),
            const Text('جاري قراءة اسم ورقم الجهاز...'),
          ],
          if (!busy && matchedDevice != null) ...[
            const SizedBox(height: 16),
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              child: ListTile(
                contentPadding: const EdgeInsets.all(14),
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFEAF3FF),
                  child: Icon(Icons.verified, color: Color(0xFF1677FF)),
                ),
                title: Text(
                  '${matchedDevice.brand} ${matchedDevice.model}',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                subtitle: Text(
                  matchedDevice.modelNumbers.isEmpty
                      ? 'تم العثور على تطابق في القاعدة'
                      : 'رقم الإصدار: ${matchedDevice.modelNumbers.join(" / ")}',
                ),
                trailing: const Icon(Icons.chevron_left),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Directionality(
                      textDirection: TextDirection.rtl,
                      child: DeviceDetailsScreen(device: matchedDevice),
                    ),
                  ),
                ),
              ),
            ),
          ],
          if (!busy && image != null && matchedDevice == null) ...[
            const SizedBox(height: 16),
            const Text(
              'لم نجد تطابقاً مؤكداً في القاعدة. جرّب تصوير الملصق بوضوح أو استخدم البحث برقم الموديل.',
              style: TextStyle(color: Colors.black54, height: 1.5),
            ),
          ],
          if (rawText.isNotEmpty) ...[
            const SizedBox(height: 16),
            ExpansionTile(
              title: const Text('النص المقروء من الصورة'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SelectableText(rawText),
                )
              ],
            )
          ],
        ],
      ),
    );
  }
}
