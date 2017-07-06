//
//  CMMotionActivityViewController.m
//  CMMotionDemo
//
//  Created by 墨殇 on 2017/6/28.
//  Copyright © 2017年 墨殇. All rights reserved.
//

#import "CMMotionActivityViewController.h"
#import <CoreMotion/CoreMotion.h>
@interface CMMotionActivityViewController ()
@property (nonatomic, strong) CMMotionActivityManager * activityManager;
@property (nonatomic, strong) CMPedometer             * cmPedometer;
@end

@implementation CMMotionActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //info.plist 添加 NSMotionUsageDescription 字段
    self.activityManager = [[CMMotionActivityManager alloc] init];
    
    [self.activityManager startActivityUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMMotionActivity * _Nullable activity) {
        NSLog(@"\n activity === %@\n",activity);
    }];
    [self.activityManager queryActivityStartingFromDate:[NSDate dateWithTimeIntervalSinceNow:-50000] toDate:[NSDate date] toQueue:[NSOperationQueue currentQueue] withHandler:^(NSArray<CMMotionActivity *> * _Nullable activities, NSError * _Nullable error) {
        
    }];
    
    
    
    
    self.cmPedometer = [[CMPedometer alloc] init];
    if ([CMPedometer isDistanceAvailable]) {
        [self.cmPedometer startPedometerEventUpdatesWithHandler:^(CMPedometerEvent * _Nullable pedometerEvent, NSError * _Nullable error) {
            
        }];
        [self.cmPedometer queryPedometerDataFromDate:[NSDate dateWithTimeIntervalSinceNow:-50000] toDate:[NSDate dateWithTimeIntervalSinceNow:3600 * 8] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            
        }];
        
    }
    [self.cmPedometer startPedometerEventUpdatesWithHandler:^(CMPedometerEvent * _Nullable pedometerEvent, NSError * _Nullable error) {
        NSLog(@"======= %@",pedometerEvent);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
