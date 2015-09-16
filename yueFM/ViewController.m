//
//  ViewController.m
//  yueFM
//
//  Created by admin on 15/9/15.
//  Copyright (c) 2015年 李懿哲. All rights reserved.
//

#define PRE_ARTILE_URL @"http://yue.fm/"
#define RANDOM_URL @"http://api.yue.fm/articles/random"

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic, strong)UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
           //设置webview
           [self setWebView];
           //加载一篇文章
           [self loadARandomArticle];
}

-(void)setWebView{
           self.webView = [UIWebView new];
           self.webView.frame = self.view.bounds;
           [self.view addSubview:self.webView];
           
           //增加拖拽事件
           [self addDragGesture];
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
-(void)addDragGesture{
          
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
