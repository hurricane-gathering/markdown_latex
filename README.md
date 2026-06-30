# markdown_latex

[![pub package](https://img.shields.io/pub/v/markdown_latex.svg)](https://pub.dev/packages/markdown_latex)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

**Flutter Markdown + LaTeX 混合渲染组件** — 一眼即知：同时渲染 Markdown 与 LaTeX 数学公式。  
视觉风格接近 Notion / GitHub，支持 GFM、代码高亮、编辑/预览双模式。

---

## ✨ Features

| Feature                  | Description                                            |
| ------------------------ | ------------------------------------------------------ |
| 🔀 **混合渲染**          | Markdown 正文与 `$...$` / `$$...$$` LaTeX 公式无缝混排 |
| 📝 **Full Markdown**     | GFM — 标题、粗斜体、列表、引用、表格、任务列表         |
| 💻 **Code Highlighting** | `flutter_highlight` 语法高亮 + 一键复制                |
| ✏️ **Edit / Preview**    | `MarkdownLatexEditor` 编辑/渲染切换 + 文本可选开关     |
| 🌗 **Themes**            | 内置 Light / Dark，可完全自定义                        |
| ✂️ **Selectable**        | 预览模式可选中文本                                     |

---

## 📦 Installation

```yaml
dependencies:
  markdown_latex: ^0.1.0
  provider: ^6.1.5 # MarkdownLatexEditor 需要
```

```bash
flutter pub get
```

**Requirements:** Flutter `>=3.32.0`, Dart `>=3.8.0`

---

## 🚀 Quick Start

```dart
import 'package:markdown_latex/markdown_latex.dart';

MarkdownLatex(
  data: '# Hello\n\n质能方程：\$E=mc^2\$',
  theme: MarkdownLatexTheme.light(),
  selectable: true,
)
```

### 编辑 / 预览

```dart
final controller = MarkdownLatexEditorController(initialData: '# Hi\n\n\$x^2\$');

MarkdownLatexEditor(
  controller: controller,
  toolbarBuilder: (context, theme) =>
      MarkdownLatexEditorToolbar(theme: theme),
);
```

---

## 🧩 API

| Widget                          | Description     |
| ------------------------------- | --------------- |
| `MarkdownLatex`                 | 混合渲染主组件  |
| `MarkdownLatexTheme`            | 主题配置        |
| `MarkdownLatexEditor`           | 编辑/预览编辑器 |
| `MarkdownLatexEditorController` | 编辑器状态      |
| `MarkdownLatexEditorToolbar`    | 内置工具栏      |

---

## 📐 LaTeX 语法

```markdown
行内：$E = mc^2$

单行显示：$$\frac{a}{b}$$

多行块：

$$
\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}
$$
```

---

## 📄 License

MIT © 2026
