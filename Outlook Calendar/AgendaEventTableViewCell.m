//
//  AgendaEventTableViewCell.m
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 3/3/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#import "AgendaEventTableViewCell.h"


@interface AgendaEventTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@end

@implementation AgendaEventTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) updateWithEvent:(CalendarEvent*) event {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm a"];
    
    self.titleLabel.text = event.title;
    self.startTimeLabel.text = [dateFormatter stringFromDate:event.startDate];
    self.endTimeLabel.text = [dateFormatter stringFromDate:event.endDate];
    if(event.location.length) {
        self.locationLabel.superview.hidden = NO;
        self.locationLabel.text = [event.location description];
    }else {
        self.locationLabel.superview.hidden = YES;
    }
}

@end
