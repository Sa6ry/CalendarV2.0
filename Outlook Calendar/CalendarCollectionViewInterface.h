//
//  CalendarCollectionViewInterface.h
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 3/3/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#ifndef CalendarCollectionViewInterface_h
#define CalendarCollectionViewInterface_h

@class CalendarView;

// Events comming out from the control
@protocol CalenderCollectionViewDelegate <NSObject>
@optional
- (void)calendarView:(CalendarView * )calenderView didSelectDate:(NSDate *  )date;
- (void)calendarViewDidScroll:(CalendarView * )calenderView;
- (void)calendarViewDidStopAnimation:(CalendarView * )calenderView;
@end

// Feed the control with data through these methods
@protocol CalenderCollectionViewDataSource <NSObject>
- (NSUInteger) calendarView:(CalendarView * )calenderView noOfEventsInDay:(NSDate *  )date;
- (NSDate*) calendarViewStartDate:(CalendarView * )calenderView;
- (NSDate*) calendarViewEndDate:(CalendarView * )calenderView;
@end

// Drive the control through these methods
@protocol CalenderCollectionViewInterface <NSObject>
@property (nonatomic, weak) id <CalenderCollectionViewDelegate> delegate;
@property (nonatomic, weak) id <CalenderCollectionViewDataSource> dataSource;
@end

#endif /* CalendarCollectionViewInterface_h */
