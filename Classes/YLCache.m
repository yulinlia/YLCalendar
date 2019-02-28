//
//  YLCache.m
//  YLCalendar
//
//  Created by 梁煜麟 on 2/28/19.
//

#import "YLCache.h"

@interface YLCache ()

@property(nonatomic, strong)NSCache *cache;

@end

@implementation YLCache

+ (instancetype)cache {
    static YLCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[self alloc] init];
    });
    
    return cache;
}

+ (id)fetchObjectForKey:(id)key withCreator:(id(^)(void))block {
    YLCache *cacheMgr = [self cache];
    id fetchedObject = [cacheMgr.cache objectForKey:key];
    if (!fetchedObject) {
        fetchedObject = block();
        [cacheMgr.cache setObject:fetchedObject forKey:key];
    }
    
    return fetchedObject;
}

- (instancetype)init {
    if (self = [super init]) {
        self.cache = [[NSCache alloc] init];
    }
    
    return self;
}

@end

