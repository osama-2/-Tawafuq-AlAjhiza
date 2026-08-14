
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../models/catalog_models.dart';

class RecognitionResult {
  final String rawText;
  final DeviceItem? device;
  RecognitionResult(this.rawText, this.device);
}

class RecognitionService {
  Future<RecognitionResult> recognizeLabel(
    String imagePath,
    List<DeviceItem> devices,
  ) async {
    final input = InputImage.fromFilePath(imagePath);
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final result = await recognizer.processImage(input);
      final text = result.text.toLowerCase();

      DeviceItem? best;
      int bestScore = 0;

      for (final d in devices) {
        var score = 0;
        final tokens = [
          d.brand,
          d.model,
          ...d.modelNumbers,
          ...d.aliases,
        ];
        for (final token in tokens) {
          final t = token.toLowerCase().trim();
          if (t.length >= 3 && text.contains(t)) score += 10 + t.length;
        }
        if (score > bestScore) {
          bestScore = score;
          best = d;
        }
      }
      return RecognitionResult(result.text, bestScore > 0 ? best : null);
    } finally {
      await recognizer.close();
    }
  }
}
