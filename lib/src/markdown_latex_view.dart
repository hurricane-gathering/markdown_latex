import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

import 'builders/code_builder.dart';
import 'builders/math_builder.dart' show BlockMathBuilder, InlineMathBuilder;
import 'syntax/math_syntax.dart';
import 'theme.dart';

/// A Flutter widget that renders Markdown with LaTeX math support.
///
/// Wrap any Markdown string — including inline `$...$` and block `$$...$$`
/// LaTeX expressions — and get beautifully formatted output that matches the
/// visual quality of Notion or GitHub.
///
/// ## Example
///
/// ```dart
/// MarkdownLatex(
///   data: '''
/// # Hello World
///
/// This is **bold**, this is $E=mc^2$.
///
/// $$
/// \int_0^\infty e^{-x}\,dx = 1
/// $$
/// ''',
///   theme: MarkdownLatexTheme.dark(),
///   onTapLink: (url) => launchUrl(Uri.parse(url)),
/// )
/// ```
///
/// ## Scrollable documents
///
/// [MarkdownLatex] renders inline (non-scrolling). Wrap in a
/// [SingleChildScrollView] for scrollable documents:
///
/// ```dart
/// SingleChildScrollView(
///   child: MarkdownLatex(data: longDocument),
/// )
/// ```
class MarkdownLatex extends StatelessWidget {
  /// The Markdown source text to render.
  ///
  /// Supports GitHub-Flavored Markdown (GFM) plus LaTeX math:
  /// - Inline math: `$...$`
  /// - Display math (single line): `$$...$$`
  /// - Block math (multi-line): fenced `$$` blocks
  final String data;

  /// Visual theme for the rendered output.
  ///
  /// When `null`, the theme is auto-detected from [Theme.of(context).brightness]:
  /// - [Brightness.light] → [MarkdownLatexTheme.light]
  /// - [Brightness.dark]  → [MarkdownLatexTheme.dark]
  final MarkdownLatexTheme? theme;

  /// Called when the user taps a hyperlink in the rendered Markdown.
  ///
  /// The argument is the raw `href` string from the link.
  /// When `null`, links are opened with `url_launcher` automatically.
  final ValueChanged<String>? onTapLink;

  /// Padding around the rendered content.
  final EdgeInsetsGeometry padding;

  /// Whether the rendered text can be selected by the user.
  final bool selectable;

  /// Optional maximum width for the content area.
  ///
  /// When set, the content is constrained and centered horizontally —
  /// useful for reading-focused layouts (e.g. `maxWidth: 800`).
  final double? maxWidth;

  const MarkdownLatex({
    super.key,
    required this.data,
    this.theme,
    this.onTapLink,
    this.padding = const EdgeInsets.all(0),
    this.selectable = false,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final t = theme ??
        (Theme.of(context).brightness == Brightness.dark
            ? MarkdownLatexTheme.dark()
            : MarkdownLatexTheme.light());

    Widget body = MarkdownBody(
      data: data,
      selectable: selectable,
      extensionSet: _buildExtensionSet(),
      builders: {
        'pre': CodeBlockBuilder(theme: t),
        'inlinemath': InlineMathBuilder(theme: t),
        'displaymath': InlineMathBuilder(theme: t),
        'blockmath': BlockMathBuilder(theme: t),
      },
      styleSheet: _buildStyleSheet(context, t),
      onTapLink: (text, href, title) {
        if (href == null) return;
        onTapLink != null ? onTapLink!(href) : _openUrl(href);
      },
      checkboxBuilder: (checked) => _CheckboxIcon(checked: checked, theme: t),
      sizedImageBuilder: (config) =>
          _MarkdownImage(uri: config.uri, alt: config.alt, theme: t),
      fitContent: false,
      softLineBreak: true,
    );

    if (maxWidth != null) {
      body = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth!),
          child: body,
        ),
      );
    }

    if (padding != EdgeInsets.zero) {
      body = Padding(padding: padding, child: body);
    }

    return body;
  }

  // ─── Extension Set ────────────────────────────────────────────────────────

  md.ExtensionSet _buildExtensionSet() {
    return md.ExtensionSet(
      [
        ...md.ExtensionSet.gitHubFlavored.blockSyntaxes,
        BlockMathSyntax(),
      ],
      [
        ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
        InlineMathSyntax(),
      ],
    );
  }

  // ─── Style Sheet ─────────────────────────────────────────────────────────

  MarkdownStyleSheet _buildStyleSheet(
      BuildContext context, MarkdownLatexTheme t) {
    final body = TextStyle(
      color: t.onSurface,
      fontSize: 16,
      height: 1.8,
      letterSpacing: 0.1,
      fontFeatures: const [FontFeature.proportionalFigures()],
    );

    return MarkdownStyleSheet(
      // ── 段落
      p: body,
      pPadding: const EdgeInsets.only(bottom: 8),

      // ── 标题（层级分明，Notion 风格间距）
      h1: body.copyWith(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.4,
      ),
      h1Padding: const EdgeInsets.fromLTRB(0, 32, 0, 14),
      h2: body.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.2,
      ),
      h2Padding: const EdgeInsets.fromLTRB(0, 26, 0, 10),
      h3: body.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.35,
      ),
      h3Padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
      h4: body.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      h4Padding: const EdgeInsets.fromLTRB(0, 16, 0, 6),
      h5: body.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.45,
      ),
      h5Padding: const EdgeInsets.fromLTRB(0, 12, 0, 4),
      h6: body.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: t.onSurface.withValues(alpha: 0.68),
        letterSpacing: 0.2,
      ),
      h6Padding: const EdgeInsets.fromLTRB(0, 10, 0, 4),

      // ── 行内样式
      strong: body.copyWith(fontWeight: FontWeight.w700),
      em: body.copyWith(fontStyle: FontStyle.italic),
      del: body.copyWith(
        decoration: TextDecoration.lineThrough,
        color: t.onSurface.withValues(alpha: 0.55),
      ),

      // ── 行内代码
      code: TextStyle(
        fontFamily: 'monospace',
        fontSize: 13.5,
        color: t.inlineCodeColor,
        backgroundColor: t.codeBackground,
        height: 1.45,
        letterSpacing: 0,
      ),

      // ── 代码块容器（由 CodeBlockBuilder 接管）
      codeblockDecoration: const BoxDecoration(),
      codeblockPadding: EdgeInsets.zero,

      // ── 链接
      a: body.copyWith(
        color: t.primary,
        decoration: TextDecoration.underline,
        decorationColor: t.primary.withValues(alpha: 0.35),
      ),

      // ── 引用块
      blockquote: body.copyWith(
        color: t.onSurface.withValues(alpha: 0.72),
        fontStyle: FontStyle.italic,
        height: 1.7,
      ),
      blockquoteDecoration: BoxDecoration(
        color: t.blockquoteBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(color: t.blockquoteBorder, width: 3),
        ),
      ),
      blockquotePadding: const EdgeInsets.fromLTRB(18, 12, 16, 12),

      // ── 分割线
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: t.divider, width: 1.5),
        ),
      ),

      // ── 表格
      tableBorder: TableBorder(
        top: BorderSide(color: t.tableBorder),
        bottom: BorderSide(color: t.tableBorder),
        left: BorderSide(color: t.tableBorder),
        right: BorderSide(color: t.tableBorder),
        horizontalInside: BorderSide(color: t.tableBorder.withValues(alpha: 0.7)),
        verticalInside: BorderSide(color: t.tableBorder.withValues(alpha: 0.7)),
      ),
      tableHead: body.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 14.5,
        color: t.onSurface,
      ),
      tableBody: body.copyWith(fontSize: 14.5),
      tableHeadAlign: TextAlign.left,
      tableCellsPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      tableCellsDecoration: BoxDecoration(color: t.tableAltRowBackground),
      tableColumnWidth: const FlexColumnWidth(),
      tablePadding: const EdgeInsets.only(bottom: 4),

      // ── 列表
      listIndent: 26,
      listBullet: body.copyWith(
        color: t.onSurface.withValues(alpha: 0.55),
        fontSize: 15,
      ),
      listBulletPadding: const EdgeInsets.only(right: 8),

      // ── 全局间距
      blockSpacing: 12,
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  Future<void> _openUrl(String href) async {
    final uri = Uri.tryParse(href);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// ─── 任务列表复选框 ────────────────────────────────────────────────────────────

class _CheckboxIcon extends StatelessWidget {
  final bool checked;
  final MarkdownLatexTheme theme;

  const _CheckboxIcon({required this.checked, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6, top: 1),
      child: Icon(
        checked
            ? Icons.check_box_rounded
            : Icons.check_box_outline_blank_rounded,
        size: 18,
        color: checked
            ? theme.primary
            : theme.onSurface.withValues(alpha: 0.35),
      ),
    );
  }
}

// ─── 图片渲染（网络 + 占位） ───────────────────────────────────────────────────

class _MarkdownImage extends StatelessWidget {
  final Uri uri;
  final String? alt;
  final MarkdownLatexTheme theme;

  const _MarkdownImage({
    required this.uri,
    required this.alt,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          uri.toString(),
          fit: BoxFit.scaleDown,
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return _ImagePlaceholder(alt: alt, theme: theme, loading: true);
          },
          errorBuilder: (context, error, stackTrace) =>
              _ImagePlaceholder(alt: alt, theme: theme, loading: false),
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final String? alt;
  final MarkdownLatexTheme theme;
  final bool loading;

  const _ImagePlaceholder({
    required this.alt,
    required this.theme,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.divider),
      ),
      child: Center(
        child: loading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.primary,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.broken_image_outlined,
                    color: theme.onSurface.withValues(alpha: 0.35),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    alt ?? '图片加载失败',
                    style: TextStyle(
                      color: theme.onSurface.withValues(alpha: 0.45),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
