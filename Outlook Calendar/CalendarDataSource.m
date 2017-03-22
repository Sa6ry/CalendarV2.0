//
//  CalendarDataSource.m
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 3/3/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#import "CalendarDataSource.h"
#import <EventKit/EventKit.h>
#import "NSCalendar+Alignment.h"
#import "NSCalendar+Arithmetic.h"

@interface CalendarDataSource()
@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic, assign) BOOL eventsAccessGranted;
@property (nonatomic, strong) NSCalendar* calendar;

// We have a dictionary of fetched dates
@property (nonatomic,strong) NSMutableDictionary<NSDate*, NSArray<CalendarEvent*> *>* fixedCache;

@end


@implementation CalendarDataSource
@synthesize startDate = _startDate;
@synthesize endDate = _endDate;
@synthesize noOfDays = _noOfDays;

#pragma mark - Cache Helpers


-(NSArray<CalendarEvent*> * ) getEventsForDay:(NSDate*) date {
    return [self.fixedCache objectForKey:[[NSCalendar currentCalendar] alignToStartOfDay:date]];
}

-(NSUInteger) getEventsCountForDay:(NSDate*) date {
    
    return [self getEventsForDay:date].count;
}

#pragma mark -
-(instancetype) initWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate completion:(void (^)(NSError *error))completion {
    self = [super init];
    if(self) {
        self.fixedCache = [NSMutableDictionary dictionary];
        self.eventStore = [[EKEventStore alloc] init];
        self.calendar = [NSCalendar currentCalendar];
        
        [self requestAccessToEventsWithCompletion:^(NSError *error) {
            _startDate = [self.calendar alignToStartOfDay:startDate];
            _startDate = [self.calendar alignToFirstDayOfWeek:[self.calendar alignToFirstDayOfMonth:_startDate]];
            
            _endDate = [self.calendar alignToEndOfDay:endDate];
            _endDate = [self.calendar alignToFirstDayOfWeek:[self.calendar alignToLastDayOfWeek:_endDate]];
            
            _noOfDays = [self.calendar daysFromDate:self.startDate toDate:self.endDate];
            [self queryEventsWithStartDay:self.startDate endDay:self.endDate completion:^(NSMutableDictionary<NSDate *,NSArray<CalendarEvent *> *> *events) {
                self.fixedCache = events;
                completion(nil);
            }];

        }];
    }
    return self;
}

-(void) queryEventsWithStartDay:(NSDate*) startDate endDay:(NSDate*) endDate completion:(void (^ )(NSMutableDictionary<NSDate*, NSArray<CalendarEvent*> *>* events))completion  {
    
        NSDate* startDay = [[NSCalendar currentCalendar] alignToStartOfDay:startDate];
        //6 months in the future
        NSDate* endDay = [[NSCalendar currentCalendar] alignToEndOfDay:endDate];
    
        NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDay
                                                                          endDate:endDay
                                                                        calendars:nil];
        
        // Fetch all events that match the predicate
        NSArray* temp = [self.eventStore eventsMatchingPredicate:predicate];
        NSMutableDictionary* eventsDic = [NSMutableDictionary dictionary];
        [temp enumerateObjectsUsingBlock:^(EKEvent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            // Create the Event Object
            CalendarEvent* event = [[CalendarEvent alloc] initWithEKEvent:obj];
            NSDate* keyDate = [[NSCalendar currentCalendar] alignToStartOfDay:event.startDate];
            
            NSMutableArray* eventsArray = [eventsDic objectForKey:keyDate];
            if(eventsArray == nil) {
                eventsArray = [NSMutableArray array];
                [eventsDic setObject:eventsArray forKey:keyDate];
            }

            // Insert it in order
            NSUInteger newIndex = [eventsArray indexOfObject:event
                                         inSortedRange:(NSRange){0, [eventsArray count]}
                                               options:NSBinarySearchingInsertionIndex
                                       usingComparator:^NSComparisonResult(CalendarEvent  *obj1, CalendarEvent* obj2) {
                                           return [obj.startDate compare:obj2.startDate];
                                       }];
            
            [eventsArray insertObject:event atIndex:newIndex];
        }];
        if(completion) {
            completion(eventsDic);
        }
    
}

-(void)requestAccessToEventsWithCompletion:(void (^ __nullable)(NSError *error))completion{
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (error == nil) {
            // Store the returned granted value.
            self.eventsAccessGranted = granted;
        }
        else{
            // In case of error, just log its description to the debugger.
            NSLog(@"%@", [error localizedDescription]);
        }
        if(completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error);
            });
        }
    }];
}

@end
