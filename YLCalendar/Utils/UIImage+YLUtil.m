//
//  UIImage+YLUtil.m
//  YLCalendar
//
//  Created by 梁煜麟 on 2/28/19.
//

#import "UIImage+YLUtil.h"
#import "YLCache.h"

@implementation UIImage (YLUtil)

+ (UIImage *)lineImageWithKey:(NSString *)key frame:(CGRect)frame color:(UIColor *)color {
    UIImage *lineImage = [YLCache fetchObjectForKey:key withCreator:^id{
        UIGraphicsBeginImageContextWithOptions(frame.size, NO, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, frame);
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }];
    
    return lineImage;
}

+ (UIImage *)circleImageWithKey:(NSString *)key frame:(CGRect)frame color:(UIColor *)color {
    UIImage *circleImage = [YLCache fetchObjectForKey:key withCreator:^id{
        UIGraphicsBeginImageContextWithOptions(frame.size, NO, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGRect rect = frame;
        rect.origin = CGPointZero;
        
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillEllipseInRect(context, rect);
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }];
    
    return circleImage;
}

@end

