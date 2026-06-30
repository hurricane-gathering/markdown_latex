import 'package:markdown_latex/markdown_latex.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const ExampleApp());

const String _kDemo = r'''
# MarkdownLatex Demo

> A Flutter component for rendering **Markdown + LaTeX** with elegant styling.
> Switch between **Edit** and **Preview** using the toolbar.

---

## Text Styles

Normal paragraph with comfortable line height.

**Bold** · *Italic* · ~~Strikethrough~~ · `inline code` · Emoji 🚀 🎉

---

## Code Block

```dart
MarkdownLatex(
  data: markdownText,
  theme: MarkdownLatexTheme.light(),
  onTapLink: (url) => print('Tapped: $url'),
)
```

## Math Formulas

Inline: $E = mc^2$ and $\int_0^\infty e^{-x}\,dx = 1$

Block display:

$$
\sum_{n=1}^{\infty} \frac{1}{n^2} = \frac{\pi^2}{6}
$$

## Task List

- [x] Markdown rendering
- [x] LaTeX math support
- [x] Syntax highlighting
- [x] Edit / Preview modes
- [ ] More themes

## Table

| Feature | Supported |
|---------|-----------|
| GFM     | ✅        |
| LaTeX   | ✅        |
| Themes  | ✅        |

## Blockquote

> "The best way to predict the future is to invent it."
> — Alan Kay
''';

class ExampleAppController extends ChangeNotifier {
  ExampleAppController()
      : editorController = MarkdownLatexEditorController(
          initialData: _kDemo,
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

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExampleAppController(),
      child: const _ExampleAppShell(),
    );
  }
}

class _ExampleAppShell extends StatelessWidget {
  const _ExampleAppShell();

  @override
  Widget build(BuildContext context) {
    return Selector<ExampleAppController, bool>(
      selector: (_, c) => c.isDark,
      builder: (context, isDark, _) {
        return MaterialApp(
          title: 'MarkdownLatex Example',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: const ExampleHomePage(),
        );
      },
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.read<ExampleAppController>();

    return Selector<ExampleAppController, MarkdownLatexTheme>(
      selector: (_, c) => c.markdownTheme,
      builder: (context, theme, _) {
        return Scaffold(
          backgroundColor: theme.background,
          appBar: AppBar(
            title: const Text('MarkdownLatex'),
            backgroundColor: theme.background,
            actions: [
              IconButton(
                icon: Icon(app.isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: app.toggleTheme,
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: MarkdownLatexEditor(
                      controller: app.editorController,
                      theme: theme,
                      toolbarBuilder: (context, t) =>
                          MarkdownLatexEditorToolbar(theme: t),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
