//
//  CalendarCollectionViewCell.h
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 2/26/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CalendarCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) IBInspectable UIColor *lightBackgroundColor;
@property (nonatomic,readonly) NSDate* date;

-(void) setSelected:(BOOL)selected;
-(void) setNoOfEvents:(NSInteger) events;
@end
