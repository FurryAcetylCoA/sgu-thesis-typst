#import "../utils/style.typ": 字号, 字体

// 致谢页
#let acknowledgement(
  // documentclass 传入参数
  fonts: (:),
  anonymous: false,
  twoside: false,
  // 其他参数
  title: "致谢",
  outlined: true,
  body,
) = {
  fonts = 字体 + fonts
  if (not anonymous) {
    counter(heading).update(0)
    pagebreak(weak: true, to: if twoside { "odd" })
    [
      #set text(font: fonts.黑体, size: 字号.小四, weight: "bold")
      #set align(center)
      #heading(level: 1, numbering: none, outlined: outlined, title) <no-auto-pagebreak>
    ]
    text(font: fonts.宋体, size: 字号.五号)[#body]
  }
}
