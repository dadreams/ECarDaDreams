//
//  ECarDrivingViewController.h
//  ElectricCarRent
//
//  Created by LIKUN on 15/10/5.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

/**
 *  行车导航界面
 */
#import <AMapNaviKit/AMapNaviKit.h>
#import "ECarCarInfo.h"

@protocol ECarDrivingViewControllerDelegate <NSObject>

- (void)zhifuViewPresentWithState:(BOOL)State;

@end

@interface ECarDrivingViewController : AMapNaviViewController

@property (strong, nonatomic) ECarCarInfo *carInfo;
@property (assign, nonatomic) id <ECarDrivingViewControllerDelegate> drivingDelegate;

- (void)checkLanYa;

@end
