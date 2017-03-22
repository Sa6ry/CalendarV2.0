//
//  AgendaViewInterface.h
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 3/9/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#ifndef AgendaViewInterface_h
#define AgendaViewInterface_h

@class AgendaView;
@class CalendarEvent;

// Events comming out from the control
@protocol AgendaViewDelegate <NSObject>
@optional
- (void)agendaView:(AgendaView *)agendaView didSelectDate:(NSDate * )date;
- (void)agendaViewDidScroll:(AgendaView *)agendaView;
- (void)agendaViewDidStopAnimation:(AgendaView *)agendaView;
@end

// Feed the control with data through these methods
@protocol AgendaViewDataSource <NSObject>
- (NSArray<CalendarEvent*>*) agendaView:(AgendaView *)calenderView eventsInDay:(NSDate * )date;
- (NSDate*) agendaViewStartDate:(AgendaView *)calenderView;
- (NSDate*) agendaViewEndDate:(AgendaView *)calenderView;
@end

// Drive the control through these methods
@protocol AgendaViewInterface <NSObject>
@property (nonatomic, weak) id <AgendaViewDelegate> agendaDelegate;
@property (nonatomic, weak) id <AgendaViewDataSource> agendaDataSource;
@end

#endif /* AgendaViewInterface_h */
