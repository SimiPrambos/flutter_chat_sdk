/// Mode of a conversation.
enum ConversationMode {
  /// Permanent conversation with no expiry.
  standard,

  /// Temporary conversation that may expire (has [Conversation.expiresAt]).
  ephemeral;

  static ConversationMode fromString(String value) {
    switch (value) {
      case 'standard':
      case 'legacy':
      case 'legacy_mode':
        return ConversationMode.standard;
      case 'ephemeral':
      case 'ghost':
      case 'ghost_mode':
        return ConversationMode.ephemeral;
      default:
        return ConversationMode.standard;
    }
  }
}
