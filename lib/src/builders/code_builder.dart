import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:provider/provider.dart';

import '../state/code_copy_notifier.dart';
import '../theme.dart';

/// 代码块渲染器：语法高亮 + 语言标签 + 一键复制
///
/// 注册到 builders['pre'] 以拦截所有围栏代码块。
class CodeBlockBuilder extends MarkdownElementBuilder {
  final MarkdownLatexTheme theme;

  CodeBlockBuilder({required this.theme});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final codeEl = element.children?.whereType<md.Element>().firstWhere(
          (e) => e.tag == 'code',
          orElse: () => md.Element.empty('code'),
        );

    final code = (codeEl ?? element).textContent.trimRight();
    final classAttr = codeEl?.attributes['class'] ?? '';
    final language = classAttr.startsWith('language-')
        ? classAttr.substring('language-'.length)
        : '';

    return ChangeNotifierProvider(
      create: (_) => CodeCopyNotifier(),
      child: _CodeBlockView(code: code, language: language, theme: theme),
    );
  }
}

class _CodeBlockView extends StatelessWidget {
  final String code;
  final String language;
  final MarkdownLatexTheme theme;

  const _CodeBlockView({
    required this.code,
    required this.language,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: theme.codeBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.divider.withValues(alpha: 0.55),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: theme.isDark ? 0.28 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CodeBlockHeader(code: code, language: language, theme: theme),
          _CodeBlockBody(code: code, language: language, theme: theme),
        ],
      ),
    );
  }
}

class _CodeBlockHeader extends StatelessWidget {
  final String code;
  final String language;
  final MarkdownLatexTheme theme;

  const _CodeBlockHeader({
    required this.code,
    required this.language,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: theme.isDark
            ? const Color(0xFF1C2128)
            : const Color(0xFFEAECEF),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(
          bottom: BorderSide(
            color: theme.divider.withValues(alpha: 0.45),
          ),
        ),
      ),
      child: Row(
        children: [
          if (language.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: theme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                language,
                style: TextStyle(
                  color: theme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'monospace',
                  letterSpacing: 0.2,
                ),
              ),
            ),
          const Spacer(),
          _CopyButton(code: code, theme: theme),
        ],
      ),
    );
  }
}

class _CodeBlockBody extends StatelessWidget {
  final String code;
  final String language;
  final MarkdownLatexTheme theme;

  const _CodeBlockBody({
    required this.code,
    required this.language,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        child: _buildHighlight(),
      ),
    );
  }

  Widget _buildHighlight() {
    if (language.isNotEmpty) {
      return HighlightView(
        code,
        language: _resolveLanguage(language),
        theme: theme.highlightTheme,
        padding: EdgeInsets.zero,
        textStyle: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
          height: 1.7,
        ),
      );
    }
    return Text(
      code,
      style: TextStyle(
        color: theme.codeForeground,
        fontFamily: 'monospace',
        fontSize: 14,
        height: 1.7,
      ),
    );
  }

  String _resolveLanguage(String lang) {
    const aliases = {
      'js': 'javascript',
      'ts': 'typescript',
      'py': 'python',
      'rb': 'ruby',
      'sh': 'bash',
      'zsh': 'bash',
      'yml': 'yaml',
      'kt': 'kotlin',
      'rs': 'rust',
    };
    return aliases[lang] ?? lang;
  }
}

class _CopyButton extends StatelessWidget {
  final String code;
  final MarkdownLatexTheme theme;

  const _CopyButton({required this.code, required this.theme});

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<CodeCopyNotifier>();

    return Selector<CodeCopyNotifier, bool>(
      selector: (_, n) => n.copied,
      builder: (context, copied, _) {
        return GestureDetector(
          onTap: () => notifier.copy(code),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Row(
              key: ValueKey(copied),
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  copied ? Icons.check_rounded : Icons.copy_rounded,
                  size: 15,
                  color: copied
                      ? Colors.green.shade400
                      : theme.onSurface.withValues(alpha: 0.45),
                ),
                const SizedBox(width: 4),
                Text(
                  copied ? '已复制' : '复制',
                  style: TextStyle(
                    fontSize: 12,
                    color: copied
                        ? Colors.green.shade400
                        : theme.onSurface.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
