// 韶关学院学位论文模板 sgu-thesis-typst
// Author: https://github.com/OrangeX4
// Author: https://github.com/FurryAcetylCoA
// Repo: https://github.com/FurryAcetylCoA/sgu-thesis-typst

#import "@preview/anti-matter:0.0.2": anti-inner-end as mainmatter-end
#import "layouts/doc.typ": doc
#import "layouts/preface.typ": preface
#import "layouts/mainmatter.typ": mainmatter
#import "layouts/appendix.typ": appendix
#import "templates/fonts-display-page.typ": fonts-display-page
#import "templates/bachelor-cover.typ": bachelor-cover
#import "templates/bachelor-abstract.typ": bachelor-abstract
#import "templates/bachelor-abstract-en.typ": bachelor-abstract-en
#import "templates/bachelor-outline-page.typ": bachelor-outline-page
#import "templates/list-of-figures.typ": list-of-figures
#import "templates/list-of-tables.typ": list-of-tables
#import "templates/notation.typ": notation
#import "templates/acknowledgement.typ": acknowledgement
#import "templates/bib.typ": bib
#import "utils/custom-numbering.typ": custom-numbering
#import "utils/custom-heading.typ": heading-display, active-heading, current-heading
#import "utils/custom-tablex.typ": *
#import "utils/indent.typ": indent
#import "@preview/i-figured:0.2.2": show-figure, show-equation
#import "utils/style.typ": 字体
#import "utils/style.typ": 字号

// 使用函数闭包特性，通过 `documentclass` 函数类进行全局信息配置，然后暴露出拥有了全局配置的、具体的 `layouts` 和 `templates` 内部函数。
#let documentclass(
  twoside: false,  // 双面模式，会加入空白页，便于打印
  anonymous: false,  // 盲审模式
  fonts: (:),  // 字体，应传入「宋体」、「黑体」、「楷体」、「仿宋」、「等宽」
  info: (:),
) = {
  // 默认参数
  fonts = 字体 + fonts
  info = (
    title: ("基于 Typst 的", "韶关学院学位论文"),
    title-en: "SGU Thesis Template for Typst",
    grade: "20XX",
    student-id: "1234567890",
    author: "张三",
    author-en: "Zhang San",
    department: "某学院",
    department-en: "XX Department",
    major: "某专业",
    major-en: "XX Major",
    field: "某方向",
    field-en: "XX Field",
    supervisor: ("李四", "教授"),
    supervisor-en: "Professor Li Si",
    supervisor-ii: (),
    supervisor-ii-en: "",
    begin-date: datetime.today(),
    end-date: datetime.today(),
  ) + info

  (
    // 页面布局
    doc: (..args) => {
      doc(
        ..args,
        info: info + args.named().at("info", default: (:)),
      )
    },
    preface: (..args) => {
      preface(
        twoside: twoside,
        ..args,
      )
    },
    mainmatter: (..args) => {
      mainmatter(
        twoside: twoside,
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
        info: info + args.named().at("info", default: (:)),
      )
    },
    mainmatter-end: (..args) => {
      mainmatter-end(
        ..args,
      )
    },
    appendix: (..args) => {
      appendix(
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
      )
    },

    // 字体展示页
    fonts-display-page: (..args) => {
      fonts-display-page(
        twoside: twoside,
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
      )
    },

    // 封面页
    cover: (..args) => {
      bachelor-cover(
        anonymous: anonymous,
        twoside: twoside,
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
        info: info + args.named().at("info", default: (:)),
      )
    },
    
    // 中文摘要页
    abstract: (..args) => {
      bachelor-abstract(
        anonymous: anonymous,
        twoside: twoside,
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
        info: info + args.named().at("info", default: (:)),
      )
    },

    // 英文摘要页
    abstract-en: (..args) => {
      bachelor-abstract-en(
        anonymous: anonymous,
        twoside: twoside,
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
        info: info + args.named().at("info", default: (:)),
      )
    },

    // 目录页
    outline-page: (..args) => {
      bachelor-outline-page(
        twoside: twoside,
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
      )
    },

    // 插图目录页
    list-of-figures: (..args) => {
      list-of-figures(
        twoside: twoside,
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
      )
    },

    // 表格目录页
    list-of-tables: (..args) => {
      list-of-tables(
        twoside: twoside,
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
      )
    },

    // 符号表页
    notation: (..args) => {
      notation(
        twoside: twoside,
        ..args,
      )
    },

    // 致谢页
    acknowledgement: (..args) => {
      acknowledgement(
        anonymous: anonymous,
        twoside: twoside,
        ..args,
      )
    },
    // 参考文献页
    bib: (..args) => {
      bib(
        twoside: twoside,
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
      )
    }
  )
}
