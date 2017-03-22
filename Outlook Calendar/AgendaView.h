//
//  AgendaView.h
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 3/3/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarEvent.h"
#import "AgendaViewInterface.h"


@interface AgendaView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,readonly) NSDate* topDate;
-(void) scrollToDate:(NSDate*) date;

@property (nonatomic, weak) id <AgendaViewDelegate> delegate;
@property (nonatomic, weak) id <AgendaViewDataSource> datasource;

-(void) reloadDataAndSelectDate:(NSDate*) date;

@end
