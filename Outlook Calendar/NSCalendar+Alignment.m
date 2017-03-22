//
//  NSCalendar+Alignments.m
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 2/25/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#import "NSCalendar+Alignment.h"

@implementation NSCalendar (Alignment)

-(NSDate*) alignToFirstDayOfWeek:(NSDate*) date {
    NSDate *startOfTheWeek = nil;
    [self rangeOfUnit:NSCalendarUnitWeekOfMonth
                     startDate:&startOfTheWeek
                      interval:nil
                       forDate:date];
    return startOfTheWeek;
}


-(NSDate*) alignToLastDayOfWeek:(NSDate*) date {
    NSDate *startOfTheWeek = nil;
    NSTimeInterval interval = 0;
    [self rangeOfUnit:NSCalendarUnitWeekOfMonth
                     startDate:&startOfTheWeek
                      interval:&interval
                       forDate:date];
    return [self alignToStartOfDay:[startOfTheWeek dateByAddingTimeInterval:interval-1]];
}

-(NSDate*) alignToFirstDayOfNextWeek:(NSDate*) date {
    NSDate *startOfTheWeek = nil;
    NSTimeInterval interval = 0;
    [self rangeOfUnit:NSCalendarUnitWeekOfMonth
            startDate:&startOfTheWeek
             interval:&interval
              forDate:date];
    return [self alignToStartOfDay:[startOfTheWeek dateByAddingTimeInterval:interval+1]];
}

-(NSDate*) alignToFirstDayOfMonth:(NSDate*) date {
    NSDate *startOfMonth = nil;
    [self rangeOfUnit:NSCalendarUnitMonth
            startDate:&startOfMonth
             interval:nil
              forDate:date];
    return [self alignToStartOfDay:startOfMonth];
}

-(NSDate*) alignToLastDayOfMonth:(NSDate*) date {
    NSDate *startOfMonth = nil;
    NSTimeInterval interval = 0;
    [self rangeOfUnit:NSCalendarUnitMonth
                     startDate:&startOfMonth
                      interval:&interval
                       forDate:date];
    
    return [self alignToStartOfDay:[startOfMonth dateByAddingTimeInterval:interval-1]];
}

-(NSDate*) alignToFirstDayOfNextMonth:(NSDate*) date {
    NSDate *startOfMonth = nil;
    NSTimeInterval interval = 0;
    [self rangeOfUnit:NSCalendarUnitMonth
            startDate:&startOfMonth
             interval:&interval
              forDate:date];
    
    return [self alignToStartOfDay:[startOfMonth dateByAddingTimeInterval:interval+1]];
}


-(NSDate *) alignToStartOfDay:(NSDate *)date
{
    return [self startOfDayForDate:date];
}

-(NSDate *) alignToEndOfDay:(NSDate *)date
{
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.day = 1;
    //components.second = -1;
    return [self dateByAddingComponents:components toDate:[self startOfDayForDate:date] options:0];
}

@end
