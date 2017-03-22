//
//  CalenderView.h
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 2/24/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarCollectionViewInterface.h"

IB_DESIGNABLE
@interface CalendarView : UIView < CalenderCollectionViewInterface, UICollectionViewDelegate, UICollectionViewDataSource, CalenderCollectionViewDataSource>
@property (nonatomic,readonly) NSDate*  selectedDay;
@property (nonatomic,readonly) CGFloat rowHeight;
@property (nonatomic, weak) id <CalenderCollectionViewDelegate> delegate;
@property (nonatomic, weak) id <CalenderCollectionViewDataSource> dataSource;

-(void) setSelectedDay:(NSDate * )selectedDay smallChange:(BOOL) smallChange;
-(void) reloadDataAndSelectDate:(NSDate*) date;
-(BOOL) updateSelectedItem;
@end
