//
//  CalendarCollectionViewCell.m
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 2/26/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#import "CalendarCollectionViewCell.h"
#import "CalendarCollectionViewLayoutAttributes.h"
#import "NSCalendar+Arithmetic.h"

@interface CalendarCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (nonatomic,retain) CalendarCollectionViewLayoutAttributes *recentLayoutAttributes;
@property (weak, nonatomic) IBOutlet UIView *eventsIndicator;
@end

@implementation CalendarCollectionViewCell

#pragma mark - Life Cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.userInteractionEnabled = NO;
}

-(void) applyLayoutAttributes:(CalendarCollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    self.recentLayoutAttributes = layoutAttributes;
    [self layoutIfNeeded]; // needs to be called to insure that the selectedView.bounds has been updated
    [self updateView];
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    return layoutAttributes;
}

-(void) prepareForReuse {
}

#pragma mark Initilization

-(NSDate*) date {
    return self.recentLayoutAttributes.date;
}

-(void) setNoOfEvents:(NSInteger) events {
    if(events == 0) {
        self.eventsIndicator.alpha = 0.0;
    } else {
        self.eventsIndicator.layer.cornerRadius = self.eventsIndicator.bounds.size.width / 2.0;
        self.eventsIndicator.alpha = MIN(1.0,(events+1.0)/5.0f);
    }
}

-(void) updateView {
    self.dayLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)self.recentLayoutAttributes.day];
    self.yearLabel.text = @"";
    self.monthLabel.text = @"";
    
    if(self.recentLayoutAttributes.day == 1 ) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM"];
        self.monthLabel.text = [dateFormatter stringFromDate:self.recentLayoutAttributes.date];
        if(self.recentLayoutAttributes.isInCurrentYear == false) {
            [dateFormatter setDateFormat:@"YYY"];
            self.yearLabel.text = [dateFormatter stringFromDate:self.recentLayoutAttributes.date];
        }
    }
    
    // force updating the selection view & colors
    [self setSelected:self.selected];
}

-(void) updateColors {
    if(self.recentLayoutAttributes.isToday && self.selected == false) {
        self.backgroundColor = [UIColor colorWithRed:246.0/255.0
                                               green:251.0/255.0
                                                blue:253.0/255.0
                                               alpha:1.0];
        self.dayLabel.textColor = self.selectedView.backgroundColor;
    }else {
        switch (self.recentLayoutAttributes.backgroundStyle) {
            case CalendarCellBackgroundDark:
                self.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
                break;
            case CalendarCellBackgroundLight:
                self.backgroundColor = [UIColor whiteColor];
                break;
        }
        if(self.isSelected) {
            self.dayLabel.textColor = [UIColor whiteColor];
        }else {
            self.dayLabel.textColor = [UIColor colorWithRed:142.0/255.0
                                                      green:142.0/255.0
                                                       blue:142.0/255.0
                                                      alpha:1.0];
        }
    }
}

-(void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.selectedView.hidden = !selected;
    self.monthLabel.hidden = selected || self.monthLabel.text.length == 0;
    self.yearLabel.hidden = selected || self.yearLabel.text.length == 0;
    self.eventsIndicator.hidden = selected || self.monthLabel.text.length != 0 || self.yearLabel.text.length != 0;
    if(self.selectedView.hidden == false) {
        // the cell is selected
        self.selectedView.layer.cornerRadius = self.selectedView.bounds.size.width / 2.0;
    }
    [self updateColors];
}

@end
