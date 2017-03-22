//
//  CalenderCollectionViewDynamicLayout.h
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 2/25/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    CalenderCollectionMonth = 0,
    CalenderCollectionWeek,
} CalenderCollectionStyle;

@interface CalenderCollectionViewDynamicLayout : UICollectionViewLayout

@property (nonatomic,strong) NSCalendar *calendar;
@property (nonatomic,assign) NSUInteger rowHeight;
@property (nonatomic,assign) UIEdgeInsets rowPadding;

@property (nonatomic,assign) CGFloat topPadding;
@property (nonatomic,assign) CGFloat bottomPadding;

-(NSDate*) dateForItemAtIndexPath:(NSIndexPath*) indexPath;
-(NSIndexPath*) indexPathForDate:(NSDate*) date;


@end
