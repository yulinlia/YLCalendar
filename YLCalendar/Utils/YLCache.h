//
//  YLCache.h
//  YLCalendar
//
//  Created by 梁煜麟 on 2/28/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLCache : NSObject

+ (instancetype)cache;

+ (id)fetchObjectForKey:(id)key withCreator:(id(^)(void))block;

@end

NS_ASSUME_NONNULL_END
