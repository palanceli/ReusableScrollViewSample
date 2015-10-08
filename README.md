# ReusableScrollViewSample
reusable scroll view
本例讨论当设定为翻页模式，内容页很多的时候，如果给每个页面都创建一个新View，会导致资源爆表。
比较好的做法是参考UITableViewCell的做法，引入重用机制，同时确保业务层和机制层的分离。
