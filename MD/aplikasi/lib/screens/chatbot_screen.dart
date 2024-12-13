import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ImagePicker _picker = ImagePicker();

  final String firstApiUrl = "http://34.28.27.190:5001/predict";
  final String geminiApiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent";

  void _sendMessage(String text, {String? imagePath}) async {
    if (text.isEmpty && imagePath == null) return;

    setState(() {
      if (text.isNotEmpty) {
        _messages.add({'text': text, 'isUser': true});
      }

      if (imagePath != null) {
        _messages.add({'image': imagePath, 'isUser': true});
      }
      _messageController.clear();
    });

    String detectedIntent = await _getDetectedIntent(text);

    String botResponse = await _getBotResponseFromGemini(detectedIntent, imagePath);

    setState(() {
      _messages.add({
        'text': botResponse,
        'isUser': false,
      });
    });
  }

  // Function to detect user intent via the first API
  Future<String> _getDetectedIntent(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse(firstApiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'text': userMessage}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData.containsKey('predicted_label')) {
          print('Predicted Label: ${responseData['predicted_label']}');
          return responseData['predicted_label'];
        } else {
          return 'Intent detection failed.';
        }
      } else {
        return 'Failed to detect intent.';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String> _getBotResponseFromGemini(
  String detectedIntent, String? imagePath) async {
    const prefix = 'Can you explain what';
    const suffix = 'sickness in cats is, what are the symptomps and how to treat them (don\'t use markdown format or asterisks, just use bullet points or dashes)';
    final geminiApiKey = dotenv.env['GEMINI_API_KEY'];

    if (geminiApiKey == null) {
      return 'Gemini API key not found.';
    }

    try {
      // Prepare the request body
      final body = json.encode({
        "contents": [
          {
            "parts": [
              {"text": '$prefix $detectedIntent $suffix'}
            ]
          }
        ]
      });

      // Call Gemini API
      final response = await http.post(
        Uri.parse('$geminiApiUrl?key=$geminiApiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData.containsKey('candidates') &&
            responseData['candidates'].isNotEmpty &&
            responseData['candidates'][0].containsKey('content') &&
            responseData['candidates'][0]['content'].containsKey('parts') &&
            responseData['candidates'][0]['content']['parts'].isNotEmpty &&
            responseData['candidates'][0]['content']['parts'][0].containsKey('text')) {
          return responseData['candidates'][0]['content']['parts'][0]['text'];
        } else {
          return 'Gemini API did not generate a response.';
        }

      } else {
        return 'Failed to get response from Gemini API. Status code: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _sendMessage('', imagePath: pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD0F0C0),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 56, 142, 60),
        title: const Text('Chat Bot'),
      ),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                final isUser = message['isUser'];

                if (message.containsKey('image')) {
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Image.file(
                        File(message['image']),
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color.fromARGB(255, 56, 142, 60)
                          : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(15),
                        topRight: const Radius.circular(15),
                        bottomLeft:
                            isUser ? const Radius.circular(15) : Radius.zero,
                        bottomRight:
                            isUser ? Radius.zero : const Radius.circular(15),
                      ),
                    ),
                    child: Text(
                      message['text'],
                      style: TextStyle(
                        color: isUser ? Colors.black : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Message Input
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image, color: Colors.black),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.black),
                  onPressed: () => _sendMessage(_messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
