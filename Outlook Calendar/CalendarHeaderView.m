//
//  CalendarHeaderView.m
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 3/7/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#import "CalendarHeaderView.h"

@interface CalendarHeaderView()
@property (weak, nonatomic) IBOutlet UIStackView *headerLabels;
@end

@implementation CalendarHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadContent];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self loadContent];
    }
    return self;
}

// Load content from the xib file
-(void) loadContent {
    UIView *xibView = [[NSBundle bundleForClass:self.class] loadNibNamed:NSStringFromClass(self.class)
                                                                   owner:self
                                                                 options:nil].firstObject;
    xibView.frame = self.bounds;
    xibView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview: xibView];
    
    [self updateHeader];
    
}

-(void) updateHeader {
    NSDate *today = [NSDate date];
    NSDate *beginningOfWeek = nil;
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&beginningOfWeek interval:NULL forDate: today];
    NSDateFormatter* dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"EEE"];
    
    for(UILabel* label in self.headerLabels.subviews) {
        label.text = [[dateFormat stringFromDate:beginningOfWeek] substringToIndex:1];
        beginningOfWeek = [beginningOfWeek dateByAddingTimeInterval:60*60*24];
    }
}

@end
