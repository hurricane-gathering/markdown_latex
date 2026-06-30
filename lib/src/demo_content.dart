/// 完整覆盖所有语法的 Markdown + LaTeX 演示内容
const String kDemoMarkdown = r'''
# MarkdownLatex ✨

> **Markdown + LaTeX 混合渲染** Flutter 组件（`markdown_latex`），
> 视觉风格接近 Notion / GitHub。顶部工具栏可切换 **编辑 / 渲染** 模式。

---

## 文本样式

普通段落文本，行高舒适，适合长文档阅读。支持多平台：移动端、桌面端、Web。

**粗体文本**   *斜体文本*   ~~删除线~~   `行内代码`   支持 Emoji 😄 🚀 🎉

---

## 标题层级

### 三级标题 H3

#### 四级标题 H4

##### 五级标题 H5

###### 六级标题 H6（低调版）

---

## 列表

### 无序列表

- 🦋 Flutter 是 Google 的跨平台 UI 框架
- 📱 支持 iOS / Android / macOS / Windows / Web
  - Dart 作为核心编程语言
  - 单代码库覆盖全平台
    - 嵌套第三层

### 有序列表

1. 安装 Flutter SDK
2. 配置开发环境（VS Code / Android Studio）
3. 创建并运行第一个 Flutter 应用
4. 探索 Widget 树与状态管理

### 任务列表

- [x] 实现 Markdown 基础渲染
- [x] 支持代码语法高亮
- [x] 支持 LaTeX 数学公式
- [x] 实现 Light / Dark 主题
- [x] 编辑 / 渲染双模式 Demo
- [ ] 发布到 pub.dev
- [ ] 完善单元测试

---

## 代码块

### Dart

```dart
class MarkdownLatex extends StatelessWidget {
  final String data;
  final MarkdownLatexTheme? theme;
  final ValueChanged<String>? onTapLink;

  const MarkdownLatex({
    super.key,
    required this.data,
    this.theme,
    this.onTapLink,
  });

  @override
  Widget build(BuildContext context) {
    final t = theme ?? MarkdownLatexTheme.light();
    return MarkdownBody(data: data, styleSheet: _buildSheet(t));
  }
}
```

### Python

```python
def fibonacci(n: int) -> list[int]:
    """生成斐波那契数列前 n 项。"""
    a, b = 0, 1
    result = []
    for _ in range(n):
        result.append(a)
        a, b = b, a + b
    return result

print(fibonacci(10))  # [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
```

### JavaScript

```javascript
const debounce = (fn, delay) => {
  let timer;
  return (...args) => {
    clearTimeout(timer);
    timer = setTimeout(() => fn(...args), delay);
  };
};

const search = debounce((query) => fetch(`/api?q=${query}`), 300);
```

### Shell

```bash
# 创建并启动 Flutter 项目
flutter create --org com.example my_app
cd my_app && flutter run
```

---

## 数学公式（LaTeX）

### 行内公式

质能方程：$E = mc^2$，勾股定理：$a^2 + b^2 = c^2$，欧拉公式：$e^{i\pi} + 1 = 0$。

正态分布密度函数：$f(x) = \frac{1}{\sigma\sqrt{2\pi}} e^{-\frac{(x-\mu)^2}{2\sigma^2}}$

### 块级公式

高斯积分：

$$
\int_{-\infty}^{\infty} e^{-x^2} \, dx = \sqrt{\pi}
$$

麦克斯韦方程组（微分形式）：

$$
\nabla \cdot \mathbf{E} = \frac{\rho}{\varepsilon_0}, \quad
\nabla \cdot \mathbf{B} = 0, \quad
\nabla \times \mathbf{E} = -\frac{\partial \mathbf{B}}{\partial t}, \quad
\nabla \times \mathbf{B} = \mu_0\mathbf{J} + \mu_0\varepsilon_0\frac{\partial \mathbf{E}}{\partial t}
$$

矩阵乘法：

$$
\begin{pmatrix} a & b \\ c & d \end{pmatrix}
\begin{pmatrix} x \\ y \end{pmatrix}
=
\begin{pmatrix} ax + by \\ cx + dy \end{pmatrix}
$$

---

## 表格

| 框架 | 语言 | 平台支持 | 性能 | 生态成熟度 |
|------|------|---------|------|-----------|
| Flutter | Dart | iOS/Android/Web/桌面 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| React Native | JS/TS | iOS/Android/Web | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| SwiftUI | Swift | Apple 全平台 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| Compose | Kotlin | Android/桌面 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |

---

## 引用块

> 📌 **Alan Kay：** 预测未来的最好方式就是创造它。

> 简单的一级引用
>> 嵌套的二级引用  
>> 支持 **粗体** 和 `代码`
>>> 更深层的引用

---

## 链接与图片

[Flutter 官方文档](https://docs.flutter.dev) ·
[Dart 语言官网](https://dart.dev) ·
[pub.dev 包仓库](https://pub.dev)

![随机示例图片](https://picsum.photos/seed/elegant/600/200)

---

## 分割线

以下是三种分割线写法（均支持）：

---

***

___

**以上就是 MarkdownLatex 的完整语法演示！** 🎊
''';
