# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.1.3] - 2026-06-30

### Changed

- 仓库迁移至 `hurricane-gathering/markdown_latex`，同步更新 `pubspec.yaml` 与 README 链接

---

## [0.1.2] - 2026-06-30

### Changed

- 全面重写 README：更清晰的价值主张、场景说明、架构介绍与 API 文档
- 优化 `pubspec.yaml` 描述与 pub topics，提升 pub.dev 展示效果
- 更新库入口文档注释

---

## [0.1.1] - 2026-06-30

### Fixed

- `MarkdownLatex` 切换 `selectable` 时通过 `Key` 强制重建 `MarkdownBody`，修复文本选择状态不更新
- `LatexErrorView` 使用红色错误样式（不再误用主题 `primary` 色）
- 预览空内容时不再渲染占位 Markdown 文本

### Changed

- 修正 `pubspec.yaml` 仓库链接指向实际 GitHub 仓库
- 更新 `LICENSE` 版权信息
- `.pubignore` 排除 Demo 专用文件（`lib/main.dart` 等）
- 完善 README（raw string 提示、滚动用法、`dispose` 说明）

### Added

- `test/math_syntax_test.dart` — LaTeX 行内/块级解析单元测试

---

## [0.1.0] - 2026-06-30

### Added

- **`markdown_latex`** — Markdown + LaTeX 混合渲染首发版本
- **`MarkdownLatex`** — GFM + 行内/块级 LaTeX
- **`MarkdownLatexEditor`** — 编辑/预览双模式，可选中文本开关
- **`MarkdownLatexTheme`** — Light / Dark 主题
- 代码块语法高亮、复制按钮、任务列表、表格、图片、链接
- `provider` + `Selector` 状态管理
