import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme.dart';
import 'markdown_latex_editor_controller.dart';
import '../markdown_latex_view.dart';

/// A Markdown editor with live edit / preview modes.
class MarkdownLatexEditor extends StatelessWidget {
  final MarkdownLatexEditorController controller;
  final MarkdownLatexTheme? theme;
  final ValueChanged<String>? onTapLink;
  final double? maxWidth;
  final EdgeInsetsGeometry padding;
  final Widget Function(BuildContext context, MarkdownLatexTheme theme)?
      toolbarBuilder;

  const MarkdownLatexEditor({
    super.key,
    required this.controller,
    this.theme,
    this.onTapLink,
    this.maxWidth,
    this.padding = EdgeInsets.zero,
    this.toolbarBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedTheme = theme ??
        (Theme.of(context).brightness == Brightness.dark
            ? MarkdownLatexTheme.dark()
            : MarkdownLatexTheme.light());

    return ChangeNotifierProvider<MarkdownLatexEditorController>.value(
      value: controller,
      child: _MarkdownLatexEditorBody(
        theme: resolvedTheme,
        onTapLink: onTapLink,
        maxWidth: maxWidth,
        padding: padding,
        toolbarBuilder: toolbarBuilder,
      ),
    );
  }
}

class _MarkdownLatexEditorBody extends StatelessWidget {
  final MarkdownLatexTheme theme;
  final ValueChanged<String>? onTapLink;
  final double? maxWidth;
  final EdgeInsetsGeometry padding;
  final Widget Function(BuildContext context, MarkdownLatexTheme theme)?
      toolbarBuilder;

  const _MarkdownLatexEditorBody({
    required this.theme,
    this.onTapLink,
    this.maxWidth,
    required this.padding,
    this.toolbarBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: theme.isDark ? 0.22 : 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (toolbarBuilder != null)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.surface,
                    border: Border(bottom: BorderSide(color: theme.divider)),
                  ),
                  child: toolbarBuilder!(context, theme),
                ),
              Expanded(
                child: Selector<MarkdownLatexEditorController,
                    MarkdownLatexViewMode>(
                  selector: (_, c) => c.mode,
                  builder: (context, mode, _) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: mode == MarkdownLatexViewMode.edit
                          ? _EditPane(
                              key: const ValueKey('edit'),
                              theme: theme,
                            )
                          : _PreviewPane(
                              key: const ValueKey('preview'),
                              theme: theme,
                              onTapLink: onTapLink,
                              maxWidth: maxWidth,
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditPane extends StatelessWidget {
  final MarkdownLatexTheme theme;

  const _EditPane({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: theme.surface,
      child: TextField(
        controller:
            context.read<MarkdownLatexEditorController>().textController,
        maxLines: null,
        expands: true,
        style: TextStyle(
          color: theme.onSurface,
          fontFamily: 'monospace',
          fontSize: 14,
          height: 1.65,
        ),
        cursorColor: theme.primary,
        decoration: InputDecoration(
          hintText: '在此输入 Markdown + LaTeX…',
          hintStyle: TextStyle(
            color: theme.onSurface.withValues(alpha: 0.35),
            fontFamily: 'monospace',
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
        keyboardType: TextInputType.multiline,
        textAlignVertical: TextAlignVertical.top,
      ),
    );
  }
}

class _PreviewPane extends StatelessWidget {
  final MarkdownLatexTheme theme;
  final ValueChanged<String>? onTapLink;
  final double? maxWidth;

  const _PreviewPane({
    super.key,
    required this.theme,
    this.onTapLink,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<MarkdownLatexEditorController,
        ({String data, bool selectable, int previewEpoch})>(
      selector: (_, c) => (
        data: c.data,
        selectable: c.selectable,
        previewEpoch: c.previewEpoch,
      ),
      builder: (context, state, _) {
        final markdown = MarkdownLatex(
          // 切换 selectable 时必须重建 MarkdownBody，否则选择状态不会更新。
          key: ValueKey('preview-${state.previewEpoch}-${state.selectable}'),
          data: state.data.isEmpty ? '_暂无内容_' : state.data,
          theme: theme,
          selectable: state.selectable,
          onTapLink: onTapLink,
          maxWidth: maxWidth,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        );

        return ColoredBox(
          color: theme.background,
          child: state.data.isEmpty
              ? Center(
                  child: Text(
                    '暂无内容，请切换到编辑模式输入 Markdown',
                    style: TextStyle(
                      color: theme.onSurface.withValues(alpha: 0.45),
                      fontSize: 14,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: markdown,
                ),
        );
      },
    );
  }
}

/// Default demo toolbar with mode switch and preview selectable toggle.
class MarkdownLatexEditorToolbar extends StatelessWidget {
  final MarkdownLatexTheme theme;

  const MarkdownLatexEditorToolbar({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<MarkdownLatexEditorController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Selector<MarkdownLatexEditorController, MarkdownLatexViewMode>(
            selector: (_, c) => c.mode,
            builder: (context, mode, _) {
              return _ModeTabBar(
                theme: theme,
                mode: mode,
                onModeChanged: controller.setMode,
              );
            },
          ),
          const Spacer(),
          Selector<MarkdownLatexEditorController, MarkdownLatexViewMode>(
            selector: (_, c) => c.mode,
            builder: (context, mode, _) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: mode == MarkdownLatexViewMode.preview
                    ? Selector<MarkdownLatexEditorController, bool>(
                        key: const ValueKey('selectable-toggle'),
                        selector: (_, c) => c.selectable,
                        builder: (context, selectable, _) {
                          return _SelectableToggle(
                            theme: theme,
                            value: selectable,
                            onChanged: controller.setSelectable,
                          );
                        },
                      )
                    : Text(
                        key: const ValueKey('edit-hint'),
                        '编辑 Markdown 源码',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.onSurface.withValues(alpha: 0.45),
                        ),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ModeTabBar extends StatelessWidget {
  final MarkdownLatexTheme theme;
  final MarkdownLatexViewMode mode;
  final ValueChanged<MarkdownLatexViewMode> onModeChanged;

  const _ModeTabBar({
    required this.theme,
    required this.mode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.divider.withValues(alpha: 0.8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ModeTab(
              theme: theme,
              label: '编辑',
              icon: Icons.edit_outlined,
              selected: mode == MarkdownLatexViewMode.edit,
              onTap: () => onModeChanged(MarkdownLatexViewMode.edit),
            ),
            _ModeTab(
              theme: theme,
              label: '渲染',
              icon: Icons.visibility_outlined,
              selected: mode == MarkdownLatexViewMode.preview,
              onTap: () => onModeChanged(MarkdownLatexViewMode.preview),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  final MarkdownLatexTheme theme;
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ModeTab({
    required this.theme,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? theme.primary.withValues(alpha: 0.12) : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected
                    ? theme.primary
                    : theme.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected
                      ? theme.primary
                      : theme.onSurface.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectableToggle extends StatelessWidget {
  final MarkdownLatexTheme theme;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SelectableToggle({
    required this.theme,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          value ? Icons.text_fields_rounded : Icons.touch_app_outlined,
          size: 16,
          color: theme.onSurface.withValues(alpha: value ? 0.75 : 0.4),
        ),
        const SizedBox(width: 6),
        Text(
          '文本可选',
          style: TextStyle(
            fontSize: 13,
            color: theme.onSurface.withValues(alpha: 0.65),
          ),
        ),
        const SizedBox(width: 4),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }
}
