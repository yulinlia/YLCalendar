//
//  YLCalendarCollectionViewCell.m
//  YLCalendar
//
//  Created by 梁煜麟 on 2/28/19.
//

#import "YLCalendarCollectionViewCell.h"
#import "YLCalendarModel.h"
#import "UIImage+YLUtil.h"

@interface YLCalendarCollectionViewCell()

@property(nonatomic, strong)UILabel *dateLabel;
@property(nonatomic, strong)UIImageView *dividorView;
@property(nonatomic, strong)UIImageView *overlayView;
@property(nonatomic, strong)YLCalendarModel *model;

@end

@implementation YLCalendarCollectionViewCell

#define DIVIDOR_KEY @"YLCalendarCell_dividor_key_%@"
#define OVERLAY_KEY @"YLCalendarCell_overlay_key_%@"

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInitilizer];
    }
    
    return self;
}

- (void)commonInitilizer {
    CGFloat offsetY = 0;
    CGFloat offsetX = 0;
    CGFloat width = self.frame.size.width;
    CGFloat height = 1;
    self.dividorView = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX, offsetY, width, height)];
    [self.dividorView setBackgroundColor:[UIColor redColor]];
    NSString *dividorKey = [NSString stringWithFormat:DIVIDOR_KEY, [[self dividorColor] description]];
    self.dividorView.image = [UIImage lineImageWithKey:dividorKey frame:self.dividorView.frame color:[self dividorColor]];
    [self addSubview:self.dividorView];
    
    CGFloat overlayOffset = 5;
    CGFloat radius = self.frame.size.width - overlayOffset * 2;
    self.overlayView = [[UIImageView alloc] initWithFrame:CGRectMake(overlayOffset, overlayOffset, radius, radius)];
    NSString *overlayKey = [NSString stringWithFormat:OVERLAY_KEY, [[self todayImageColor] description]];
    self.overlayView.image = [UIImage circleImageWithKey:overlayKey frame:self.overlayView.frame color:[self todayImageColor]];
    [self addSubview:self.overlayView];
    
    self.dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.dateLabel.font = [UIFont systemFontOfSize:20];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.dateLabel];
}

- (void)setModel:(YLCalendarModel *)model isCenter:(BOOL)isCenter {
    self.model = model;
    if (isCenter) {
        self.dateLabel.textColor = [UIColor blackColor];
    }
    else {
        self.dateLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (self.model.isSameMonth) {
        self.dateLabel.hidden = false;
        self.dateLabel.text = [NSString stringWithFormat:@"%ld", (long)self.model.day];
        self.dividorView.hidden = false;
        
        if (self.model.isToday) {
            self.overlayView.hidden = false;
        }
        else {
            self.overlayView.hidden = true;
        }
    }
    else {
        self.dateLabel.hidden = true;
        self.dividorView.hidden = true;
        self.overlayView.hidden = true;
    }
    
    
}

- (UIColor *)dividorColor {
    return [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0f];
}

- (UIColor *)todayImageColor
{
    return [UIColor colorWithRed:0/255.0f green:121/255.0f blue:255/255.0f alpha:1.0f];
}

@end

