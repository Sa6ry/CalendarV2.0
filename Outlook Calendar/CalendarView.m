//
//  CalenderView.m
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 2/24/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#import "CalendarView.h"
#import "CalenderCollectionViewDynamicLayout.h"
#import "CalendarCollectionViewCell.h"
#import "NSCalendar+Alignment.h"
#import "NSCalendar+Arithmetic.h"

#define kCalenderViewCell @"CalendarCollectionViewCell"

@interface CalendarView()
@property (nonatomic,readonly) CalenderCollectionViewDynamicLayout* collectionViewDynamicLayout;
@property (nonatomic,retain) NSCalendar* calender;
@property (nonatomic,readonly) NSIndexPath* firstVisibleIndexPath;
@property (nonatomic,readonly) NSIndexPath* lastVisibleIndexPath;
@property (nonatomic,readonly) NSIndexPath* selectedIndexPath;

@property (nonatomic,strong) UICollectionView* collectionView;
@property (nonatomic,assign) BOOL isUserDriven;

@end

@implementation CalendarView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadContent];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self loadContent];
    }
    return self;
}

// Load content from the xib file
-(void) loadContent {
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:[[CalenderCollectionViewDynamicLayout alloc] init]];
    self.collectionViewDynamicLayout.rowHeight = 44.0;
    self.collectionViewDynamicLayout.topPadding = self.collectionViewDynamicLayout.rowHeight*6.5;
    self.collectionViewDynamicLayout.bottomPadding = self.collectionViewDynamicLayout.rowHeight*5.5;
    self.collectionView.bounces = NO;
    self.calender = [NSCalendar currentCalendar];
    //self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.directionalLockEnabled = YES;
    // Seperator color
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.clipsToBounds = YES;
    //self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CalendarCollectionViewCell" bundle:nil]  forCellWithReuseIdentifier:kCalenderViewCell];
    //  [self setSelectedDay:[NSDate date] smallChange:NO];
    [self addSubview:self.collectionView];
}

-(CGFloat) rowHeight {
    return self.collectionViewDynamicLayout.rowHeight;
}

#pragma mark -

-(NSDate*) selectedDay {
    NSIndexPath* selectedIndexPath = self.collectionView.indexPathsForSelectedItems.firstObject;
    if(selectedIndexPath) {
        return [self.collectionViewDynamicLayout dateForItemAtIndexPath:selectedIndexPath];
    }else {
        return nil;
    }
}

// call smallChange = YES if the new selected day is near the new selected one,
// scroll instantaneously even if the user finger is down
-(void) setSelectedDay:(NSDate *)selectedDay smallChange:(BOOL) smallChange {
    NSIndexPath * indexPath = [self.collectionViewDynamicLayout indexPathForDate:selectedDay];
    if(smallChange) {
        [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredVertically];
        } completion:nil];
    }else {
        [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
    }
}

-(NSArray<NSIndexPath*>*) indexPathsForVisibleItems {
    CGRect visibleRect = CGRectMake(0,
                                    self.collectionView.contentOffset.y+self.collectionViewDynamicLayout.topPadding,
                                    self.bounds.size.width,
                                    self.bounds.size.height);
    return [[self.collectionView.indexPathsForVisibleItems filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSIndexPath*  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        
        CGRect evaluatedFrame = [self.collectionViewDynamicLayout layoutAttributesForItemAtIndexPath:evaluatedObject].frame;
        return CGRectIntersectsRect(visibleRect, evaluatedFrame);
    }]] sortedArrayUsingSelector:@selector(compare:)];
}

-(NSIndexPath*) firstVisibleIndexPath {
    return self.indexPathsForVisibleItems.firstObject;
}
-(NSIndexPath*) lastVisibleIndexPath {
    return self.indexPathsForVisibleItems.lastObject;
}
-(NSIndexPath*) selectedIndexPath {
    return self.collectionView.indexPathsForSelectedItems.firstObject;
}

-(BOOL) updateSelectedItem {
    //////////////////////////////////////////
    // Make sure the selected item is visible
    //////////////////////////////////////////
    if([self.indexPathsForVisibleItems containsObject:self.selectedIndexPath] == false) {
        //select the first visible item
        NSInteger newRow = self.selectedIndexPath.row;

        while (newRow < self.firstVisibleIndexPath.row) { newRow+=7;}
        while (newRow > self.lastVisibleIndexPath.row) { newRow-=7;}
        
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:newRow inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        return true;
    }
    return false;
}

#pragma mark -

-(BOOL) scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    [self setSelectedDay:[NSDate date] smallChange:NO];
    return false;
}

#pragma mark -
-(CalenderCollectionViewDynamicLayout*) collectionViewDynamicLayout {
    return (CalenderCollectionViewDynamicLayout*) self.collectionView.collectionViewLayout;
}

-(void) layoutSubviews {
    [super layoutSubviews];
    // add extra top and bottom margin to provide smooth animation
    // forcing loading cells offscreen
    CGRect frame = self.bounds;
    frame = CGRectMake(frame.origin.x,
                       frame.origin.y - self.collectionViewDynamicLayout.topPadding,
                       frame.size.width,
                       frame.size.height + self.collectionViewDynamicLayout.topPadding + self.collectionViewDynamicLayout.bottomPadding);
    self.collectionView.frame = frame;
}

#pragma mark - senders

-(void) onScrollStop {
    if([self.delegate respondsToSelector:@selector(calendarViewDidStopAnimation:)]) {
        [self.delegate performSelector:@selector(calendarViewDidStopAnimation:) withObject:self];
    }
}
-(void) onScroll {
    if([self.delegate respondsToSelector:@selector(calendarViewDidScroll:)]) {
        [self.delegate performSelector:@selector(calendarViewDidScroll:) withObject:self];
    }
}
-(void) onDaySelect:(NSDate*) date {
    if([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
        [self.delegate performSelector:@selector(calendarView:didSelectDate:) withObject:self withObject:date];
    }
}

#pragma mark - Datasource
-(NSUInteger) calendarView:(CalendarView *)calenderView noOfEventsInDay:(NSDate *)date {
    return [self.dataSource calendarView:self noOfEventsInDay:date];
}
-(NSDate*) calendarViewStartDate:(CalendarView *)calenderView {
    return [self.dataSource calendarViewStartDate:self];
}
-(NSDate*) calendarViewEndDate:(CalendarView *)calenderView {
    return [self.dataSource calendarViewEndDate:self];
}

#pragma mark - delegates

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isUserDriven = YES;
    [self onScroll];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate == false) {
        self.isUserDriven = NO;
    }
    [self onScroll];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.isUserDriven) {
        [self updateSelectedItem];
        [self onScroll];
    }
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.isUserDriven = NO;
    //[self updateSelectedItem];
    [self onDaySelect:self.selectedDay];
    [self onScrollStop];
    
}

-(void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //[self updateSelectedItem];
    [self onDaySelect:self.selectedDay];
    [self onScrollStop];
}
#pragma mark - delegate

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //  [self onDaySelect:[self.collectionViewDynamicLayout dateForItemAtIndexPath:indexPath]];
    [self onDaySelect:self.selectedDay];
}
#pragma mark - Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDate* startDate = [self.dataSource calendarViewStartDate:self];
    NSDate* endDate = [self.dataSource calendarViewEndDate:self];
    if(startDate && endDate) {
        return [self.calender daysFromDate:startDate toDate:endDate];
    }else {
        return 0;
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCollectionViewCell * cell = (id)[collectionView dequeueReusableCellWithReuseIdentifier:kCalenderViewCell forIndexPath:indexPath];
    [cell setNoOfEvents:[self.dataSource calendarView:self noOfEventsInDay:cell.date]];
    return cell;
}

#pragma mark -


-(void) reloadDataAndSelectDate:(NSDate*) date {
    [UIView performWithoutAnimation:^{
        [self.collectionView performBatchUpdates:^{
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        } completion:^(BOOL finished) {
            [self.collectionView selectItemAtIndexPath:[self.collectionViewDynamicLayout indexPathForDate:date] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredVertically];
        }];
    }];
}

@end
