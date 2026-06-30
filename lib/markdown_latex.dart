/// **markdown_latex** — Flutter Markdown + LaTeX mixed renderer.
///
/// Render GitHub-Flavored Markdown and LaTeX math in a single, polished view.
/// Notion / GitHub inspired typography, syntax-highlighted code blocks,
/// task lists, tables, and a built-in edit/preview editor.
///
/// ## Quick start
///
/// ```dart
/// import 'package:markdown_latex/markdown_latex.dart';
///
/// MarkdownLatex(
///   data: r'# Hello\n\nEnergy: $E=mc^2$',
///   theme: MarkdownLatexTheme.light(),
/// )
/// ```
///
/// See [MarkdownLatex], [MarkdownLatexTheme], and [MarkdownLatexEditor].
library;

export 'src/markdown_latex_view.dart';
export 'src/theme.dart';
export 'src/editor/markdown_latex_editor.dart';
export 'src/editor/markdown_latex_editor_controller.dart';
