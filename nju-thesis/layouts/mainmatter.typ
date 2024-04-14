#import "@preview/anti-matter:0.0.2": anti-front-end
#import "@preview/i-figured:0.2.2"
#import "../utils/style.typ": 字号, 字体
#import "../utils/custom-numbering.typ": custom-numbering
#import "../utils/custom-heading.typ": heading-display, active-heading, current-heading
#import "../utils/indent.typ": fake-par
#import "../utils/unpairs.typ": unpairs

#let mainmatter(
  // documentclass 传入参数
  twoside: false,
  fonts: (:),
  info:(:),
  // 其他参数
  leading: 1.5em,
  spacing: 1.25em,
  justify: true,
  first-line-indent: 2em,
  numbering: custom-numbering.with(depth: 3, "1.1 "),
  // 正文字体与字号参数
  text-args: auto,
  // 标题字体与字号
  heading-font: (字体.黑体, 字体.宋体),
  heading-size: (字号.小三, 字号.小四, 字号.小四),
  heading-weight: ("bold", "regular", "regular"),
  heading-top-vspace: (20pt, 4pt),
  heading-bottom-vspace: (20pt, 8pt),
  heading-pagebreak: (true, false),
  heading-align: (auto, auto),
  // 页眉
  header-render: auto,
  header-vspace: 0em,
  display-header: false,
  skip-on-first-level: true,
  stroke-width: 0.5pt,
  // caption 的 separator
  separator: "  ",
  // figure 计数
  show-figure: i-figured.show-figure,
  // equation 计数
  show-equation: i-figured.show-equation,
  ..args,
  it,
) = {
  // 0.  标志前言结束
  anti-front-end()

  // 1.  默认参数
  fonts = 字体 + fonts
  if (text-args == auto) {
    text-args = (font: fonts.宋体, size: 字号.小四)
  }
  // 1.1 字体与字号
  if (heading-font == auto) {
    heading-font = (fonts.黑体,)
  }
  // 1.2 处理 heading- 开头的其他参数
  let heading-text-args-lists = args.named().pairs()
    .filter((pair) => pair.at(0).starts-with("heading-"))
    .map((pair) => (pair.at(0).slice("heading-".len()), pair.at(1)))

  // 2.  辅助函数
  let array-at(arr, pos) = {
    arr.at(calc.min(pos, arr.len()) - 1)
  }

  // 3.  设置基本样式
  // 3.1 文本和段落样式
  set text(..text-args)
  set par(
    leading: leading,
    justify: justify,
    first-line-indent: first-line-indent
  )
  show par: set block(spacing: spacing)
  // 3.2 脚注样式
  show footnote.entry: set text(font: fonts.宋体, size: 字号.五号)
  // 3.3 设置 figure 的编号
  show heading: i-figured.reset-counters
  show figure: show-figure
  // 3.4 设置 equation 的编号
  show math.equation.where(block: true): show-equation
  // 3.5 表格表头置顶 + 不用冒号用空格分割
  show figure.where(
    kind: table
  ): set figure.caption(position: top)

  show figure.where(
    kind: image
  ): set figure(gap: 1em)
  
  show figure.where(
    kind: table
  ): set figure(gap: 1.5em)
    
  set figure.caption(separator: separator)

  // 3.6 表格头黑体五号 + 表格内容宋体五号

  show figure: set text(font: fonts.宋体, size: 字号.五号)
  show figure.caption: set text(font: fonts.黑体, size: 字号.五号)

  // 3.7 代码块不使用居中对齐

  //show figure.where(kind: "i-figured-raw"): it => {
  //  let dic = it.fields()
  //  let _ = if "body" in dic { dic.remove("body") }
  //  let _ = if "label" in dic { dic.remove("label") }
  //  let _ = if "counter" in dic { dic.remove("counter") }
  //
  //let fig = figure(text(par(it.body,justify: false,leading:0.65em),size: 12pt),
  //    ..dic,kind: "f" + repr(it.kind))
  //fig
  //}  // FIXME: 会导致代码块计数混乱
  
  // 3.8 有序列表样式
  set enum(numbering: "(1) .")

  // 3.9 优化列表显示
  //     术语列表 terms 不应该缩进
  show terms: set par(first-line-indent: 0pt)

  // 4.  处理标题
  // 4.1 设置标题的 Numbering
  set heading(numbering: numbering)
  // 4.2 设置字体字号并加入假段落模拟首行缩进
  show heading: it => {
    set text(
      font: array-at(heading-font, it.level),
      size: array-at(heading-size, it.level),
      weight: array-at(heading-weight, it.level),
      ..unpairs(heading-text-args-lists
        .map((pair) => (pair.at(0), array-at(pair.at(1), it.level))))
    )
    v(array-at(heading-top-vspace, it.level))
    it
    v(array-at(heading-bottom-vspace, it.level))
    fake-par
  }
  // 4.3 第一页增加文章标题
  show heading: it => {
    if(it.level == 1 and counter(heading).get().at(0) ==1){
      align(center)[#text(font: fonts.黑体, size: 字号.小二, weight: "bold")[#info.title]]
      it
    }else{
      it
    }  
  }
  // 4.4 标题居中与自动换页
  show heading: it => {
    if (array-at(heading-pagebreak, it.level)) {
      // 如果打上了 no-auto-pagebreak 标签，则不自动换页
      if ("label" not in it.fields() or str(it.label) != "no-auto-pagebreak") {
        pagebreak(weak: true)
      }
    }
    if (array-at(heading-align, it.level) != auto) {
      set align(array-at(heading-align, it.level))
      it
    } else {
      it
    }
  }

  // 5.  处理页眉
  set page(..(if display-header {
    (
      header: locate(loc => {
        // 5.1 获取当前页面的一级标题
        let cur-heading = current-heading(level: 1, loc)
        // 5.2 如果当前页面没有一级标题，则渲染页眉
        if not skip-on-first-level or cur-heading == none {
          if header-render == auto {
            // 一级标题和二级标题
            let first-level-heading = if not twoside or calc.rem(loc.page(), 2) == 0 { heading-display(active-heading(level: 1, loc)) } else { "" }
            let second-level-heading = if not twoside or calc.rem(loc.page(), 2) == 2 { heading-display(active-heading(level: 2, prev: false, loc)) } else { "" }
            set text(font: fonts.楷体, size: 字号.五号)
            stack(
              first-level-heading + h(1fr) + second-level-heading,
              v(0.25em),
              if first-level-heading != "" or second-level-heading != "" { line(length: 100%, stroke: stroke-width + black) },
            )
          } else {
            header-render(loc)
          }
          v(header-vspace)
        }
      })
    )
  }))

  it
}