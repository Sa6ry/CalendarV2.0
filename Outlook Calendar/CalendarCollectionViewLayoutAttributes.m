//
//  CalendarCollectionViewLayoutAttributes.m
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 2/26/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#import "CalendarCollectionViewLayoutAttributes.h"

@implementation CalendarCollectionViewLayoutAttributes

- (id)copyWithZone:(NSZone *)zone
{
    CalendarCollectionViewLayoutAttributes* copy = [super copyWithZone:zone];
    copy.date = self.date;
    copy.calendar = self.calendar;
    return copy;
}

-(NSUInteger) day {
    return [self.calendar component:NSCalendarUnitDay fromDate:self.date];
}

-(CalendarCellBackgroundStyle) backgroundStyle {
    
    return ([self.calendar ordinalityOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:self.date] % 2) ? CalendarCellBackgroundLight : CalendarCellBackgroundDark;
}

-(BOOL) isToday {
    return [self.calendar isDateInToday:self.date];
}

-(BOOL) isInCurrentYear {
    return [[self.calendar components:NSCalendarUnitYear fromDate:[NSDate date]] year] == [[self.calendar components:NSCalendarUnitYear fromDate:self.date] year];

}
@end
