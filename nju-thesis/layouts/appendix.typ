#import "@preview/i-figured:0.2.2"
#import "../utils/custom-numbering.typ": custom-numbering
#import "../utils/style.typ": 字号, 字体

// 后记，重置 heading 计数器
#let appendix(
  fonts: (:),
  numbering: custom-numbering.with(first-level: "", depth: 3, "A.1 "),
  // figure 计数
  show-figure: i-figured.show-figure.with(numbering: "A.1"),
  // equation 计数
  show-equation: i-figured.show-equation.with(numbering: "(A.1)"),
  // 其他参数
  title: "附录",
  outlined: true,
  twoside: false,
  body,
) = {
  fonts = 字体 + fonts
  set heading(numbering: numbering)
  counter(heading).update(0)
  // 设置 figure 的编号
  show figure: show-figure
  // 设置 equation 的编号
  show math.equation.where(block: true): show-equation
  pagebreak(weak: true, to: if twoside { "odd" })
  // 显示标题
  [
    #set text(font: fonts.黑体, size: 字号.小四, weight: "bold")
    #set align(center)
    #heading(level: 1, numbering: numbering, outlined: outlined, title) <no-auto-pagebreak>
  ]
  text(font: fonts.宋体, size: 字号.五号)[#body]
}
