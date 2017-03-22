//
//  AgendaSectionHeaderView.m
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 3/22/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#import "AgendaSectionHeaderView.h"
@interface AgendaSectionHeaderView()
@property (nonatomic,strong) UILabel* label;
@end
@implementation AgendaSectionHeaderView

-(instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        // Sepertor
        UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-1.0f, self.bounds.size.width, 1.0f)];
        seperator.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
        seperator.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        
        // Label
        self.label = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 14, 0)];
        self.label.font = [UIFont systemFontOfSize:[UIFont systemFontSize]-1];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        
        
        [self addSubview:seperator];
        [self addSubview:self.label];
    }
    return self;
}

-(void) setDate:(NSDate*) date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE, MMMM dd"];
    self.label.text = [dateFormat stringFromDate:date].uppercaseString;
    
    if([[NSCalendar currentCalendar] isDateInToday:date] ) {
        
        self.backgroundColor = [UIColor colorWithRed:246.0/255.0
                                               green:251.0/255.0
                                                blue:253.0/255.0
                                               alpha:1.0];
        self.label.textColor = [UIColor colorWithRed:0.0/255.0
                                               green:120.0/255.0
                                                blue:215.0/255.0
                                               alpha:1.0];
        
        //today styleing
        self.label.text = [@"TODAY • " stringByAppendingString:self.label.text];

    }else {

        self.backgroundColor = [UIColor colorWithRed:245.0/255.0
                                               green:245.0/255.0
                                                blue:245.0/255.0
                                               alpha:1.0];
        self.label.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
    
        
        if([[NSCalendar currentCalendar] isDateInTomorrow:date] ) {
            //tommorw styling
            self.label.text = [@"TOMORROW • " stringByAppendingString:self.label.text];
        }else if([[NSCalendar currentCalendar] isDateInYesterday:date]) {
            //yesterday styling
            self.label.text = [@"YESTERDAY • " stringByAppendingString:self.label.text];
        }
    }
}

@end
