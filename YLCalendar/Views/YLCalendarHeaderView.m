//
//  YLCalendarHeaderView.m
//  YLCalendar
//
//  Created by 梁煜麟 on 2/28/19.
//

#import "YLCalendarHeaderView.h"

@implementation YLCalendarHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInitializer];
    }
    
    return self;
}

- (void)commonInitializer {
    _headerLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _headerLabel.textAlignment = NSTextAlignmentCenter;
    _headerLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:_headerLabel];
}

- (void)setModel:(NSString *)text isCenter:(BOOL)isCenter {
    if (isCenter) {
        _headerLabel.textColor = [UIColor blackColor];
    }
    else {
        _headerLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    
    _headerLabel.text = text;
}

@end

