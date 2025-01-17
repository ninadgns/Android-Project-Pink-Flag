import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EncryptionUtils {

  static final String? secretKey = dotenv.env['SECRET_KEY'] ;


  static String generateSHA256Hash(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }


  static String encryptText(String text) {
    if (text.isEmpty) return '';

    final keyBytes = utf8.encode(secretKey!);
    final textBytes = utf8.encode(text);
    final hash = sha256.convert(keyBytes);
    print(secretKey);

    List<int> encrypted = [];
    for (var i = 0; i < textBytes.length; i++) {
      encrypted.add(textBytes[i] ^ hash.bytes[i % hash.bytes.length]);
    }


    return base64.encode(encrypted);
  }


  static String decryptText(String encryptedText) {
    if (encryptedText.isEmpty) return '';

    try {
      final keyBytes = utf8.encode(secretKey!);
      final hash = sha256.convert(keyBytes);


      final encrypted = base64.decode(encryptedText);


      List<int> decrypted = [];
      for (var i = 0; i < encrypted.length; i++) {
        decrypted.add(encrypted[i] ^ hash.bytes[i % hash.bytes.length]);
      }

      return utf8.decode(decrypted);
    } catch (e) {
      return 'Error decrypting text: $e';
    }
  }
}