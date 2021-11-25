import 'dart:convert' as ConvertPack;
import 'package:cryptography/cryptography.dart';

class EncUtil {
  static Future<String> mnemonicToKey(String mnemonic) async {
    final pdfk2 = Pbkdf2(macAlgorithm: Hmac.sha256(), iterations: 1000, bits: 256);
    final secretKey = await pdfk2.deriveKey(secretKey: SecretKey(mnemonic.codeUnits), nonce: []);
    final secretKeyData = await secretKey.extract();
    final stringKey = ConvertPack.base64Encode(secretKeyData.bytes);
    return stringKey;
  }
}
