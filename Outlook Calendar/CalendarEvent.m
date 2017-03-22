//
//  CalendarEvent.m
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 3/3/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#import "CalendarEvent.h"


@implementation CalendarEvent

-(instancetype) initWithEKEvent:(EKEvent*) event {
    self = [super init];
    if(self) {
        self.title = event.title;
        self.startDate  = event.startDate;
        self.endDate = event.endDate;
        self.location = event.location;
    }
    return self;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"title = %@, startDate = %@, endDate = %@",self.title,self.startDate.description,self.endDate.description];
}
@end
