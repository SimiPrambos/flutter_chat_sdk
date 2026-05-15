import 'package:equatable/equatable.dart';

/// Content of a message, supporting both plain and encrypted forms.
class MessageContent extends Equatable {
  /// Creates message content.
  const MessageContent({
    this.plainText,
    this.cipherText,
    this.nonce,
  });

  /// Creates plain text content.
  const MessageContent.plain(String text)
      : plainText = text,
        cipherText = null,
        nonce = null;

  /// Creates encrypted content where plainText is not yet available.
  ///
  /// Used when real E2E encryption is in place and the message has not been
  /// decrypted yet. [displayText] will return `'[Encrypted message]'` until
  /// the content is decrypted and a new [MessageContent] is created with
  /// [plainText] set.
  // Adapters should use the default constructor with plainText set until
  // real E2E encryption is implemented on the backend side.
  const MessageContent.encrypted({
    required String this.cipherText,
    required String this.nonce,
  }) : plainText = null;

  /// Decrypted/plain text content.
  final String? plainText;

  /// Encrypted content (ciphertext).
  final String? cipherText;

  /// Encryption nonce.
  final String? nonce;

  /// Whether content is encrypted.
  bool get isEncrypted => cipherText != null && nonce != null;

  /// Display text (plain or placeholder if encrypted).
  String get displayText => plainText ?? '[Encrypted message]';

  /// Creates a copy with updated fields.
  MessageContent copyWith({
    String? plainText,
    String? cipherText,
    String? nonce,
  }) {
    return MessageContent(
      plainText: plainText ?? this.plainText,
      cipherText: cipherText ?? this.cipherText,
      nonce: nonce ?? this.nonce,
    );
  }

  @override
  List<Object?> get props => [plainText, cipherText, nonce];
}
