import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Manages the transient "copied" feedback state for a code block copy action.
class CodeCopyNotifier extends ChangeNotifier {
  bool _copied = false;
  Timer? _resetTimer;

  /// Whether the copy action was recently triggered.
  bool get copied => _copied;

  /// Copies [text] to the clipboard and shows temporary success feedback.
  Future<void> copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    _copied = true;
    notifyListeners();
    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(seconds: 2), () {
      _copied = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }
}
