//
//  NSCalendar+Arithmetic.h
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 2/25/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (Arithmetic)

-(NSInteger) daysFromDate:(NSDate*)fromDateTime toDate:(NSDate*)toDateTime;
-(NSDate*) dateByAddingNumberOfDays:(NSInteger) noOfDays toDate:(NSDate*) date;
-(NSDate*) dateByAddingNumberOfMonths:(NSInteger) noOfMonths toDate:(NSDate*) date;
-(NSDate*) dateByAddingNumberOfWeeks:(NSInteger) noOfWeeks toDate:(NSDate*) date;
@end
