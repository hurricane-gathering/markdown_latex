import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:markdown/markdown.dart' as md;

import '../theme.dart';

/// 处理 `inlinemath`（$...$）和 `displaymath`（$$...$$，单行）
class InlineMathBuilder extends MarkdownElementBuilder {
  final MarkdownLatexTheme theme;

  InlineMathBuilder({required this.theme});

  @override
  bool isBlockElement() => false;

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final latex = element.textContent.trim();
    final isDisplay = element.tag == 'displaymath';

    final textStyle = (preferredStyle ?? const TextStyle()).copyWith(
      color: theme.onSurface,
      fontSize: preferredStyle?.fontSize ?? 16,
    );

    final math = Math.tex(
      latex,
      mathStyle: isDisplay ? MathStyle.display : MathStyle.text,
      textStyle: textStyle,
      onErrorFallback: (err) => LatexErrorView(latex: latex, theme: theme),
    );

    if (isDisplay) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: math,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Baseline(
        baseline: (preferredStyle?.fontSize ?? 16) * 0.78,
        baselineType: TextBaseline.alphabetic,
        child: math,
      ),
    );
  }
}

/// 处理 `blockmath`（多行 $$...$$），显示为居中公式块
class BlockMathBuilder extends MarkdownElementBuilder {
  final MarkdownLatexTheme theme;

  BlockMathBuilder({required this.theme});

  @override
  bool isBlockElement() => true;

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final latex = element.textContent.trim();

    final textStyle = (preferredStyle ?? const TextStyle()).copyWith(
      color: theme.onSurface,
      fontSize: preferredStyle?.fontSize ?? 17,
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 14),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: theme.mathBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.mathBorder.withValues(alpha: 0.85),
        ),
      ),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Math.tex(
          latex,
          mathStyle: MathStyle.display,
          textStyle: textStyle,
          onErrorFallback: (err) => LatexErrorView(latex: latex, theme: theme),
        ),
      ),
    );
  }
}

/// LaTeX 解析失败时的降级展示。
class LatexErrorView extends StatelessWidget {
  final String latex;
  final MarkdownLatexTheme? theme;

  const LatexErrorView({super.key, required this.latex, this.theme});

  @override
  Widget build(BuildContext context) {
    final errorColor = theme?.isDark == true
        ? Colors.red.shade300
        : Colors.red.shade700;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: errorColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: errorColor.withValues(alpha: 0.28)),
      ),
      child: Text(
        latex,
        style: TextStyle(
          color: errorColor.withValues(alpha: 0.9),
          fontFamily: 'monospace',
          fontSize: 13,
          height: 1.4,
        ),
      ),
    );
  }
}
