<div align="center">

# markdown_latex

**在 Flutter 里，把 Markdown 与 LaTeX 当作同一种语言来渲染。**

一行代码，呈现媲美 Notion / GitHub 的阅读体验 —— 公式、代码、表格、任务列表，浑然一体。

[![pub package](https://img.shields.io/pub/v/markdown_latex.svg?style=flat-square&color=0969DA)](https://pub.dev/packages/markdown_latex)
[![License: MIT](https://img.shields.io/badge/License-MIT-1f2328?style=flat-square)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.32-02569B?style=flat-square&logo=flutter)](https://flutter.dev)

[快速开始](#-快速开始) · [功能亮点](#-功能亮点) · [在线体验](#-本地-demo) · [API](#-api-一览)

</div>

---

## 为什么选择 markdown_latex？

大多数方案要么只做好 Markdown，要么把 LaTeX 当作插件硬塞进去。  
**markdown_latex** 从第一天就为 **混合渲染** 而设计 —— 正文、公式、代码块共享同一套排版节奏与主题系统，读起来像一份完整文档，而不是拼凑的碎片。

```
┌─────────────────────────────────────────────────────┐
│  # 麦克斯韦方程组                                    │
│                                                     │
│  行内形式：$\nabla \cdot \mathbf{E} = \rho/\varepsilon_0$ │
│                                                     │
│  ┌─────────────────────────────────────────────┐   │
│  │  $$\int_{\Omega} (\nabla \times \mathbf{E})  │   │
│  │       \cdot d\mathbf{A} = -\frac{d\Phi}{dt}$$│   │
│  └─────────────────────────────────────────────┘   │
│                                                     │
│  ```dart                                            │
│  MarkdownLatex(data: paper);  // 语法高亮 + 复制    │
│  ```                                                │
└─────────────────────────────────────────────────────┘
```

---

## ✨ 功能亮点

<table>
<tr>
<td width="50%">

### 🔀 原生混合排版

`$...$` 行内公式与 `$$...$$` 块级公式，与段落、列表、引用自然融合。  
行内公式基线对齐，块级公式独立容器 —— 不突兀，不跳行。

### 💻 精致代码块

20+ 语言语法高亮、语言标签、一键复制、横向滚动。  
暗色 / 亮色主题各自匹配 GitHub 风格高亮方案。

### ✏️ 编辑 · 渲染一体

`MarkdownLatexEditor` 内置双模式切换与「文本可选」开关，  
适合笔记 App、知识库、AI 对话预览等场景。

</td>
<td width="50%">

### 📝 完整 GFM 支持

标题层级、粗斜体、删除线、任务列表、表格、引用、分割线、图片、链接 —— 开箱即用。

### 🌗 双主题 · 可深度定制

`MarkdownLatexTheme.light()` / `.dark()` 一键切换；  
代码区、公式区、表格、引用块均可独立配色。

### ⚡ 轻量 · 无 StatefulWidget

库内采用 `provider` + `Selector` 精细重建，  
API 简洁，接入成本低。

</td>
</tr>
</table>

---

## 📦 安装

```yaml
dependencies:
  markdown_latex: ^0.1.3
  provider: ^6.1.5   # 仅在使用 MarkdownLatexEditor 时需要
```

```bash
flutter pub get
```

> **环境要求** · Flutter `>=3.32.0` · Dart `>=3.8.0`

---

## 🚀 快速开始

> 💡 含 `$` / `$$` 的内容请使用 **raw string**（`r'...'`），避免 Dart 字符串插值冲突。

### 最简渲染

```dart
import 'package:markdown_latex/markdown_latex.dart';

MarkdownLatex(
  data: r'''
# 薛定谔方程

$i\hbar\frac{\partial}{\partial t}\Psi = \hat{H}\Psi$

$$
-\frac{\hbar^2}{2m}\nabla^2\Psi + V\Psi = i\hbar\frac{\partial\Psi}{\partial t}
$$
''',
  theme: MarkdownLatexTheme.light(),
  selectable: true,
)
```

### 长文档 · 可滚动

`MarkdownLatex` 渲染为内联布局，外层包裹滚动容器即可：

```dart
SingleChildScrollView(
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  child: MarkdownLatex(
    data: longArticle,
    maxWidth: 720,   // 可选：阅读宽度限制 + 居中
  ),
)
```

### 编辑 / 预览双模式

```dart
final controller = MarkdownLatexEditorController(
  initialData: kYourMarkdown,
  selectable: true,
);

MarkdownLatexEditor(
  controller: controller,
  theme: MarkdownLatexTheme.dark(),
  toolbarBuilder: (_, theme) => MarkdownLatexEditorToolbar(theme: theme),
);

// 生命周期结束时
controller.dispose();
```

### 跟随系统主题

省略 `theme` 参数，自动读取 `Theme.of(context).brightness`：

```dart
MarkdownLatex(data: content)  // 亮/暗随系统
```

---

## 🎯 适用场景

| 场景 | 用法 |
|------|------|
| 📚 知识库 / 笔记 App | `MarkdownLatexEditor` 编辑 + 实时预览 |
| 🤖 AI 对话消息渲染 | `MarkdownLatex` + `selectable: true` |
| 📄 技术博客 / 文档阅读 | `maxWidth` 限制行宽，舒适阅读 |
| 🎓 学术内容展示 | 块级 / 行内 LaTeX 混排 |
| 📱 跨平台内容页 | iOS · Android · Web · Desktop 统一渲染 |

---

## 📐 LaTeX 语法速查

| 类型 | 写法 | 示例 |
|------|------|------|
| 行内 | `$...$` | `$E = mc^2$` |
| 单行显示 | `$$...$$` | `$$\sum_{i=1}^{n} i = \frac{n(n+1)}{2}$$` |
| 多行块 | 独立 `$$` 围栏 | 见下方 |

~~~markdown
$$
\int_{-\infty}^{\infty} e^{-x^2}\,dx = \sqrt{\pi}
$$
~~~

**代码块语言标签：** `dart` `python` `javascript` `typescript` `rust` `go` `bash` `yaml` `sql` 等 20+ 种。

---

## 🧩 API 一览

| 组件 | 职责 |
|------|------|
| `MarkdownLatex` | 核心渲染器 — Markdown + LaTeX 混合输出 |
| `MarkdownLatexTheme` | 主题系统 — 颜色、高亮、公式容器样式 |
| `MarkdownLatexEditor` | 编辑 / 预览双栏 |
| `MarkdownLatexEditorController` | 内容、模式、可选中状态 |
| `MarkdownLatexEditorToolbar` | 内置工具栏（模式切换 + 可选中开关） |

### `MarkdownLatex` 参数

| 参数 | 类型 | 默认 | 说明 |
|------|------|------|------|
| `data` | `String` | *required* | Markdown + LaTeX 源码 |
| `theme` | `MarkdownLatexTheme?` | 跟随系统 | 视觉主题 |
| `selectable` | `bool` | `false` | 文本是否可选中 |
| `maxWidth` | `double?` | `null` | 内容最大宽度（居中） |
| `padding` | `EdgeInsetsGeometry` | `zero` | 内边距 |
| `onTapLink` | `ValueChanged<String>?` | 自动打开链接 | 链接点击回调 |

---

## 🖥 本地 Demo

克隆仓库后，根目录直接运行即可体验完整语法与编辑/预览模式：

```bash
git clone https://github.com/hurricane-gathering/markdown_latex.git
cd markdown_latex
flutter pub get
flutter run
```

---

## 🏗 架构一览

```
markdown_latex/
├── lib/markdown_latex.dart              # 公共导出入口
└── src/
    ├── markdown_latex_view.dart         # 渲染核心 + GFM 样式表
    ├── syntax/math_syntax.dart          # $...$ / $$...$$ 解析器
    ├── builders/
    │   ├── math_builder.dart            # 行内 & 块级公式 Widget
    │   └── code_builder.dart            # 语法高亮 + 复制
    ├── editor/                          # 编辑 / 预览模式
    └── theme.dart                       # 主题配置
```

**设计要点**

- `BlockMathSyntax` + `BlockMathBuilder` — 多行 `$$` 作为块级元素，避免内联上下文错误
- `InlineMathSyntax` — 同时识别 `$...$` 与单行 `$$...$$`
- `selectable` 切换时通过 `Key` 重建 `MarkdownBody`，确保选择状态正确

---

## 🤝 参与贡献

欢迎 Issue 与 PR：[GitHub Issues](https://github.com/hurricane-gathering/markdown_latex/issues)

---

<div align="center">

**如果这个项目对你有帮助，欢迎在 [pub.dev](https://pub.dev/packages/markdown_latex) 点亮 ⭐ Like**

MIT © 2026 · [LICENSE](LICENSE)

</div>
