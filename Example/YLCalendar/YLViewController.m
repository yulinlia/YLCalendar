//
//  YLViewController.m
//  YLCalendar
//
//  Created by yulinlia@usc.edu on 02/28/2019.
//  Copyright (c) 2019 yulinlia@usc.edu. All rights reserved.
//

#import "YLViewController.h"
#import <YLCalendar/YLCalendarView.h>

@interface YLViewController ()

@property(nonatomic, strong) YLCalendarView *calendarView;

@end

@implementation YLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.calendarView = [[YLCalendarView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.calendarView];
}
@end

