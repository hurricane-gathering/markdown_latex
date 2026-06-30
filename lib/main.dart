import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'markdown_latex.dart';
import 'src/demo/demo_app_controller.dart';
import 'src/demo_content.dart';

void main() {
  final controller = DemoAppController(initialMarkdown: kDemoMarkdown);
  runApp(ChangeNotifierProvider.value(value: controller, child: const App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<DemoAppController, bool>(
      selector: (_, c) => c.isDark,
      builder: (context, isDark, _) {
        return MaterialApp(
          title: 'MarkdownLatex Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: const DemoPage(),
        );
      },
    );
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<DemoAppController, MarkdownLatexTheme>(
      selector: (_, c) => c.markdownTheme,
      builder: (context, theme, _) {
        final demo = context.read<DemoAppController>();

        return Scaffold(
          backgroundColor: theme.background,
          appBar: _DemoAppBar(theme: theme),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: MarkdownLatexEditor(
                      controller: demo.editorController,
                      theme: theme,
                      onTapLink: (url) => debugPrint('Link tapped: $url'),
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

class _DemoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final MarkdownLatexTheme theme;

  const _DemoAppBar({required this.theme});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    final demo = context.read<DemoAppController>();

    return AppBar(
      backgroundColor: theme.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, color: theme.divider),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.article_outlined, color: theme.primary, size: 20),
          ),
          const SizedBox(width: 10),
          Text(
            'MarkdownLatex',
            style: TextStyle(
              color: theme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'v0.1.0',
            style: TextStyle(
              color: theme.onSurface.withValues(alpha: 0.4),
              fontSize: 12,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Selector<DemoAppController, bool>(
            selector: (_, c) => c.isDark,
            builder: (context, isDark, _) {
              return _ThemeToggle(
                isDark: isDark,
                theme: theme,
                onToggle: demo.toggleTheme,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  final bool isDark;
  final MarkdownLatexTheme theme;
  final VoidCallback onToggle;

  const _ThemeToggle({
    required this.isDark,
    required this.theme,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 72,
        height: 36,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C2128) : const Color(0xFFEAECEF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: theme.divider, width: 1.5),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.light_mode_rounded,
                    size: 15,
                    color: isDark
                        ? theme.onSurface.withValues(alpha: 0.3)
                        : Colors.amber.shade700,
                  ),
                  Icon(
                    Icons.dark_mode_rounded,
                    size: 15,
                    color: isDark
                        ? Colors.indigo.shade300
                        : theme.onSurface.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF3D444D) : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
