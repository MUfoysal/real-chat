import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/chat_repository.dart';
import '../../data/models/chat_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.currentUser,
    required this.otherUid,
    required this.otherName,
    this.otherEmail = '',
    this.otherPhotoUrl = '',
  });

  final User currentUser;
  final String otherUid;
  final String otherName;
  final String otherEmail;
  final String otherPhotoUrl;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatRepository _chatRepository = ChatRepository();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final Future<String> _conversationFuture;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _conversationFuture = _chatRepository.createOrGetConversation(
      currentUid: widget.currentUser.uid,
      otherUid: widget.otherUid,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String chatId) async {
    final text = _messageController.text.trim();

    if (text.isEmpty || _isSending) return;

    _messageController.clear();

    setState(() {
      _isSending = true;
    });

    try {
      await _chatRepository.sendMessage(
        chatId: chatId,
        senderUid: widget.currentUser.uid,
        text: text,
      );
    } catch (_) {
      if (!mounted) return;

      _messageController.text = text;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message could not be sent. Please try again.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  Widget _buildAvatar(ColorScheme colors) {
    final photoUrl = widget.otherPhotoUrl.trim();

    return CircleAvatar(
      backgroundColor: colors.primaryContainer,
      foregroundColor: colors.onPrimaryContainer,
      backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
      child: photoUrl.isEmpty
          ? Text(
              widget.otherName.trim().isNotEmpty
                  ? widget.otherName.trim()[0].toUpperCase()
                  : '?',
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          : null,
    );
  }

  Widget _buildMessageBubble(
    ChatMessage message,
    bool isMine,
    ColorScheme colors,
  ) {
    final bubbleColor = isMine
        ? colors.primary
        : colors.surfaceContainerHighest;
    final textColor = isMine ? colors.onPrimary : colors.onSurface;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMine ? 18 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: TextStyle(color: textColor, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.createdAt),
              style: TextStyle(
                color: textColor.withValues(alpha: 0.7),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(String chatId, ColorScheme colors) {
    return StreamBuilder<List<ChatMessage>>(
      stream: _chatRepository.messagesStream(chatId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Unable to load messages.'));
        }

        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data ?? [];

        if (messages.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 56,
                    color: colors.primary,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Start your conversation',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Send a message to ${widget.otherName}.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          reverse: true,
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[messages.length - 1 - index];
            final isMine = message.senderId == widget.currentUser.uid;

            return _buildMessageBubble(message, isMine, colors);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            _buildAvatar(colors),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.otherName.isNotEmpty
                        ? widget.otherName
                        : 'Unknown user',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (widget.otherEmail.isNotEmpty)
                    Text(
                      widget.otherEmail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<String>(
                future: _conversationFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Unable to open this conversation.'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return _buildMessageList(snapshot.data!, colors);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border(top: BorderSide(color: colors.outlineVariant)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) {
                        if (_conversationFuture case final future) {
                          future.then((chatId) {
                            if (mounted) _sendMessage(chatId);
                          });
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _isSending
                        ? null
                        : () async {
                            String chatId;

                            try {
                              chatId = await _conversationFuture;
                              debugPrint('Conversation loaded: $chatId');
                            } catch (error, stackTrace) {
                              debugPrint('CONVERSATION ERROR: $error');
                              debugPrintStack(stackTrace: stackTrace);

                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Conversation error: $error'),
                                ),
                              );
                              return;
                            }

                            if (!mounted) return;

                            debugPrint('Starting message send');
                            await _sendMessage(chatId);
                          },
                    icon: _isSending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
