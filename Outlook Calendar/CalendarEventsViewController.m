
//
//  CalendarEventsViewController.m
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 2/26/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#import "CalendarEventsViewController.h"
#import "CalendarView.h"
#import "AgendaView.h"
#import "CalendarDataSource.h"

#define CALENDAR_EXPANDED_ROWS 4
#define CALENDAR_SHRINKED_ROWS 2

@interface CalendarEventsViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarHeightConstraint;
@property (weak, nonatomic) IBOutlet CalendarView *calendarView;
@property (weak, nonatomic) IBOutlet AgendaView *agendaView;
@property (nonatomic,retain) CalendarDataSource* calendarDataSource;

@property (weak, nonatomic) IBOutlet UILabel *currentDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedDateLabel;

@property (nonatomic, assign) CGFloat calendarHeight;

@end

@implementation CalendarEventsViewController

-(void) loadView {
    
    [super loadView];
    
    // load our datasour and connect our delegates
    NSDate* startDate = [[NSDate date] dateByAddingTimeInterval:-60*60*24*30*12*2];
    NSDate* endDate = [[NSDate date] dateByAddingTimeInterval:60*60*24*30*12*2];
    self.calendarDataSource = [[CalendarDataSource alloc] initWithStartDate:startDate endDate:endDate completion:^(NSError *error) {
        if(error == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.calendarView.delegate = self;
                self.calendarView.dataSource = self;
                self.agendaView.delegate = self;
                self.agendaView.datasource = self;
                [self.agendaView reloadDataAndSelectDate:[NSDate date]];
                [self.calendarView reloadDataAndSelectDate:[NSDate date]];
                [self updateTitleWithDate:[NSDate date]];
            });
            
        }else {
            // show an error message
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIView performWithoutAnimation:^{
        [self setCalendarHeight:self.calendarView.rowHeight*CALENDAR_EXPANDED_ROWS];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // update the navigation bar item with the current date
    NSInteger day = [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:[NSDate date]] day];
    self.currentDayLabel.text = [NSString stringWithFormat:@"%ld",(long)day];
}

#pragma mark - Helpers

-(void) setCalendarHeight:(CGFloat) height {
    if(self.calendarHeightConstraint.constant != height) {
        self.calendarHeightConstraint.constant = height;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.view layoutIfNeeded];
        }completion:nil];
    }
}

-(CGFloat) calendarHeight {
    return self.calendarHeightConstraint.constant;
}


-(void) updateTitleWithDate:(NSDate*) date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM YYYY"];
    NSString* formatedTitle = [dateFormatter stringFromDate:date];
    self.selectedDateLabel.text = formatedTitle;
}

#pragma mark - CalendarDataSource
-(NSUInteger) calendarView:(CalendarView *)calenderView noOfEventsInDay:(NSDate *)date {
    // this method is async, for now return 0, then update it later
    return [self.calendarDataSource getEventsCountForDay:date];
}
-(NSDate*) calendarViewStartDate:(CalendarView *)calenderView {
    return self.calendarDataSource.startDate;
}

-(NSDate*) calendarViewEndDate:(CalendarView *)calenderView {
    return self.calendarDataSource.endDate;
}

#pragma mark - CalendarDelegate
- (void) calendarView:(CalendarView *)calenderView didSelectDate:(NSDate *)date {
    
    // update the day events
    [self updateTitleWithDate:calenderView.selectedDay];
    [self.agendaView scrollToDate:date];
    [self setCalendarHeight:self.calendarView.rowHeight*CALENDAR_EXPANDED_ROWS];
    //[self.agendaView reloadWithEvents:[self.calendarDataSource getEventsForDay:date]];
}

- (void) calendarViewDidScroll:(CalendarView *)calenderView {
    
    [self setCalendarHeight:self.calendarView.rowHeight*CALENDAR_EXPANDED_ROWS];
    [self updateTitleWithDate:calenderView.selectedDay];
}

-(void) calendarViewDidStopAnimation:(CalendarView *)calenderView
{
    [self updateTitleWithDate:calenderView.selectedDay];
    // change the size of the header
    // [self updateCalendarHeight];
}

#pragma mark - agenda delegates
-(void) agendaView:(AgendaView *)agendaView didSelectDate:(NSDate *) date {
    //we have to select this date in the calendar view
    //NSLog(@"%@",[date description]);
    [self setCalendarHeight:self.calendarView.rowHeight*CALENDAR_SHRINKED_ROWS];
    [self.calendarView setSelectedDay:date smallChange:YES];
    [self updateTitleWithDate:date];
}

-(void) agendaViewDidStopAnimation:(AgendaView *)agendaView
{
    
}

-(void) agendaViewDidScroll:(AgendaView *)agendaView
{
    
}
#pragma mark - agenda datasour
- (NSArray<CalendarEvent*>*) agendaView:(AgendaView *)calenderView eventsInDay:(NSDate * )date {
    return [self.calendarDataSource getEventsForDay:date];
}
-(NSDate*) agendaViewStartDate:(AgendaView *)calenderView {
    return self.calendarDataSource.startDate;
}
-(NSDate*) agendaViewEndDate:(AgendaView *)calenderView {
    return self.calendarDataSource.endDate;
}

#pragma mark - Toolbar Events

- (IBAction)onAlternateStyle:(id)sender {
    if(self.calendarHeight == self.calendarView.rowHeight*CALENDAR_SHRINKED_ROWS) {
        [self setCalendarHeight:self.calendarView.rowHeight*CALENDAR_EXPANDED_ROWS];
    }else {
        [self setCalendarHeight:self.calendarView.rowHeight*CALENDAR_SHRINKED_ROWS];
    }
    [self.calendarView updateSelectedItem];
    [self.agendaView scrollToDate:self.calendarView.selectedDay];
}

- (IBAction)onSnapToCurrentDate:(id)sender {
    [self.calendarView setSelectedDay:[NSDate date] smallChange:NO];
    [self.agendaView scrollToDate:[NSDate date]];
}

- (IBAction)onCreateNewEvent:(id)sender {
    
    UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"TODO: Add new calendar event here"  message:nil  preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
