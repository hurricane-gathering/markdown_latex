/// A high-quality Flutter Markdown + LaTeX renderer.
///
/// Supports GitHub-Flavored Markdown, inline and block LaTeX math formulas,
/// syntax-highlighted code blocks, task lists, tables, images, and links —
/// all with elegant Light / Dark theming.
///
/// ## Basic usage
///
/// ```dart
/// import 'package:markdown_latex/markdown_latex.dart';
///
/// MarkdownLatex(
///   data: '# Hello\n\nThis is **bold** and $E=mc^2$.',
///   theme: MarkdownLatexTheme.light(),
/// )
/// ```
///
/// See [MarkdownLatex] for the full API.
library;

export 'src/markdown_latex_view.dart';
export 'src/theme.dart';
export 'src/editor/markdown_latex_editor.dart';
export 'src/editor/markdown_latex_editor_controller.dart';
