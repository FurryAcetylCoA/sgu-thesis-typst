#import "../utils/style.typ": 字号, 字体

// 致谢页
#let bib(
  // documentclass 传入参数
  fonts: (:),
  twoside: false,
  // 其他参数
  title: "参考文献",
  path: (:),
  outlined: true,
  style: "../assets/china-national-standard-gb-t-7714-2015-numeric.csl",
) = {
  fonts = 字体 + fonts
  pagebreak(weak: true, to: if twoside { "odd" })
  // 显示标题
  [
      #set text(font: fonts.黑体, size: 字号.小四, weight: "bold")
      #set align(center)
      #heading(level: 1, numbering: none, outlined: outlined, title) <no-auto-pagebreak>
  ]
  // 相对路径修正
  path = path.map((i) => ("../../" + i))

  show bibliography: set text(font: fonts.楷体,size: 字号.五号)
  bibliography(path, style: style, title: none)
}

