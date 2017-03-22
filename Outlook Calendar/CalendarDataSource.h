//
//  CalendarDataSource.h
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 3/3/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarEvent.h"

@class CalendarDataSource;

@interface CalendarDataSource : NSObject

-(instancetype) initWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate completion:(void (^ )(NSError *error))completion;

-(NSArray<CalendarEvent*> * ) getEventsForDay:(NSDate*) date;
-(NSUInteger) getEventsCountForDay:(NSDate*) date;

@property (nonatomic, readonly) NSDate* startDate;
@property (nonatomic, readonly) NSDate* endDate;
@property (nonatomic, readonly) NSUInteger noOfDays;

@end
