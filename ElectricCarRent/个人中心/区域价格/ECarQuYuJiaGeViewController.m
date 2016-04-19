//
//  ECarQuYuJiaGeViewController.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/1/13.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarQuYuJiaGeViewController.h"
#import "UIKit+AFNetworking.h"

@interface ECarQuYuJiaGeViewController () <UIScrollViewDelegate>
{
    CGFloat lastScale;
}

@property (nonatomic, strong) UIImageView * showImgView;

@end

@implementation ECarQuYuJiaGeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"运营时间及区域";
    [self createUI];
}

- (void)createUI
{
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, 276.f / 667.f * kScreenH)];
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.minimumZoomScale = 1;
    scrollView.maximumZoomScale = 4;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    [UIImageView clearCache];
    
    _showImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 276.f / 667.f * kScreenH)];
    NSURL * showuUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@car/webpage/pic/yunyingfanwei1.png", ServerURL]];
    NSURLRequest * showRequest = [NSURLRequest requestWithURL:showuUrl];
    weak_Self(self);
    [self showHUD:@"正在加载..."];
    [_showImgView setImageWithURLRequest:showRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, UIImage * _Nonnull image) {
        [weakSelf hideHUD];
        [weakSelf.showImgView setImage:image];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSError * _Nonnull error) {
        [weakSelf hideHUD];
    }];
    [scrollView addSubview:_showImgView];
    
    // zhangzhao    下方滑动图片
    UIScrollView * scrollViewDown = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scrollView.frame), kScreenW, kScreenH - CGRectGetMaxY(scrollView.frame))];
    scrollViewDown.bounces = NO;
    scrollViewDown.showsHorizontalScrollIndicator = NO;
    scrollViewDown.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollViewDown];
    
    UIImageView * imageViewDown = [[UIImageView alloc] init];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@car/webpage/pic/yunyingfanwei2.png", ServerURL]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    __block UIImageView * botImag = imageViewDown;
    [imageViewDown setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, UIImage * _Nonnull image) {
        [weakSelf hideHUD];
        botImag.frame = CGRectMake(0, 0, kScreenW, 375.f / image.size.width  * image.size.height);
        [botImag setImage:image];
        [scrollViewDown setContentSize:CGSizeMake(kScreenW, 375.f / image.size.width * image.size.height)];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSError * _Nonnull error) {
        [weakSelf hideHUD];
        [weakSelf delayHidHUD:MESSAGE_NoNetwork];
    }];

    [scrollViewDown addSubview:imageViewDown];
    
//    UIImageView * bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scrollView.frame), kScreenW, kScreenH - CGRectGetMaxY(scrollView.frame))];
//    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@car/webpage/pic/yunyingfanwei2.png", ServerURL]];
//    NSURLRequest * request = [NSURLRequest requestWithURL:url];
//    __block UIImageView * botImag = bottomImage;
//    [bottomImage setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, UIImage * _Nonnull image) {
//        [weakSelf hideHUD];
//        [botImag setImage:image];
//    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSError * _Nonnull error) {
//        [weakSelf hideHUD];
//        [weakSelf delayHidHUD:MESSAGE_NoNetwork];
//    }];
//    [self.view addSubview:bottomImage];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _showImgView;
}

@end
