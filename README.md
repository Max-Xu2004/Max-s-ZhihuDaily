# Max-s-ZhihuDaily
本项目为知乎旗下知乎日报app粗制滥造的仿制品（逃）
主要功能包括新闻缩略瀑布流浏览

![QQ20230219-204812-HD](https://user-images.githubusercontent.com/114380848/219949261-1c0cf52d-70ef-49ca-b620-3c71a204adcf.gif)

新闻详情页浏览

![QQ20230219-205630-HD](https://user-images.githubusercontent.com/114380848/219949385-1322d51d-639e-4511-9de0-fcc360f690f0.gif)

banner无限轮播图

![QQ20230219-212427-HD](https://user-images.githubusercontent.com/114380848/219950988-fc041d81-0c06-4fcc-88d0-b7fd473539e4.gif)

同时还实现了伪点赞、伪登录等功能不一一展示

主要由首页（默认的ViewController）、新闻展示页（NewsViewController）和登录页（LoginViewController）组成

瀑布流的实现使用了tableview，而banner轮播使用了collectionview，并将其作为tableview的headerview

同时使用了两种模型和三个sessionmanager来分别获取banner轮播图信息，瀑布流对应的信息，和某内容对应的点赞数评论数等额外内容

通过本次的实践，我对tableview、collectionview和与之相关的scrollview用法有了一定的了解

同时了解了通过afhttpsessionmanager对http api进行请求并利用模型对获取到的数据进行分类整理的用法有了一定了解

最后请批改时手下留情（qaq）
