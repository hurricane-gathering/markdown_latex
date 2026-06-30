import 'package:markdown_latex/markdown_latex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MarkdownLatex', () {
    testWidgets('renders without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: MarkdownLatex(data: '# Hello'),
            ),
          ),
        ),
      );
      expect(find.byType(MarkdownLatex), findsOneWidget);
    });

    testWidgets('renders inline and block math', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: MarkdownLatex(
                data: r'Inline $E=mc^2$ and block: $$\int_0^1 x\,dx$$',
                theme: MarkdownLatexTheme.light(),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(MarkdownLatex), findsOneWidget);
    });

    testWidgets('renders with light theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: MarkdownLatex(
                data: '**bold** and `code`',
                theme: MarkdownLatexTheme.light(),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(MarkdownLatex), findsOneWidget);
    });

    testWidgets('renders with dark theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: MarkdownLatex(
                data: '# Dark\n\n> Blockquote',
                theme: MarkdownLatexTheme.dark(),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(MarkdownLatex), findsOneWidget);
    });
  });

  group('MarkdownLatexTheme', () {
    test('light theme has correct brightness', () {
      final theme = MarkdownLatexTheme.light();
      expect(theme.brightness, Brightness.light);
      expect(theme.isDark, isFalse);
      expect(theme.mathBackground, isNotNull);
    });

    test('dark theme has correct brightness', () {
      final theme = MarkdownLatexTheme.dark();
      expect(theme.brightness, Brightness.dark);
      expect(theme.isDark, isTrue);
    });
  });

  group('MarkdownLatexEditorController', () {
    test('updates data and mode', () {
      final controller = MarkdownLatexEditorController(
        initialData: 'hello',
        mode: MarkdownLatexViewMode.edit,
      );
      addTearDown(controller.dispose);

      controller.setData('world');
      expect(controller.data, 'world');
      expect(controller.textController.text, 'world');

      controller.setMode(MarkdownLatexViewMode.preview);
      expect(controller.isPreviewMode, isTrue);

      controller.toggleSelectable();
      expect(controller.selectable, isFalse);
      expect(controller.previewEpoch, 1);
    });
  });
}
