#import "nju-thesis/template.typ": documentclass, tablex, fig, tlt, indent
#import "nju-thesis/utils/style.typ": 字号, 字体

// 双面模式，会加入空白页，便于打印
#let twoside = false
// #let twoside = true

#let (
  doc, preface, mainmatter, mainmatter-end, appendix,
  fonts-display-page, cover, decl-page, abstract, abstract-en, outline-page, list-of-figures, list-of-tables, notation, acknowledgement,
) = documentclass(
  // anonymous: true,  // 盲审模式
  twoside: twoside,  // 双面模式，会加入空白页，便于打印
  // 可自定义字体，先英文字体后中文字体，应传入「宋体」、「黑体」、「楷体」、「仿宋」、「等宽」
   fonts: (楷体: ("Times New Roman", "LXGW WenKai GB"),
           仿宋: ("Times New Roman", "Zhuque Fangsong (technical preview)")),

  info: (
    title: ("基于ChatGPT的狗屁通生成器"),
    title-en: "My Title in English",
    grade: "20XX",
    student-id: "12356252222",
    author: "张三",
    author-en: "Ming Xing",
    department: "某学院",
    department-en: "School of Chemistry and Chemical Engineering",
    major: "某专业",
    major-en: "Chemistry",
    supervisor: ("李四", "教授"),
    supervisor-en: "Professor My Supervisor",
    // supervisor-ii: ("王五", "副教授"),
    // supervisor-ii-en: "Professor My Supervisor",
    submit-date: datetime.today(),
  ),
)

// 文稿设置
#show: doc

// 字体展示测试页
//#fonts-display-page()

// 封面页
#cover()

// 前言
#show: preface

// 中文摘要
#abstract(
  keywords: ("我", "就是", "测试用", "关键词")
)[
  中文摘要
]

// 英文摘要
#abstract-en(
  keywords: ("Dummy", "Keywords", "Here", "It Is")
)[
  English abstract
]

// 目录
#outline-page()

// 插图目录
//#list-of-figures()

// 表格目录
//#list-of-tables()

// 正文
#show: mainmatter



= 基本功能

== 脚注

我们可以添加一个脚注。#footnote[脚注内容]

== 列表

=== 无序列表

- 无序列表项一
- 无序列表项二
  - 无序子列表项一
  - 无序子列表项二
  - 无序子列表项三

=== 有序列表

+ 有序列表项一
+ 有序列表项二
  + 有序子列表项一
  + 有序子列表项二
  + 有序子列表项三


== 图表

引用@tbl:timing-tlt1,引用@tbl:timing-tlt，以及@fig:nju-logo。引用图表时，表格、图片和代码分别需要加上 `tbl:`、`fig:` 和 `lst:` 前缀才能正常显示编号。以及这里使用 `fig` 函数替代原生 `figure` 函数以支持将 `tablex` 作为表格来识别。

#align(center, (stack(dir: ltr)[
  #fig(
    tlt(
      columns: 2,
      [药品],   [规格],
      [浓氨水],  [分析纯AR],
      [盐酸],   [分析纯AR],
      [钛酸四丁酯], [≥99.0%]
    ),
    caption: [三线表1],
  ) <timing-tlt1>
][
  #h(50pt)
][
  #fig(
    tlt(
      columns: 4,
      map-cells: cell => {
        if cell.y > 0 and cell.x > 0 {
        cell.content = {
          let text-color = if int(cell.content.text) < 5 {
            red.lighten(30%)
          } else {
            green
          }
          set text(text-color)
          strong(cell.content)
        }
      }
      cell
    },
      [t], [1], [2], [3],
      [y], [3], [4], [9],
      [3], [3], [17], [0],
    ),
    caption: [三线表 - 着色],
  ) <timing-tlt>
]))


== 插图

插图必须精心制作，线条均匀，图面整洁。插图位于正文中引用该插图字段的后面。每幅插图应有图序和图题，图序和图题应放在图位下方居中处

#fig(
  image("images/chatu.png", width: 60%),
  caption: [二氧化钛光催化原理图],
) <nju-logo>


== 数学公式

可以像 Markdown 一样写行内公式 $x + y$，以及带编号的行间公式：

$ phi.alt := (1 + sqrt(5)) / 2 $ <ratio>

引用数学公式需要加上 `eqt:` 前缀，则由@eqt:ratio，我们有：

$ F_n = floor(1 / sqrt(5) phi.alt^n) $

#indent 图表和公式后的段落要用 `#indent` 手动缩进。同时，我们也可以通过 `<->` 标签来标识该行间公式不需要编号

$ y = integral_1^2 x^2 dif x $ <->

而后续数学公式仍然能正常编号。

$ F_n = floor(1 / sqrt(5) phi.alt^n) $

== 参考文献

可以像这样引用参考文献：@wang2010guide。某期刊文章@某期刊文章


== 代码块

```py
def add(x, y):
  return x + y
```


= 正文

== 正文子标题

=== 正文子子标题

正文内容


// 手动分页
#if (twoside) {
  pagebreak() + " "
}
// 参考文献
#bibliography(("bibs/ex01.bib", "bibs/ymlex.yml"),
  style: "./china-national-standard-gb-t-7714-2015-numeric.csl"
)



// 正文结束标志，不可缺少
#mainmatter-end()


// 手动分页
#if (twoside) {
  pagebreak() + " "
}

// 附录
#show: appendix

= 附录

== 附录子标题

=== 附录子子标题

附录内容，这里也可以加入图片，例如@fig:appendix-img。

#fig(
  image("nju-thesis/assets/vi/nju-emblem.svg", width: 20%),
  caption: [图片测试],
) <appendix-img>

// 手动分页
#if (twoside) {
  pagebreak() + " "
}

// 致谢
#acknowledgement[
  感谢 NJU-LUG，提供 NJUThesis Typst 模板。
]