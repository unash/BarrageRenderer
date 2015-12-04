## BarrageRenderer
一个 iOS 上的开源弹幕渲染库.

##发起原因:
弹幕实质是多个精灵的时间上的渲染方式. PC/Web上已经有很成熟的解决方案了; Android上比较有名的是BiliBili开源的DanmakuFlameMaster, 但是开源社区尚没有比较好的iOS弹幕渲染器.觉得在二次元文化逐渐渗透的今天,视频弹幕已经是很重要的一种情绪表达方式了.没必要重复造轮子,所以我把自己写的一份弹幕渲染引擎开源了.还有一些需要后续完善的地方,但基本功能已经有了.祝大家玩得开心.

## Features
*  提供过场弹幕(4种方向)与悬浮弹幕(2种方向)支持; 支持图片弹幕与文字弹幕.
*  提供图文弹幕接口attributedText, 可按照demo中的指示生成图文混排弹幕.
*  弹幕字体可定义: 颜色,边框,圆角,背景,字体等皆可定制.
*  自动轨道搜寻算法,新发弹幕会根据相同方向的同种弹幕获取最佳运动轨道.
*  支持延时弹幕,为反复播放弹幕提供可能；支持与外界的时间同步.
*  独立的动画时间系统, 可以统一调整动画速度.
*  特制的动画引擎,播放弹幕更流畅,可承接持续的10条/s的弹幕流速.
*  丰富的扩展接口, 实现了父类的接口就可以自定义弹幕动画.
*  概念较清晰,可以为任意UIView绑定弹幕,当然弹幕内容需要创建控件输入.
*  因为作者记性比较差,所以在很多紧要处添加了注释,理解代码更容易.
*  效果动画如下图所示:

![效果动画](./BarrageRendererDemo.gif)

视频演示地址: http://v.youku.com/v_show/id_XMTI5NDM4ODk3Ng==.html

## 使用方式
1. 下载版本库,进入BarrageRendererDemo目录. 运行pod update拉取相关库, 即可以运行BarrageRendererDemo.xcworkspace
2. 也可以在您工程的podfile中添加一条引用: *pod 'BarrageRenderer', '1.6.0'*  并在工程目录下的命令行中运行 pod update
3. 或者将代码下载下来, 将BarrageRenderer/目录添加到您的工程当中
4. 在需要使用弹幕渲染功能的地方 #import "BarrageHeader.h".
5. 创建BarrageRenderer,添加BarrageRenderer.view, 执行start方法, 通过receive方法输入弹幕描述符descriptor, 即可以显示弹幕. 详见demo.
6. demo的基本功能演示了: 如何在view上增加一条弹幕, 如何启动、停止、暂停、恢复弹幕播放, 如何减速弹幕的运动速度.
7. demo的高级功能演示了: 如何使用自定义方式添加图文混排弹幕,如何支持录播中在固定时间点显示固定弹幕的逻辑.
8. 相关的一篇博文: http://blog.exbye.com/2015/07/an-open-source-ios-barrage-renderer/


## 支持与联系
* 欢迎加入qq群讨论:325298378;
* 欢迎在GitHub上提出相关的issue.
