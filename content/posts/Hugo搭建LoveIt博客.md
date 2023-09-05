---
title: "Hugo搭建LoveIt博客"
date: 2021-01-24
tags: ["Hugo","博客"]
categories: ["杂文"]
---

系统又又又重装了，又又又忘了怎么配置博客，所以做笔记是有多么重要。。。。

Hugo是由Go语言实现的静态网站生成器。简单、易用、高效、易扩展、快速部署。

##### 1.下载Hugo

地址如下，找到对应平台的二进制包，下载后将工具目录添加至系统环境变量。

https://github.com/gohugoio/hugo/releases

需要注意的是，由于LoveIt主题使用了一些特性，因此我们需要下载hugo_extended版本，否则可能会生成博客失败。

##### 2.创建博客

执行以下命令

```bash
hugo new site testDemo
cd testDemo
git init
git submodule add https://github.com/dillonzq/LoveIt.git themes/LoveIt
```

之后修改testDemo目录下的config.toml文件，该文件可以用来配置主题信息，例如修改为如下

```toml
baseURL = "http://example.org/"
# [en, zh-cn, fr, ...] 设置默认的语言
defaultContentLanguage = "zh-cn"
# 网站语言, 仅在这里 CN 大写
languageCode = "zh-CN"
# 是否包括中日韩文字
hasCJKLanguage = true
# 网站标题
title = "我的全新 Hugo 网站"

# 更改使用 Hugo 构建网站时使用的默认主题
theme = "LoveIt"

[params]
  # LoveIt 主题版本
  version = "0.2.X"

[menu]
  [[menu.main]]
    identifier = "posts"
    # 你可以在名称 (允许 HTML 格式) 之前添加其他信息, 例如图标
    pre = ""
    # 你可以在名称 (允许 HTML 格式) 之后添加其他信息, 例如图标
    post = ""
    name = "文章"
    url = "/posts/"
    # 当你将鼠标悬停在此菜单链接上时, 将显示的标题
    title = ""
    weight = 1
  [[menu.main]]
    identifier = "tags"
    pre = ""
    post = ""
    name = "标签"
    url = "/tags/"
    title = ""
    weight = 2
  [[menu.main]]
    identifier = "categories"
    pre = ""
    post = ""
    name = "分类"
    url = "/categories/"
    title = ""
    weight = 3

# Hugo 解析文档的配置
[markup]
  # 语法高亮设置 (https://gohugo.io/content-management/syntax-highlighting)
  [markup.highlight]
    # false 是必要的设置 (https://github.com/dillonzq/LoveIt/issues/158)
    noClasses = false

```

##### 3.添加文章

我们可以在`testDemo/content/posts`目录下添加md文件，例如first_post.md

```markdown
---
title: "我是第一篇文章"
date: 2021-01-24
tags: ["笔记","博客"]
categories: ["杂文"]
---

这是我的第一篇文章
```

##### 4.调试

添加完成后，执行下面的命令开启动态预览博客。

```bash
hugo server
```

执行完成后，命令会返回一个本地网址，我们可以通过该网址查看博客内容。

##### 5.发布

使用以下命令行，生成html内容

```bash
rm -f -r docs
hugo -b "https://fjqisba.github.io" -d docs
git add .
git status
git commit -m "content update"
git push
```

这个生成的docs文件夹其实就是Github Pages要展示的内容了，因此在项目配置中的Settings -> Pages -> Source这一栏，我们需要将目录/root修改为/docs。

### 遇到的坑

- markdown文件在网页的路径中不能出现小数点之类的特殊字符。