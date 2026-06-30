import 'package:flutter/widgets.dart';

/// View mode for [MarkdownLatexEditor].
enum MarkdownLatexViewMode {
  /// Raw Markdown editing mode.
  edit,

  /// Rendered preview mode.
  preview,
}

/// Controls [MarkdownLatexEditor] state: content, mode, and preview options.
class MarkdownLatexEditorController extends ChangeNotifier {
  /// Creates a controller with optional initial content and settings.
  MarkdownLatexEditorController({
    String initialData = '',
    MarkdownLatexViewMode mode = MarkdownLatexViewMode.preview,
    bool selectable = true,
  })  : _data = initialData,
        _mode = mode,
        _selectable = selectable {
    _textController = TextEditingController(text: initialData);
    _textController.addListener(_handleTextChanged);
  }

  String _data;
  MarkdownLatexViewMode _mode;
  bool _selectable;
  int _previewEpoch = 0;
  late final TextEditingController _textController;

  /// Text controller bound to the edit pane.
  TextEditingController get textController => _textController;

  /// Current Markdown source text.
  String get data => _data;

  /// Active view mode (edit or preview).
  MarkdownLatexViewMode get mode => _mode;

  /// Whether preview text can be selected by the user.
  bool get selectable => _selectable;

  /// Increments when [selectable] changes to force preview rebuild.
  int get previewEpoch => _previewEpoch;

  /// `true` when [mode] is [MarkdownLatexViewMode.edit].
  bool get isEditMode => _mode == MarkdownLatexViewMode.edit;

  /// `true` when [mode] is [MarkdownLatexViewMode.preview].
  bool get isPreviewMode => _mode == MarkdownLatexViewMode.preview;

  /// Updates the Markdown source text.
  void setData(String value) {
    if (_data == value) return;
    _data = value;
    if (_textController.text != value) {
      _textController
        ..removeListener(_handleTextChanged)
        ..text = value
        ..addListener(_handleTextChanged);
    }
    notifyListeners();
  }

  void _handleTextChanged() {
    final value = _textController.text;
    if (_data == value) return;
    _data = value;
    notifyListeners();
  }

  /// Switches between edit and preview modes.
  void setMode(MarkdownLatexViewMode value) {
    if (_mode == value) return;
    _mode = value;
    notifyListeners();
  }

  /// Toggles between edit and preview modes.
  void toggleMode() {
    setMode(
      isEditMode
          ? MarkdownLatexViewMode.preview
          : MarkdownLatexViewMode.edit,
    );
  }

  /// Enables or disables text selection in preview mode.
  void setSelectable(bool value) {
    if (_selectable == value) return;
    _selectable = value;
    _previewEpoch++;
    notifyListeners();
  }

  /// Toggles text selection in preview mode.
  void toggleSelectable() => setSelectable(!_selectable);

  @override
  void dispose() {
    _textController
      ..removeListener(_handleTextChanged)
      ..dispose();
    super.dispose();
  }
}
