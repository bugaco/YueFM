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
@property(nonatomic, strong)UIWebView *webView;
@property(nonatomic, strong)UIScrollView *scrollView;
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
}
-(void)setScrollView{
           //init with frame
           self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
           // set contentSize
           self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height);
           //add scrollView to self.view
           [self.view addSubview:self.scrollView];
           //close bounces
           self.scrollView.bounces = NO;
           //don't show indicator
           self.scrollView.showsHorizontalScrollIndicator = NO;
           //enable pagging scroll
           self.scrollView.pagingEnabled = YES;
           //set scrollView delegate
           self.scrollView.delegate = self;
           
           //set first page of scrollView
                      //add webView to scrollView
           [self.scrollView addSubview:self.webView];
           
           //set second page of scrollView
           UIImageView *imageViewOfSecondPage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
           imageViewOfSecondPage.image = [UIImage imageNamed:@"desktop.png"];
           [self.scrollView addSubview:imageViewOfSecondPage];
}
//加载随机文章
-(void)loadARandomArticle{
           [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self getARandomArticleURL]]]];
}
//获取一个随机文章的地址
-(NSString *)getARandomArticleURL{
           NSURL *url = [NSURL URLWithString:RANDOM_URL];
           NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:url] options:NSJSONReadingMutableContainers error:nil];
           return [NSString stringWithFormat:@"%@%@", PRE_ARTILE_URL, dic[@"short_id"]];
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
//scrollView复位
-(void)setDefaultContentOffSet{
           [self loadARandomArticle];
           self.scrollView.contentOffset = CGPointMake(0, 0);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
