import 'package:flutter_test/flutter_test.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_latex/src/syntax/math_syntax.dart';

void main() {
  final inlineExtensions = md.ExtensionSet(
    md.ExtensionSet.gitHubFlavored.blockSyntaxes,
    [...md.ExtensionSet.gitHubFlavored.inlineSyntaxes, InlineMathSyntax()],
  );

  final blockExtensions = md.ExtensionSet(
    [...md.ExtensionSet.gitHubFlavored.blockSyntaxes, BlockMathSyntax()],
    md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
  );

  group('InlineMathSyntax', () {
    test('parses inline math', () {
      final html = md.markdownToHtml(
        r'Inline $E=mc^2$ text',
        extensionSet: inlineExtensions,
      );
      expect(html, contains('inlinemath'));
      expect(html, contains('E=mc^2'));
    });

    test('parses single-line display math', () {
      final html = md.markdownToHtml(
        r'$$\frac{a}{b}$$',
        extensionSet: inlineExtensions,
      );
      expect(html, contains('displaymath'));
    });
  });

  group('BlockMathSyntax', () {
    test('parses multi-line block math', () {
      final html = md.markdownToHtml(
        r'''
$$
\int_0^1 x\,dx
$$
''',
        extensionSet: blockExtensions,
      );
      expect(html, contains('blockmath'));
      expect(html, contains(r'\int_0^1'));
    });
  });
}
