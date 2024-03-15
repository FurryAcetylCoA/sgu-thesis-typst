#import "@preview/t4t:0.3.2": is
#import "../utils/custom-tablex.typ": gridx, colspanx
#import "../utils/datetime-display.typ": datetime-display
#import "../utils/style.typ": 字号, 字体

// 本科生封面
#let bachelor-cover(
  // documentclass 传入的参数
  anonymous: false,
  twoside: false,
  fonts: (:),
  info: (:),
  // 其他参数
  stoke-width: 0.5pt,
  min-title-lines: 1,
  info-inset: (x: 0pt, bottom: 1pt),
  info-width: 150pt,
  key-width: 80pt,
  column-gutter: 0pt,
  row-gutter: 1pt,
  anonymous-info-keys: ("grade", "student-id", "author", "supervisor", "supervisor-ii"),
  bold-level: "bold",
  datetime-display: datetime-display,
) = {
  // 1.  默认参数
  fonts = 字体 + fonts
  info = (
    title: ("基于 Typst 的", "南京大学学位论文"),
    grade: "20XX",
    student-id: "1234567890",
    author: "张三",
    department: "某学院",
    major: "某专业",
    supervisor: ("李四", "教授"),
    begin-date: datetime.today(),
    end-date: datetime.today(),
  ) + info

  // 2.  对参数进行处理
  // 2.1 如果是字符串，则使用换行符将标题分隔为列表
  if (is.str(info.title)) {
    info.title = info.title.split("\n")
  }
  // 2.2 根据 min-title-lines 填充标题
  info.title = info.title + range(min-title-lines - info.title.len()).map((it) => "　")
  // 2.3 处理提交日期
  if (is.type(datetime, info.begin-date)) {
    info.begin-date = datetime-display(info.begin-date)
  }
  if (is.type(datetime, info.end-date)) {
    info.end-date = datetime-display(info.end-date)
  }

  // 3.  内置辅助函数
  let info-key(body) = {
    rect(
      width: 100%,
      inset: info-inset,
      stroke: none,
      text(font: fonts.宋体, size: 字号.四号,weight: bold-level, body),
    )
  }

  let info-long-key(body) = {
    colspanx(2,
      info-key(body)
    )
  }

  let info-value(key, body) = {
    set align(left)
    rect(
      width: 100%,
      inset: info-inset,
      stroke: none,
      text(
        font: fonts.宋体,
        size: 字号.四号,
        weight: bold-level,
        body,
      ),
    )
  }

  let info-long-value(key, body) = {
    colspanx(3,
      info-value(
        key,
        if (anonymous and (key in anonymous-info-keys)) {
          "██████████"
        } else {
          body
        }
      )
    )
  }

  let info-short-value(key, body) = {
    colspanx(2,
      info-value(
        key,
        if (anonymous and (key in anonymous-info-keys)) {
          "██████████"
        } else {
          body
        }
      )
    )
  }
  

  // 4.  正式渲染
  
  pagebreak(weak: true, to: if twoside { "odd" })

  // 居中对齐
  set align(center)

  // 匿名化处理去掉封面标识
  if (anonymous) {
    v(70pt)
  } else {
    v(25pt)
    // 调整一下右边的间距
    image("../assets/vi/sgu.png", width: 5.8cm)
    v(2pt)
  }


  text(size: 字号.初号, font: fonts.宋体, spacing: 200%, weight: "bold")[毕 业 设 计]
  
  if (anonymous) {
    v(132pt)
  } else {
    v(120pt)
  }

  block(width: 85%, gridx(

    columns: (key-width, 1fr, info-width, 1fr),
    column-gutter: column-gutter,
    row-gutter: row-gutter,
    info-key("题　　目："),
    ..info.title.map((s) => info-long-value("title", s)).intersperse(info-key("　")),
    info-key("学生姓名："),
    info-long-value("author", info.author),    
    info-key("学　　号:"),
    info-long-value("student-id", info.student-id),
    info-key("二级学院："),
    info-long-value("department", info.department),
    info-key("专　　业:"),
    info-long-value("major", info.major),
    info-key("班　　级:"),
    info-long-value("grade", info.grade),
    info-long-key("指导教师姓名及职称:"),
    info-short-value("supervisor", info.supervisor.join("　　")),
    info-key("起止时间:"),
    info-long-value("begin-time", info.begin-date + "　——　" +info.end-date)
  ))

  v(80pt)

  text(size: 字号.五号, font: fonts.宋体)[（教务处制）]
}
