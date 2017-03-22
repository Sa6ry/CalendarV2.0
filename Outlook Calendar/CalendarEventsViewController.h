//
//  CalendarEventsViewController.h
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 2/26/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#import "CalendarView.h"
#import "AgendaView.h"
#import "CalendarDataSource.h"

@interface CalendarEventsViewController : UIViewController < CalenderCollectionViewDelegate, CalenderCollectionViewDataSource, AgendaViewDelegate , AgendaViewDataSource>

@end
