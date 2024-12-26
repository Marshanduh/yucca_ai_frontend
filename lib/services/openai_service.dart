import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  static Future<String> fetchResponse(String prompt, String apiKey) async {
    const apiUrl = "https://api.openai.com/v1/chat/completions";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'system', 'content': 'You are a helpful assistant.'},
          {'role': 'user', 'content': prompt}
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to fetch response');
    }
  }
}
