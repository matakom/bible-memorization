import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/data/repositories/friendships_repository.dart';
import 'package:flutter_app/l10n/l10n_extension.dart';
import 'package:flutter_app/providers/friendships/friendships_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modal UI for entering a 6-digit friend code with automated focus management and keyboard handling.
class AddFriendModalContent extends ConsumerStatefulWidget {
  const AddFriendModalContent({super.key});

  @override
  ConsumerState<AddFriendModalContent> createState() => _AddFriendModalContentState();
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(text: newValue.text.toUpperCase(), selection: newValue.selection);
  }
}

class _AddFriendModalContentState extends ConsumerState<AddFriendModalContent> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<FocusNode> _keyboardFocusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    for (final kf in _keyboardFocusNodes) {
      kf.dispose();
    }
    super.dispose();
  }

  void _onChanged(int idx, String value) {
    if (value.length > 1) {
      final chars = value.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').split('');
      for (int i = 0; i < chars.length; i++) {
        if (idx + i < 6) {
          _controllers[idx + i].text = chars[i];
          _controllers[idx + i].selection = TextSelection.fromPosition(const TextPosition(offset: 1));
        }
      }
      int nextIdx = idx + chars.length;
      nextIdx >= 6 ? _focusNodes[5].requestFocus() : _focusNodes[nextIdx].requestFocus();
      setState(() {});
      return;
    }

    if (value.isNotEmpty && idx < 5) _focusNodes[idx + 1].requestFocus();
    setState(() {});
  }

  String get _friendCode => _controllers.map((c) => c.text).join();

  Future<void> _sendFriendRequest() async {
    final friendCode = _friendCode;
    if (friendCode.length < 6) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(friendshipsProvider.notifier).addFriendship(friendCode);
      if (mounted) Navigator.pop(context);
    } on FriendshipsException catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An unexpected error occurred.';
      });
    }
  }

  Widget _buildCodeField(int idx) {
    return SizedBox(
      width: 48,
      child: Focus(
        focusNode: _keyboardFocusNodes[idx],
        onKeyEvent: (FocusNode node, KeyEvent event) {
          if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
            if (_controllers[idx].text.isEmpty && idx > 0) {
              _focusNodes[idx - 1].requestFocus();
              _controllers[idx - 1].clear();
              setState(() {});
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: TextField(
          controller: _controllers[idx],
          textCapitalization: TextCapitalization.characters,
          focusNode: _focusNodes[idx],
          autofocus: idx == 0,
          textAlign: TextAlign.center,
          maxLength: 1,
          keyboardType: TextInputType.text,
          textInputAction: idx == 5 ? TextInputAction.done : TextInputAction.next,
          inputFormatters: [UpperCaseTextFormatter(), FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]'))],
          decoration: const InputDecoration(counterText: '', border: OutlineInputBorder()),
          onChanged: (value) => _onChanged(idx, value),
          onSubmitted: (_) { if (idx == 5) _sendFriendRequest(); },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.l10n.social_addFriend, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCodeField(0), const SizedBox(width: 8), _buildCodeField(1), const SizedBox(width: 8), _buildCodeField(2),
                const SizedBox(width: 16), const Text('-', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(width: 16),
                _buildCodeField(3), const SizedBox(width: 8), _buildCodeField(4), const SizedBox(width: 8), _buildCodeField(5),
              ],
            ),
            const SizedBox(height: 16),
            if (_errorMessage != null) Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(_errorMessage!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center)),
            ElevatedButton(
              onPressed: (_friendCode.length == 6 && !_isLoading) ? _sendFriendRequest : null,
              child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(context.l10n.social_sendRequest),
            ),
          ],
        ),
      ),
    );
  }
}