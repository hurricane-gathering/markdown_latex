import 'package:flutter/foundation.dart';

import '../editor/markdown_latex_editor_controller.dart';
import '../theme.dart';

/// Demo 应用全局状态：主题与编辑器控制器。
class DemoAppController extends ChangeNotifier {
  DemoAppController({required String initialMarkdown})
      : editorController = MarkdownLatexEditorController(
          initialData: initialMarkdown,
          mode: MarkdownLatexViewMode.preview,
          selectable: true,
        );

  final MarkdownLatexEditorController editorController;
  bool _isDark = false;

  bool get isDark => _isDark;

  MarkdownLatexTheme get markdownTheme =>
      _isDark ? MarkdownLatexTheme.dark() : MarkdownLatexTheme.light();

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  @override
  void dispose() {
    editorController.dispose();
    super.dispose();
  }
}
