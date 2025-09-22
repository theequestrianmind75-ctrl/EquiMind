import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class OpenAIClient {
  final Dio dio;

  OpenAIClient(this.dio);

  /// Generates a text response
  /// Sends a POST request to /chat/completions with messages and model.
  Future<Completion> createChatCompletion({
    required List<Message> messages,
    String model = 'gpt-4o',
    Map<String, dynamic>? options,
  }) async {
    try {
      final response = await dio.post(
        '/chat/completions',
        data: {
          'model': model,
          'messages': messages
              .map((m) => {
                    'role': m.role,
                    'content': m.content,
                  })
              .toList(),
          if (options != null) ...options,
        },
      );
      final text = response.data['choices'][0]['message']['content'];
      return Completion(text: text);
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['error']['message'] ?? e.message,
      );
    }
  }

  /// Streams a text response
  /// Uses server-sent events (SSE) from /chat/completions with stream=true.
  Stream<StreamCompletion> streamChatCompletion({
    required List<Message> messages,
    String model = 'gpt-4o',
    Map<String, dynamic>? options,
  }) async* {
    try {
      final response = await dio.post(
        '/chat/completions',
        data: {
          'model': model,
          'messages': messages
              .map((m) => {
                    'role': m.role,
                    'content': m.content,
                  })
              .toList(),
          'stream': true,
          if (options != null) ...options,
        },
        options: Options(responseType: ResponseType.stream),
      );

      final stream = response.data.stream;
      await for (var line
          in LineSplitter().bind(utf8.decoder.bind(stream.stream))) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6);
          if (data == '[DONE]') break;

          final json = jsonDecode(data) as Map<String, dynamic>;
          final delta = json['choices'][0]['delta'] as Map<String, dynamic>;
          final content = delta['content'] ?? '';
          final finishReason = json['choices'][0]['finish_reason'];
          final systemFingerprint = json['system_fingerprint'];

          yield StreamCompletion(
            content: content,
            finishReason: finishReason,
            systemFingerprint: systemFingerprint,
          );

          // If finish reason is provided, this is the final chunk
          if (finishReason != null) break;
        }
      }
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['error']['message'] ?? e.message,
      );
    }
  }

  // A more user-friendly wrapper for streaming that just yields content strings
  Stream<String> streamContentOnly({
    required List<Message> messages,
    String model = 'gpt-4o',
    Map<String, dynamic>? options,
  }) async* {
    await for (final chunk in streamChatCompletion(
      messages: messages,
      model: model,
      options: options,
    )) {
      if (chunk.content.isNotEmpty) {
        yield chunk.content;
      }
    }
  }

  /// List of available OpenAI models.
  /// Sends a GET request to /models to fetch model IDs.
  Future<List<String>> listModels() async {
    try {
      final response = await dio.get('/models');
      final models = response.data['data'] as List;
      return models.map((m) => m['id'] as String).toList();
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['error']['message'] ?? e.message,
      );
    }
  }

  /// Vision API (image analysis)
  /// Supports both imageUrl and local image files (as base64).
  Future<Completion> generateTextFromImage({
    String? imageUrl,
    Uint8List? imageBytes,
    String promptText = 'Describe the scene in this image:',
    String model = 'gpt-4o',
    Map<String, dynamic>? options,
  }) async {
    try {
      if (imageUrl == null && imageBytes == null) {
        throw ArgumentError('Either imageUrl or imageBytes must be provided');
      }

      final List<Map<String, dynamic>> content = [
        {'type': 'text', 'text': promptText},
      ];

      // Add image content based on what was provided
      if (imageUrl != null) {
        content.add({
          'type': 'image_url',
          'image_url': {'url': imageUrl}
        });
      } else if (imageBytes != null) {
        // Convert image bytes to base64
        final base64Image = base64Encode(imageBytes);
        content.add({
          'type': 'image_url',
          'image_url': {'url': 'data:image/jpeg;base64,$base64Image'}
        });
      }

      final messages = [
        Message(role: 'user', content: content),
      ];

      final response = await dio.post(
        '/chat/completions',
        data: {
          'model': model,
          'messages': messages
              .map((m) => {
                    'role': m.role,
                    'content': m.content,
                  })
              .toList(),
          if (options != null) ...options,
        },
      );

      final text = response.data['choices'][0]['message']['content'];
      return Completion(text: text);
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['error']['message'] ?? e.message,
      );
    }
  }

  /// DALL·E 3 image generation
  /// Returns result based on the specified response_format (url or b64_json).
  Future<ImageGenerationResult> generateImages({
    required String prompt,
    int n = 1,
    String size = '1024x1024',
    String model = 'dall-e-3',
    String responseFormat = 'url',
  }) async {
    try {
      final response = await dio.post(
        '/images/generations',
        data: {
          'model': model,
          'prompt': prompt,
          'n': n,
          'size': size,
          'response_format': responseFormat
        },
      );

      // Extract usage information if available
      final usage = response.data['usage'] as Map<String, dynamic>?;

      // Process image data based on response format
      final List data = response.data['data'];
      final List<GeneratedImage> images = [];

      for (var item in data) {
        if (responseFormat == 'url') {
          images.add(GeneratedImage(
            url: item['url'],
            base64Data: null,
          ));
        } else if (responseFormat == 'b64_json') {
          images.add(GeneratedImage(
            url: null,
            base64Data: item['b64_json'],
          ));
        }
      }

      return ImageGenerationResult(
        images: images,
        usage: usage != null ? UsageInfo.fromJson(usage) : null,
      );
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['error']['message'] ?? e.message,
      );
    }
  }

  // Convenience method to get only URLs from generateImages
  Future<List<String>> generateImageUrls({
    required String prompt,
    int n = 1,
    String size = '1024x1024',
    String model = 'dall-e-3',
  }) async {
    final result = await generateImages(
      prompt: prompt,
      n: n,
      size: size,
      model: model,
      responseFormat: 'url',
    );

    return result.images
        .where((img) => img.url != null)
        .map((img) => img.url!)
        .toList();
  }

  // Convenience method to get base64 data from generateImages
  Future<List<String>> generateImageBase64({
    required String prompt,
    int n = 1,
    String size = '1024x1024',
    String model = 'dall-e-3',
  }) async {
    final result = await generateImages(
      prompt: prompt,
      n: n,
      size: size,
      model: model,
      responseFormat: 'b64_json',
    );

    return result.images
        .where((img) => img.base64Data != null)
        .map((img) => img.base64Data!)
        .toList();
  }

  /// Text-to-Speech (TTS)
  /// Converts text to audio and saves it to a file.
  Future<File> createSpeech({
    required String input,
    String model = 'tts-1',
    String voice = 'alloy',
    String responseFormat = 'mp3',
    double? speed,
  }) async {
    try {
      final response = await dio.post(
        '/audio/speech',
        data: {
          'model': model,
          'input': input,
          'voice': voice,
          'response_format': responseFormat,
          if (speed != null) 'speed': speed,
        },
        options: Options(responseType: ResponseType.bytes),
      );

      // Save audio to a temporary file
      final tempDir = await getTemporaryDirectory();
      final fileExtension = responseFormat == 'opus' ? 'ogg' : responseFormat;
      final audioFile = File(
          '${tempDir.path}/speech_${DateTime.now().millisecondsSinceEpoch}.$fileExtension');
      await audioFile.writeAsBytes(response.data);

      return audioFile;
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['error']['message'] ?? e.message,
      );
    }
  }

  /// Speech-to-Text (STT)
  /// Transcribes audio to text using the Whisper model.
  Future<Transcription> transcribeAudio({
    required File audioFile,
    String model = 'whisper-1',
    String? prompt,
    String responseFormat = 'json',
    String? language,
    double? temperature,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          audioFile.path,
          filename: audioFile.path.split('/').last,
        ),
        'model': model,
        if (prompt != null) 'prompt': prompt,
        'response_format': responseFormat,
        if (language != null) 'language': language,
        if (temperature != null) 'temperature': temperature,
      });

      final response = await dio.post(
        '/audio/transcriptions',
        data: formData,
      );

      if (responseFormat == 'json') {
        return Transcription(text: response.data['text']);
      } else {
        return Transcription(text: response.data.toString());
      }
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['error']['message'] ?? e.message,
      );
    }
  }
}

/// Support classes
class Message {
  final String role;
  final dynamic content;

  Message({required this.role, required this.content});
}

class Completion {
  final String text;

  Completion({required this.text});
}

class StreamCompletion {
  final String content;
  final String? finishReason;
  final String? systemFingerprint;

  StreamCompletion({
    required this.content,
    this.finishReason,
    this.systemFingerprint,
  });
}

class GeneratedImage {
  final String? url;
  final String? base64Data;

  GeneratedImage({this.url, this.base64Data});

  // Convert base64 data to image bytes
  Uint8List? get imageBytes =>
      base64Data != null ? base64Decode(base64Data!) : null;
}

class UsageInfo {
  final int totalTokens;
  final int inputTokens;
  final int outputTokens;
  final Map<String, dynamic>? inputTokensDetails;

  UsageInfo({
    required this.totalTokens,
    required this.inputTokens,
    required this.outputTokens,
    this.inputTokensDetails,
  });

  factory UsageInfo.fromJson(Map<String, dynamic> json) {
    return UsageInfo(
      totalTokens: json['total_tokens'] ?? 0,
      inputTokens: json['input_tokens'] ?? 0,
      outputTokens: json['output_tokens'] ?? 0,
      inputTokensDetails: json['input_tokens_details'],
    );
  }
}

class ImageGenerationResult {
  final List<GeneratedImage> images;
  final UsageInfo? usage;

  ImageGenerationResult({required this.images, this.usage});
}

class Transcription {
  final String text;

  Transcription({required this.text});
}

class OpenAIException implements Exception {
  final int statusCode;
  final String message;

  OpenAIException({required this.statusCode, required this.message});

  @override
  String toString() => 'OpenAIException: $statusCode - $message';
}
