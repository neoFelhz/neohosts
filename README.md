<img src="https://i.loli.net/2017/10/26/59f16e54c30af.png" alt="logo" width="100" height="100" align="right" />

# neoHosts

> **自由、负责、克制** 的去广告 Hosts

<p align="center">
<img alt="Author" src="https://img.shields.io/badge/Author-Neko%20Dev%20Team%20&%20neoHosts%20Team-blue.svg?style=flat-square"/>
<a href="https://travis-ci.org/neko-dev/neohosts"><img alt="Build Status" src="https://img.shields.io/travis/neoFelhz/neohosts.svg?style=flat-square"/></a>
<a href="https://github.com/neoFelhz/neohosts/blob/data/LICENSE"><img alt="License" src="https://img.shields.io/badge/License-MIT-757575.svg?style=flat-square"/></a>
</p>

## Introduction 介绍

- 自由：我们使用 `MIT & SATA` **自由协议**而不是 `CC BY-NC-ND` 这样的非自由协议，希望能够促进和帮助更多项目
- 克制：我们保证**不因个人喜好屏蔽非广告有关网站**；我们会仔细研究和分析，**我们不会随意屏蔽任何一个域名**
- 负责：我们不搞“捐赠才能反馈”、不搞 VIP 特权。**所有用户都应该能免费、完整地使用本项目、自由地反馈问题**

## Download 下载

### [Basic Hosts](https://cdn.jsdelivr.net/gh/neoFelhz/neohosts@gh-pages/basic/hosts)

> 基础、克制的数据，推荐所有用户使用。

- [AdGuardHome 兼容版](https://cdn.jsdelivr.net/gh/neoFelhz/neohosts@gh-pages/basic/hosts.txt)

### [Full Hosts](https://cdn.jsdelivr.net/gh/neoFelhz/neohosts@gh-pages/full/hosts)

> 包含全部数据，仅推荐强迫症使用。相比 Basic Hosts，Full Hosts 额外屏蔽了以下内容：

- JS Miner 挖矿
- 百度全家桶的全天候定位记录
- 各类统计服务（仅屏蔽 JS、不屏蔽控制台）
- 常见下载劫持
- 360 和百度的部分软件下载
- CNNIC 根证书劫持
- 法轮功、ISIS、银河联邦等可能令人反感的激进宗教内容网站

- [AdGuardHome 兼容版](https://cdn.jsdelivr.net/gh/neoFelhz/neohosts@gh-pages/full/hosts.txt)

### [Basic Compatible Hosts](https://cdn.jsdelivr.net/gh/neoFelhz/neohosts@gh-pages/127.0.0.1/basic/hosts)

> 基于 Basic Hosts，广告域名会被定向至 127.0.0.1 而不是 0.0.0.0，兼容性更好。

### [Full Compatible Hosts](https://cdn.jsdelivr.net/gh/neoFelhz/neohosts@gh-pages/127.0.0.1/full/hosts)

> 基于 Full Hosts，广告域名会被定向至 127.0.0.1 而不是 0.0.0.0，兼容性更好。

### [Basic Mikrotik](https://cdn.jsdelivr.net/gh/neoFelhz/neohosts@gh-pages/basic/mikrotik.rsc)

> 基于 Basic Hosts 的 Mikrotik 脚本，建议定期从源抓取并执行。

### [Full Mikrotik](https://cdn.jsdelivr.net/gh/neoFelhz/neohosts@gh-pages/full/mikrotik.rsc)

> 基于 Full Hosts 的 Mikrotik 脚本，建议定期从源抓取并执行。

## Docs 文档

[neoHosts Wiki](https://hosts.nfz.moe/#/)

> neoHosts Wiki 使用 `docsify.js` 构建

## Maintainer

**neoHosts** © [Neko Dev Team](https://github.com/neko-dev) & neoHosts Team, Released under the [MIT License & SATA](./LICENSE) License.<br>
Authored and maintained by [neoFelhz](https://github.com/neoFelhz) with `Neko Dev Team` , `neoHosts Team` and the help from other contributors ([list](https://github.com/neko-dev/neohosts/contributors)).

## Friends 友情链接

- [neoFelhz's Blog](https://blog.nfz.moe) - The main maintainer's blog.
- [ACL4SSR](https://github.com/ACL4SSR/ACL4SSR) - A project which provide ACL for SSR, include gfwlist and ban AD.
- [GenHosts](https://github.com/pigfromChina/neohosts) - A fork from neoHosts, using build tool written in Ruby.

## License 许可证

本项目的 hosts，README，wiki 等资源基于 [MIT](./LICENSE) 协议发布并增加了 `SATA` 协议。

> 当你使用了使用 `SATA` 的开源软件或文档的时候，在遵守基础许可证的前提下，你**必须**马不停蹄地给你所使用的开源项目 “点赞” ，比如在 GitHub 上 star，然后你**必须**感谢这个帮助了你的开源项目的作者，作者信息可以在许可证头部的版权声明部分找到。

本项目分发的所有 Hosts 和数据源，除另有说明外，均基于上述介绍的协议发布，具体请看分支下的 [`LICENSE`](https://github.com/neko-dev/neohosts/blob/data/LICENSE)。

此处的文字仅用于说明，条款以 [`LICENSE`](https://github.com/neko-dev/neohosts/blob/data/LICENSE) 文件中的内容为准。
