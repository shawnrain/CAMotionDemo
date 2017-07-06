//
//  EventKitViewController.m
//  CMMotionDemo
//
//  Created by 墨殇 on 2017/6/28.
//  Copyright © 2017年 墨殇. All rights reserved.
//

#import "EventKitViewController.h"
#import <EventKit/EventKit.h>
@interface EventKitViewController ()

@end

@implementation EventKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    EKEventStore * eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            EKEvent * event = [EKEvent eventWithEventStore:eventStore];
            event.title = @"hello world";
            event.location = @"我在这里";
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd.MM.yyyy HH:mm"];
            
        }
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
