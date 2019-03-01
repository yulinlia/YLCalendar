//
//  YLCalendarView.m
//  YLCalendar
//
//  Created by 梁煜麟 on 2/28/19.
//

#import "YLCalendarView.h"
#import "YLCalendarModel.h"
#import "NSCalendar+Util.h"
#import "YLCalendarHeaderView.h"
#import "YLCalendarCollectionViewCell.h"

#define YLCALENDAR_CELL_ID @"YLCalendar_cell"
#define YLCALENDAR_HEADER_ID @"YLCalendar_header"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface YLCalendarView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong)NSCalendar *calendar;
@property(nonatomic, strong)NSMutableDictionary *dataSourceDic;
@property(nonatomic, strong)NSMutableArray *sections;

@property(nonatomic, strong)YLCalendarModel *startDateModel;
@property(nonatomic, strong)YLCalendarModel *todayModel;
@property(nonatomic, strong)YLCalendarModel *endDateModel;
@property(nonatomic, assign)NSInteger centerSection;

@property(nonatomic, assign)CGPoint lastOffsetPoint;
@property(nonatomic, assign)NSTimeInterval lastOffsetCapture;

@end

@implementation YLCalendarView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame collectionViewLayout:nil];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame]) {
        [self commonInitializer:layout];
    }
    
    return self;
}

- (void)commonInitializer:(UICollectionViewLayout *)layout {
    [self initializeCalendarCollectionView:layout];
    [self initializeCalendarDataSource];
}

- (void)initializeCalendarDataSource {
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    _calendar.locale = [NSLocale currentLocale];
    
    _sections = [NSMutableArray array];
    _dataSourceDic = [NSMutableDictionary dictionary];
    
    _centerSection = 6;
    NSDate *now = [NSDate date];
    _todayModel = [[YLCalendarModel alloc] initWithDate:now];
    
    NSDate *startDate = [self.calendar dateWithOffset:-6 fromDate:now withUnit:YLCalendarUnitMonth];
    _startDateModel = [[YLCalendarModel alloc] initWithDate:startDate];
    
    NSDate *endDate = [self.calendar dateWithOffset:6 fromDate:now withUnit:YLCalendarUnitMonth];
    _endDateModel = [[YLCalendarModel alloc] initWithDate:endDate];
    [self reloadDataSource];
    
    [self scrollToToday];
}

- (void)initializeCalendarCollectionView: (UICollectionViewLayout *)layout {
    if (!layout) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    }
    else {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    }
    
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[YLCalendarHeaderView class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:YLCALENDAR_HEADER_ID];
    [_collectionView registerClass:[YLCalendarCollectionViewCell class] forCellWithReuseIdentifier:YLCALENDAR_CELL_ID];
    [self addSubview:_collectionView];
}

- (void)reloadDataSource {
    [self.sections removeAllObjects];
    
    NSInteger distance = [self.calendar distanceFromDate:self.startDateModel.date toDate:self.endDateModel.date withUnit:YLCalendarUnitMonth];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy MMM";
    for (int i = 0; i <= distance; i++) {
        //prepare the data of sections
        NSDateComponents *component = [NSDateComponents new];
        component.month = i;
        NSDate *monthDate = [self.calendar dateByAddingComponents:component toDate:self.startDateModel.date options:0];
        NSString *monthStr = [formatter stringFromDate:monthDate];
        [self.sections addObject:monthStr];
        
        //prepare the model of each items for each section
        if ([self.dataSourceDic objectForKey:monthStr])
            continue;
        
        int totalWeeks = (int)[self.calendar numberOfWeeksInMonth:monthDate];
        NSMutableArray<YLCalendarModel *> *arr = [NSMutableArray array];
        
        for (int i = 0; i < totalWeeks * 7; i++) {
            NSDate *modelDate = [self.calendar dateByOffset:i ofDate:monthDate];
            YLCalendarModel *model = [[YLCalendarModel alloc] initWithDate:modelDate fromDate:monthDate];
            model.isToday = [model isSameDate:self.todayModel];
            [arr addObject:model];
        }
        
        [self.dataSourceDic setValue:arr forKey:monthStr];
    }
}

- (void)appendDate:(BOOL)isFromTop {
    UICollectionView *cv = self.collectionView;
    UICollectionViewLayout *cvLayout = cv.collectionViewLayout;
    
    NSArray *visibleCells = [self.collectionView visibleCells];
    if (![visibleCells count])
        return;
    
    //get the original top section information
    NSIndexPath *fromIndexPath = [self.collectionView indexPathForCell:(UICollectionViewCell *)visibleCells[0]];
    NSInteger fromSection = fromIndexPath.section;
    NSDate *fromDate = [self firstDayInSection:fromSection];
    UICollectionViewLayoutAttributes *fromAttrs = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:fromSection]];
    CGPoint fromSectionOrigin = [self convertPoint:fromAttrs.frame.origin fromView:self.collectionView];
    
    if (isFromTop) {
        NSDate *updatedStartDate = [self.calendar dateWithOffset:-6 fromDate:self.startDateModel.date withUnit:YLCalendarUnitMonth];
        self.startDateModel = [[YLCalendarModel alloc] initWithDate:updatedStartDate];
    }
    else {
        NSDate *updatedEndDate = [self.calendar dateWithOffset:6 fromDate:self.endDateModel.date withUnit:YLCalendarUnitMonth];
        self.endDateModel = [[YLCalendarModel alloc] initWithDate:updatedEndDate];
    }
    
    [self reloadDataSource];
    [self reloadData];
    
    //since the layout may not be update immediately, so we call function [cvLayout invalidateLayout] to modify the layout immediately.
    [cvLayout invalidateLayout];
    [cvLayout prepareLayout];
    
    NSInteger toSection = [self.calendar distanceFromDate:[_calendar firstDayInMonth:self.startDateModel.date] toDate:fromDate withUnit:YLCalendarUnitMonth];
    UICollectionViewLayoutAttributes *toAttrs = [cvLayout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:toSection]];
    CGPoint toSectionOrigin = [self convertPoint:toAttrs.frame.origin fromView:cv];
    
    CGFloat scrollOffset = toSectionOrigin.y - fromSectionOrigin.y;
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y + scrollOffset)];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.sections count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSString *monthStr = [self.sections objectAtIndex:section];
    return [[self.dataSourceDic objectForKey:monthStr] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YLCalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YLCALENDAR_CELL_ID forIndexPath:indexPath];
    
    NSString *monthStr = [self.sections objectAtIndex:indexPath.section];
    YLCalendarModel *model = [[self.dataSourceDic objectForKey:monthStr] objectAtIndex:indexPath.row];
    
    [cell setModel:model isCenter:indexPath.section == self.centerSection];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        YLCalendarHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:YLCALENDAR_HEADER_ID forIndexPath:indexPath];
        
        NSString *monthStr = [self.sections objectAtIndex:indexPath.section];
        [headerView setModel:monthStr isCenter:self.centerSection == indexPath.section];
        
        return headerView;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH / 7, SCREEN_WIDTH / 7);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat width = CGRectGetWidth(collectionView.frame);
    CGFloat height = 64.0f;
    return CGSizeMake(width, height);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        UICollectionView *contentView = (UICollectionView *)scrollView;
        
        CGFloat contentHeight = contentView.contentSize.height;
        CGFloat contentOffsetY = contentView.contentOffset.y;
        CGFloat visibleViewHeight = contentView.bounds.size.height;
        
        //scroll to the top, append more 6 past monthes
        if (contentView.contentOffset.y < 0) {
            [self appendDate:YES];
        }
        else if (contentHeight - contentOffsetY < visibleViewHeight) {
            [self appendDate:NO];
        }
        
        CGPoint currentOffset = scrollView.contentOffset;
        NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
        
        NSTimeInterval timeDiff = currentTime - _lastOffsetCapture;
        if (timeDiff > 0.1) {
            CGFloat distance = currentOffset.y - self.lastOffsetPoint.y;
            CGFloat speed = fabs(distance * 10 / 1000);
            if (speed < 0.9) {
                [self highlightCenteredMonth];
            }
            
            self.lastOffsetPoint = scrollView.contentOffset;
            self.lastOffsetCapture = [NSDate timeIntervalSinceReferenceDate];
        }
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.lastOffsetPoint = scrollView.contentOffset;
    self.lastOffsetCapture = [NSDate timeIntervalSinceReferenceDate];
}

- (void)highlightCenteredMonth {
    CGPoint centerPoint = CGPointMake(self.collectionView.center.x + self.collectionView.contentOffset.x, self.collectionView.center.y + self.collectionView.contentOffset.y);
    
    NSIndexPath *centerIndexPath = [self.collectionView indexPathForItemAtPoint:centerPoint];
    if (centerIndexPath.section == 0 && centerIndexPath.row == 0)
        return;
    
    if (centerIndexPath.section == self.centerSection)
        return ;
    
    NSMutableIndexSet *indexSets = [NSMutableIndexSet indexSet];
    [indexSets addIndex:self.centerSection];
    [indexSets addIndex:centerIndexPath.section];
    
    self.centerSection = centerIndexPath.section;
    
    [self.collectionView reloadSections:indexSets];
}

#pragma mark - Helper Functions
- (NSDate *)firstDayInSection:(NSInteger)section {
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.startDateModel.date];
    components.day = 1;
    components.month = self.startDateModel.month + section;
    return [self.calendar dateFromComponents:components];
}

- (NSIndexPath *)indexPathForToday {
    NSInteger sectionIndex = [self.calendar distanceFromDate:self.startDateModel.date toDate:self.todayModel.date withUnit:YLCalendarUnitMonth];
    NSMutableArray *arr = [self.dataSourceDic objectForKey:[self.sections objectAtIndex:sectionIndex]];
    for (int i = 0; i < arr.count; i++) {
        YLCalendarModel *model = [arr objectAtIndex:i];
        if (model.day == self.todayModel.day && model.month == self.todayModel.month && model.year == self.todayModel.year)
            return [NSIndexPath indexPathForRow:i inSection:sectionIndex];
    }
    
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)scrollToToday {
    NSIndexPath *todayIndexPath = [self indexPathForToday];
    
    CGRect dateItemRect = [self frameForItemAtIndexPath:todayIndexPath];
    CGRect monthSectionHeaderRect = [self frameForHeaderForSection:todayIndexPath.section];
    
//    CGFloat delta = CGRectGetMaxY(dateItemRect) - CGRectGetMinY(monthSectionHeaderRect);
//    CGFloat actualViewHeight = CGRectGetHeight(self.collectionView.frame) - self.collectionView.contentInset.top - self.collectionView.contentInset.bottom;
    
    CGRect headerRect = [self frameForHeaderForSection:todayIndexPath.section];
    CGPoint topOfHeader = CGPointMake(0, headerRect.origin.y - _collectionView.contentInset.top);
    [_collectionView setContentOffset:topOfHeader animated:NO];
}

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
    
    return attributes.frame;
}

- (CGRect)frameForHeaderForSection:(NSInteger)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    
    return attributes.frame;
}


@end

