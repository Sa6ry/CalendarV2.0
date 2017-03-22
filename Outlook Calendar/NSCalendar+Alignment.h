//
//  NSCalendar+Align.h
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 2/25/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (Alignment)

-(NSDate*) alignToFirstDayOfWeek:(NSDate*) date;
-(NSDate*) alignToLastDayOfWeek:(NSDate*) date;
-(NSDate*) alignToFirstDayOfMonth:(NSDate*) date;
-(NSDate*) alignToFirstDayOfNextMonth:(NSDate*) date;
-(NSDate*) alignToFirstDayOfNextWeek:(NSDate*) date;
-(NSDate*) alignToLastDayOfMonth:(NSDate*) date;
-(NSDate *) alignToStartOfDay:(NSDate *)date;
-(NSDate *) alignToEndOfDay:(NSDate *)date;
@end
