#import "@preview/t4t:0.3.2": is
#import "../utils/style.typ": 字号, 字体
#import "../utils/indent.typ": fake-par
#import "../utils/double-underline.typ": double-underline
#import "../utils/invisible-heading.typ": invisible-heading

// 本科生中文摘要页
#let bachelor-abstract(
  // documentclass 传入的参数
  anonymous: false,
  twoside: false,
  fonts: (:),
  info: (:),
  // 其他参数
  keywords: (),
  outline-title: "中文摘要",
  outlined: true,
  anonymous-info-keys: ("author", "supervisor"),
  leading: 1.08em,
  spacing: 1.08em,
  body,
) = {
  // 1.  默认参数
  fonts = 字体 + fonts
  info = (
    title: ("基于ChatGPT的狗屁通生成器"),
    author: "张三",
    department: "某学院",
    major: "某专业",
    supervisor: ("李四", "教授"),
  ) + info

  // 2.  对参数进行处理
  // 2.1 如果是字符串，则使用换行符将标题分隔为列表
  if (is.str(info.title)) {
    info.title = info.title.split("\n")
  }

  // 3.  内置辅助函数
  let info-value(key, body) = {
    if (not anonymous or (key not in anonymous-info-keys)) {
      body
    }
  }

  // 4.  正式渲染
  pagebreak(weak: true, to: if twoside { "odd" })

  [
    #set text(font: fonts.宋体, size: 字号.五号)
    #set par(leading: leading, justify: true)
    #show par: set block(spacing: spacing)

    #align(center)[
      #set text(font: fonts.黑体, size: 字号.小二, weight: "bold")  
      #(("",)+ info.title).sum()

    ]

    #v(2em)

    #text(font: fonts.黑体, size: 字号.小四, weight: "bold")[*摘要*：]
    #[      
      #body
    ]

    #v(1em)

    #text(font: fonts.黑体, size: 字号.小四, weight: "bold")[*关键词*：]
    #(("",)+ keywords.intersperse("；")).sum()
    
    #v(5em)
  ]
}