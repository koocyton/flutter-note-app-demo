import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:crypto/crypto.dart' as c;

class EncryptUtil {

  static String get md5salt => "S44DF#Q ^Y123DF ";

  static String get rsaPublicKey => "";

  static String saltMd5(String str) {
    return md5("$md5salt$str");
  }

  static String md5(String str) {
    return c.md5.convert(
      Utf8Encoder().convert(str)
    ).toString();
  }

  static String aesDec(String encrypted, String aesKey, String aesIV) {
    final key = Key.fromUtf8(aesKey);
    final iv = IV.fromUtf8(aesIV);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    Encrypted enBase64 = Encrypted.from64(encrypted);
    final decrypted = encrypter.decrypt(enBase64, iv: iv);
    return decrypted;
  }

  static String aesEnc(String value, String aesKey, String aesIV) {
    final key = Key.fromUtf8(aesKey); //hardcode
    final iv = IV.fromUtf8(aesIV); //hardcode
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(value, iv: iv);
    return encrypted.base64;
  }

  /// RSA加密算法加密，秘钥格式为[pkcs8]
  /// [content]明文
  /// [publicKeyPem]公钥
  static String rsaEncrypt(String content, String publicKeyPem) {
    RSAPublicKey publicKey = RSAKeyParser().parse(publicKeyPem) as RSAPublicKey;
    final encryptor = Encrypter(RSA(publicKey: publicKey));
    final encrypted = encryptor.encrypt(content);
    return encrypted.base64;
  }

  /// RSA加密算法解密，秘钥格式为[pkcs8]
  /// [encryptedStr]密文，base64编码
  /// [privateKeyPem]私钥
  static String rsaDecrypt(String encryptedStr, String privateKeyPem) {
    RSAPrivateKey privateKey = RSAKeyParser().parse(privateKeyPem) as RSAPrivateKey;
    final encryptor = Encrypter(RSA(privateKey: privateKey));
    final encrypted = Encrypted.fromBase64(encryptedStr);
    final decrypted = encryptor.decrypt(encrypted);
    return decrypted;
  }

  /// SHA256withRSA签名，秘钥格式为[pkcs8]
  /// [content]明文
  /// [privateKeyPem]私钥
  static String rsaSign(String content, String privateKeyPem) {
    RSAPrivateKey privateKey = RSAKeyParser().parse(privateKeyPem) as RSAPrivateKey;
    Signer signer = Signer(RSASigner(RSASignDigest.SHA256, privateKey: privateKey));
    return signer.sign(content).base64;
  }

  /// SHA256withRSA验签，秘钥格式为[pkcs8]
  /// [content]明文
  /// [signature]签名
  /// [publicKeyPem]PEM格式公钥
  static bool rsaVerifySign(String content, String signature, String publicKeyPem) {
    RSAPublicKey publicKey = RSAKeyParser().parse(publicKeyPem) as RSAPublicKey;
    Signer signer2 = Signer(RSASigner(RSASignDigest.SHA256, publicKey: publicKey));
    return signer2.verify(content, Encrypted.from64(signature));
  }
}