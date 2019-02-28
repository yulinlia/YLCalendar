//
//  UIImage+YLUtil.h
//  Pods
//
//  Created by 梁煜麟 on 2/28/19.
//

#import <UIKit/UIKit.h>

#ifndef UIImage_YLUtil_h
#define UIImage_YLUtil_h

@interface UIImage (YLUtil)

+ (UIImage *)lineImageWithKey:(NSString *)key frame:(CGRect)frame color:(UIColor *)color;

+ (UIImage *)circleImageWithKey:(NSString *)key frame:(CGRect)frame color:(UIColor *)color;

@end

#endif /* UIImage_YLUtil_h */
