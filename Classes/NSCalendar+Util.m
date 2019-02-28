//
//  NSCalendar+Util.m
//  YLCalendar
//
//  Created by 梁煜麟 on 2/28/19.
//

#import "NSCalendar+Util.h"

@implementation NSCalendar (Util)

- (NSInteger)numberOfWeeksInMonth:(NSDate *)date {
    //get the first date of this month
    NSDate *startDate = [self firstDayInMonth:date];
    
    //get the last date of this month
    NSDateComponents *endDateComponent = [NSDateComponents new];
    endDateComponent.month = 1;
    endDateComponent.day = -1;
    NSDate *endDate = [self dateByAddingComponents:endDateComponent toDate:startDate options:0];
    
    //get the start date of the week which contains the first date
    NSDateComponents *fromFirstWeekdayComponent = [self components:NSCalendarUnitWeekOfYear fromDate:startDate];
    fromFirstWeekdayComponent.weekday = 7;
    NSDate *fromFirstWeekday = [self dateFromComponents:fromFirstWeekdayComponent];
    
    //get the start date of the week which contains the last date
    NSDateComponents *toLastWeekdayComponent = [self components:NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear fromDate:endDate];
    toLastWeekdayComponent.weekday = 7;
    NSDate *toLastWeekday = [self dateFromComponents:toLastWeekdayComponent];
    
    NSInteger lengthOfWeek = [self components:NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear fromDate:fromFirstWeekday toDate:toLastWeekday options:0].weekOfYear + 1;
    return lengthOfWeek;
}

- (NSDate *)firstDayInMonth:(NSDate *)date {
    //get the first date of this month
    NSDateComponents *startDateComponent = [self components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:date];
    NSDate *startDate = [self dateFromComponents:startDateComponent];
    return startDate;
}

- (NSDate *)dateByOffset:(NSInteger)offset ofDate:(NSDate *)date {
    NSDate *startDate = [self firstDayInMonth:date];
    
    NSInteger offsetInWeek = [self components:NSCalendarUnitWeekday fromDate:startDate].weekday - 1;
    
    NSDateComponents *dateComponent = [NSDateComponents new];
    dateComponent.day = offset - offsetInWeek;
    NSDate *exactDate = [self dateByAddingComponents:dateComponent toDate:startDate options:0];
    return exactDate;
}

- (NSDate *)dateWithOffset:(NSInteger)offset fromDate:(NSDate *)date withUnit:(YLCalendarUnit)unit {
    NSDateComponents *offsetComponent = [NSDateComponents new];
    switch (unit) {
        case YLCalendarUnitYear:
            offsetComponent.year = offset;
            break;
        case YLCalendarUnitMonth:
            offsetComponent.month = offset;
            break;
        case YLCalendarUnitDay:
            offsetComponent.day = offset;
            break;
    }
    
    return [self dateByAddingComponents:offsetComponent toDate:date options:0];
}

- (NSInteger)distanceFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate withUnit:(YLCalendarUnit)unit {
    switch (unit) {
        case YLCalendarUnitYear:
            return [self components:NSCalendarUnitYear fromDate:fromDate toDate:toDate options:0].year;
        case YLCalendarUnitMonth:
            return [self components:NSCalendarUnitMonth fromDate:fromDate toDate:toDate options:0].month;
        case YLCalendarUnitDay:
            return [self components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0].day;
    }
}

- (NSInteger)distanceOfMonthFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    return [self components:NSCalendarUnitMonth fromDate:fromDate toDate:toDate options:0].month;
}

@end

