/// Mode of a conversation.
enum ConversationMode {
  /// Permanent conversation with no expiry.
  standard,

  /// Temporary conversation that expires after a period of time.
  ephemeral;

  static ConversationMode fromString(String value) {
    switch (value) {
      case 'standard':
        return ConversationMode.standard;
      case 'ephemeral':
        return ConversationMode.ephemeral;
      default:
        return ConversationMode.standard;
    }
  }
}
