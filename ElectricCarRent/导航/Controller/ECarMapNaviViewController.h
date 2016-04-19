//
//  ECarMapNaviViewController.h
//  ElectricCarRent
//
//  Created by LIKUN on 15/9/17.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import <AMapNaviKit/AMapNaviKit.h>
#import "ECarCarInfo.h"

typedef void (^DrivingNaviBeganBlock)();
@interface ECarMapNaviViewController : AMapNaviViewController

@property (strong, nonatomic) ECarCarInfo *carInfo;
@property (assign, nonatomic) FindCarType findType;

- (instancetype)initWithDelegate:(id<AMapNaviViewControllerDelegate>)delegate;

- (void)initFindCarButtonView;

- (void)checkLanYa;

@end
