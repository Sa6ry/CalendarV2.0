//
//  CalendarEvent.h
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 3/3/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface CalendarEvent : NSObject

-(instancetype) initWithEKEvent:(EKEvent*) event;

@property (nonatomic,strong) NSString* title;
@property (nonatomic,strong) NSString* location;
@property (nonatomic,strong) NSDate* startDate;
@property (nonatomic,strong) NSDate* endDate;

@end
