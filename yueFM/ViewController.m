//
//  ViewController.m
//  yueFM
//
//  Created by admin on 15/9/15.
//  Copyright (c) 2015年 李懿哲. All rights reserved.
//

//define API URL
#define PRE_ARTILE_URL @"http://yue.fm/"
#define RANDOM_URL @"http://api.yue.fm/articles/random"

//define screen size
#define SCREEN_SIZE [[UIScreen mainScreen]bounds].size

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property(nonatomic, strong)UIWebView *webView;// webView
@property(nonatomic, strong)UIScrollView *scrollView;//scrollView
@property(nonatomic, strong)UIActivityIndicatorView *activityIndicatorView;
@property(nonatomic, strong)UIView *flickView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
           //设置webview
           [self setWebView];
           //set the scrollView
           [self setScrollView];
           //加载一篇文章
           [self loadARandomArticle];
}

-(void)setWebView{
           //init
           self.webView = [UIWebView new];

           //set frame
           self.webView.frame = self.view.bounds;
           [self.view addSubview:self.webView];
           //关闭webview内部的scrollView的弹簧效果
           self.webView.scrollView.bounces = NO;
}
-(void)setScrollView{
           //初始化scrollView，并设置属性
           self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
           self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height);
           [self.view addSubview:self.scrollView];
           //关闭弹簧效果
           self.scrollView.bounces = NO;
           //不显示水平方向的滚动条
           self.scrollView.showsHorizontalScrollIndicator = NO;
           //设置分页滚动
           self.scrollView.pagingEnabled = YES;
           //设置self为scrollView的delegate
           self.scrollView.delegate = self;
           
           //设置scrollView的第一页
                      //add webView to scrollView
           [self.scrollView addSubview:self.webView];
           
           //设置scrollView的第二页
                      //设置背景图片
           UIImageView *imageViewOfSecondPage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
           imageViewOfSecondPage.image = [UIImage imageNamed:@"desktop.png"];
           [self.scrollView addSubview:imageViewOfSecondPage];
                      //加上活动指示器
           [self startActivityIndicatorAnimating];
                      //加上左边的“左拉阅读下一篇”
           self.flickView = [[UIView alloc]init];
           self.flickView.frame = CGRectMake(SCREEN_SIZE.width + 20, 80, 40, 180);
           [self.scrollView addSubview:self.flickView];
                      //加上flick图片
           UIImageView *flickImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_flick_sun.png"]];
           flickImageView.frame = CGRectMake(0, 0, 40, 25);
           [self.flickView addSubview:flickImageView];
                      //加上文字“左拉阅读下一篇”
           UILabel *flickLabel = [UILabel new];
           flickLabel.numberOfLines = 7;
           flickLabel.text = @"左拉阅读下一篇";
           flickLabel.frame = CGRectMake(10, 10, 20, 180);
           flickLabel.textAlignment = NSTextAlignmentCenter;
           flickLabel.textColor = [UIColor grayColor];
           [self.flickView addSubview:flickLabel];
}
//加载随机文章
-(void)loadARandomArticle{
           [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self getARandomArticleURL]]]];
           //销毁活动指示器
}
//获取一个随机文章的地址
-(NSString *)getARandomArticleURL{
           NSURL *url = [NSURL URLWithString:RANDOM_URL];
           NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:url] options:NSJSONReadingMutableContainers error:nil];
           return [NSString stringWithFormat:@"%@%@", PRE_ARTILE_URL, dic[@"short_id"]];
}
//进行拖拽时
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

           if (scrollView.contentOffset.x >= SCREEN_SIZE.width / 2) {
                                 //如果拖拽过了一半，隐藏flickView，显示指示器
                      if (!self.flickView.isHidden) {
                                 self.flickView.hidden = YES;
                      }
                      if (self.activityIndicatorView.isHidden) {
                                 self.activityIndicatorView.hidden = NO;
                      }
           }else{
                                 //如果拖拽没有一半，隐藏flickView，显示指示器
                      if (self.flickView.isHidden) {
                                 self.flickView.hidden = NO;
                      }
                      if (!self.activityIndicatorView.isHidden) {
                                 self.activityIndicatorView.hidden = YES;
                      }
                      
           }
}
//拖拽结束后
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
           if (!decelerate) {
           [self didEndDraggingOrDecelerating];
           }
}
//拖拽减速结束后
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
           [self didEndDraggingOrDecelerating];
}
//拖拽或滚动结束后
-(void)didEndDraggingOrDecelerating{
           //判断：如果此时滚动到了第二页，则立即加载下一片文章，并延迟复位scrollView
           if (self.scrollView.contentOffset.x == SCREEN_SIZE.width) {
                      
                      [self setDefaultContentOffSet];
                      
           }

}
//scrollView复位，先加载文章，阻塞主线程，防止拖动界面，文章加载成功后，显示scrollView的第一页
-(void)setDefaultContentOffSet{
           [self startActivityIndicatorAnimating];
           [self loadARandomArticle];
           self.scrollView.contentOffset = CGPointMake(0, 0);
}
//创建活动指示器开始转
-(void)startActivityIndicatorAnimating{
           if (!self.activityIndicatorView) {
                      self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                      //设置指示器在scrollView中的位置
                      self.activityIndicatorView.frame = CGRectMake(SCREEN_SIZE.width * 1.5 , SCREEN_SIZE.height / 2 - self.activityIndicatorView.frame.size.height / 2, 0, 0);
                      
                      [self.scrollView addSubview:self.activityIndicatorView];
                      [self.activityIndicatorView startAnimating];
           }
}
//活动指示器停止转
-(void)stopActivityIndicator{
           if(self.activityIndicatorView){
                      [self.activityIndicatorView stopAnimating];
                      [self.activityIndicatorView removeFromSuperview];
                      self.activityIndicatorView = nil;
           }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
