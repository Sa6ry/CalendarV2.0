//
//  AgendaEventTableViewCell.h
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 3/3/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarEvent.h"

@interface AgendaEventTableViewCell : UITableViewCell
-(void) updateWithEvent:(CalendarEvent*) event;
@end
