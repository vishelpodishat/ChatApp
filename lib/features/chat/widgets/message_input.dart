import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSend;

  const MessageInput({super.key, required this.controller, required this.onSend});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateCanSend);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateCanSend);
    super.dispose();
  }

  void _updateCanSend() {
    final canSend = widget.controller.text.trim().isNotEmpty;
    if (canSend != _canSend) {
      setState(() {
        _canSend = canSend;
      });
    }
  }

  void _handleSend() {
    if (_canSend) {
      widget.onSend(widget.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [BoxShadow(offset: const Offset(0, -2), blurRadius: 4, color: Colors.black.withOpacity(0.1))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: widget.controller,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  onSubmitted: (_) => _handleSend(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: IconButton(
                onPressed: _canSend ? _handleSend : null,
                icon: Icon(Icons.send, color: _canSend ? Theme.of(context).colorScheme.primary : Colors.grey),
                style: IconButton.styleFrom(
                  backgroundColor: _canSend ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
