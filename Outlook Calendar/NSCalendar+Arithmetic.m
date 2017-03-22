//
//  NSCalendar+Arithmetic.m
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 2/25/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#import "NSCalendar+Arithmetic.h"

@implementation NSCalendar (Arithmetic)

- (NSInteger) daysFromDate:(NSDate*)fromDateTime toDate:(NSDate*)toDateTime
{
    return [[self components:NSCalendarUnitDay
                             fromDate:fromDateTime toDate:toDateTime options:0] day];
}

-(NSDate*) dateByAddingNumberOfDays:(NSInteger) noOfDays toDate:(NSDate*) date {
    NSDateComponents *comp = [NSDateComponents new];
    comp.day = noOfDays;
    return [self dateByAddingComponents:comp toDate:date options:0];
}

-(NSDate*) dateByAddingNumberOfMonths:(NSInteger) noOfMonths toDate:(NSDate*) date {
    NSDateComponents *comp = [NSDateComponents new];
    comp.month = noOfMonths;
    return [self dateByAddingComponents:comp toDate:date options:0];
}

-(NSDate*) dateByAddingNumberOfWeeks:(NSInteger) noOfWeeks toDate:(NSDate*) date {
    NSDateComponents *comp = [NSDateComponents new];
    comp.day = 7*noOfWeeks;
    return [self dateByAddingComponents:comp toDate:date options:0];
}


@end
