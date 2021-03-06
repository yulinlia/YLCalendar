//
//  YLCalendarModel.h
//  Pods
//
//  Created by 梁煜麟 on 2/28/19.
//

#import <Foundation/Foundation.h>

#ifndef YLCalendarModel_h
#define YLCalendarModel_h

@interface YLCalendarModel : NSObject

@property(nonatomic, strong)NSDate *date;
@property(nonatomic, assign)NSInteger year;
@property(nonatomic, assign)NSInteger month;
@property(nonatomic, assign)NSInteger day;
@property(nonatomic, assign)BOOL isSameMonth;
@property(nonatomic, assign)BOOL isToday;

- (instancetype)initWithDate:(NSDate *)modelDate;
- (instancetype)initWithDate:(NSDate *)modelDate fromDate:(NSDate *)fromDate;

- (BOOL)isSameDate:(YLCalendarModel *)comparedModel;

@end

#endif /* YLCalendarModel_h */
