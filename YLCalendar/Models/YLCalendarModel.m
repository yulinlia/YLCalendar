//
//  YLCalendarModel.m
//  YLCalendar
//
//  Created by 梁煜麟 on 2/15/19.
//  Copyright © 2019 梁煜麟. All rights reserved.
//

#import "YLCalendarModel.h"

@implementation YLCalendarModel

- (instancetype)initWithDate:(NSDate *)modelDate {
    if (self = [super init]) {
        [self updateModelWithDate:modelDate fromDate:modelDate];
    }
    
    return self;
}

- (instancetype)initWithDate:(NSDate *)modelDate fromDate:(NSDate *)fromDate {
    if (self = [super init]) {
        [self updateModelWithDate:modelDate fromDate:fromDate];
    }
    
    return self;
}

- (void)updateModelWithDate:(NSDate *)modelDate fromDate:(NSDate *)fromDate {
    self.date = modelDate;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *modelDateComponent = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:modelDate];
    
    self.year = modelDateComponent.year;
    self.month = modelDateComponent.month;
    self.day = modelDateComponent.day;
    
    NSDateComponents *fromDateComponent = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:fromDate];
    
    self.isSameMonth = (fromDateComponent.month == modelDateComponent.month && fromDateComponent.year == modelDateComponent.year);
    self.isToday = NO;
}

- (BOOL)isSameDate:(YLCalendarModel *)comparedModel {
    return self.day == comparedModel.day && self.month == comparedModel.month && self.year == comparedModel.year;
}

@end
