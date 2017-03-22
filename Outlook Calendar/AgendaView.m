//
//  AgendaView.m
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 3/3/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#import "AgendaView.h"
#import "AgendaEventTableViewCell.h"
#import "NSCalendar+Alignment.h"
#import "NSCalendar+Arithmetic.h"
#import "AgendaSectionHeaderView.h"

#define kAgendaViewCell @"AgnedaViewCell"
#define kAgendaViewEmptyCell @"kAgendaViewEmptyCell"

@interface AgendaView()
@property (nonatomic,strong) UITableView* tableView;

@property (nonatomic,strong) NSCalendar* calendar;
@property (nonatomic,assign) BOOL isUserDriven;

@property (nonatomic,retain) NSDate* prevSelectedDate;
@end

@implementation AgendaView

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
    self.calendar = [NSCalendar currentCalendar];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // force the cells separators to have full width
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 30.0;
    [self.tableView registerNib:[UINib nibWithNibName:@"AgendaEventTableViewCell" bundle:nil] forCellReuseIdentifier:kAgendaViewCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kAgendaViewEmptyCell];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

-(NSDate*) dateFromSection:(NSUInteger) section {
    return [self.calendar dateByAddingNumberOfDays:section toDate:[self.datasource agendaViewStartDate:self]];
}

-(NSUInteger) sectionFromDate:(NSDate*) date {
    NSInteger res = [self.calendar daysFromDate:[self.datasource agendaViewStartDate:self] toDate:date];
    if(res < 0) {
        return NSNotFound;
    }else {
        return res;
    }
}

#pragma mark - datasource
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray<CalendarEvent*> *events = [self.datasource agendaView:self eventsInDay:[self dateFromSection:indexPath.section]];
    if(events.count > indexPath.row){
        
        AgendaEventTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:kAgendaViewCell forIndexPath:indexPath];
        [cell updateWithEvent: events[indexPath.row] ];
        return cell;
    }else {
        UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:kAgendaViewEmptyCell forIndexPath:indexPath];
        cell.textLabel.text = @"No Events";
        cell.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        

        return cell;
    }
}

#pragma mark - delegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* res  = [self.datasource agendaView:self eventsInDay:[self dateFromSection:section]];
    return MAX(1,res.count);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSDate* startDate = [self.datasource agendaViewStartDate:self];
    NSDate* endDate = [self.datasource agendaViewEndDate:self];
    if(startDate && endDate) {
        return [self.calendar daysFromDate:startDate toDate:endDate];
    }else {
        return 0;
    }
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    AgendaSectionHeaderView *secontHeaderView = [[AgendaSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, [self tableView:tableView heightForHeaderInSection:section])];
    [secontHeaderView setDate:[self dateFromSection:section]];
    return secontHeaderView;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 26;
}

#pragma mark - 
-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    // only send if selected by the user actions
    if(self.isUserDriven) {
        // only send when the date change, not to flood the observer
        if([self.prevSelectedDate isEqualToDate:self.topDate] == false) {
            [self.delegate agendaView:self didSelectDate:self.topDate];
            self.prevSelectedDate = self.topDate;
        }
        [self.delegate agendaViewDidScroll:self];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isUserDriven = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(decelerate == false) {
        self.isUserDriven = NO;
        [self.delegate agendaViewDidStopAnimation:self];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    // Snap to the start of the Cell
    NSIndexPath *pathForTargetTopCell = [self.tableView indexPathForRowAtPoint:CGPointMake(CGRectGetMidX(self.tableView.bounds), targetContentOffset->y)];
    targetContentOffset->y = [self.tableView rectForRowAtIndexPath:pathForTargetTopCell].origin.y - [self tableView:self.tableView heightForHeaderInSection:0];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.isUserDriven = NO;
    [self.delegate agendaViewDidStopAnimation:self];
}

#pragma mark -
-(NSDate*) topDate {
    NSIndexPath* topIndexPath = [self.tableView indexPathForRowAtPoint:CGPointMake(0, self.tableView.contentOffset.y)]
    ;
    return [self dateFromSection:topIndexPath.section];
}

-(void) scrollToDate:(NSDate*) date {
    NSInteger currentSection = [self.calendar daysFromDate:[self.datasource agendaViewStartDate:self] toDate:date];
    if(currentSection>=0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:currentSection] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(void) reloadDataAndSelectDate:(NSDate*) date {
    [UIView performWithoutAnimation:^{
        [UIView animateWithDuration:0.0 animations:^{
            [self.tableView reloadData];
        } completion:^(BOOL finished) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:[self sectionFromDate:date]] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }];
    }];
}
@end
