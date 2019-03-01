//
//  NSCalendar+Util.h
//  YLCalendar
//
//  Created by 梁煜麟 on 2/28/19.
//

#ifndef NSCalendar_Util_h
#define NSCalendar_Util_h

typedef NS_ENUM(NSUInteger, YLCalendarUnit) {
    YLCalendarUnitYear,
    YLCalendarUnitMonth,
    YLCalendarUnitDay
};

@interface NSCalendar (Util)

- (NSInteger)numberOfWeeksInMonth:(NSDate *)date;

- (NSDate *)firstDayInMonth:(NSDate *)date;

- (NSDate *)dateByOffset:(NSInteger)offset ofDate:(NSDate *)date;

- (NSDate *)dateWithOffset:(NSInteger)offset fromDate:(NSDate *)date withUnit:(YLCalendarUnit)unit;

- (NSInteger)distanceFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate withUnit:(YLCalendarUnit)unit;

- (NSInteger)distanceOfMonthFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

@end

#endif /* NSCalendar_Util_h */
