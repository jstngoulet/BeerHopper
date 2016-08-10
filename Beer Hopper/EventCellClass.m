//
//  EventCellClass.m
//  Beer Hopper
//
//  Created by Justin Goulet on 1/16/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "EventCellClass.h"

@implementation EventCellClass

- (void)awakeFromNib {
    // Initialization code
    
    self.coverPic.layer.masksToBounds = YES;
    [self.coverPic setContentMode:UIViewContentModeScaleAspectFill];
    
    [self addShadowToView:self.titleView];
    
    self.profilePic.image = self.thisBrewery.profilePicture;
    self.coverPic.image = self.thisBrewery.coverPhoto;
    
    [self makeCircle:self.timeImage];
    [self makeCircle:self.dateImage];
    [self makeCircle:self.ageLabel];
    [self makeCircle:self.costLabel];
    
    self.userInteractionEnabled = YES;
    
}

-(void)makeCircle:(UIView *)temp{
    temp.layer.masksToBounds = YES;
    temp.layer.cornerRadius = temp.frame.size.height/2;
}

-(void)addShadowToView:(UIView *)temp{
    temp.layer.shadowOffset = CGSizeMake(1, 1);
    temp.layer.shadowColor = [UIColor grayColor].CGColor;
    temp.layer.shadowRadius = 4.0f;
    temp.layer.shadowOpacity = 1;
    temp.layer.shadowPath = [[UIBezierPath bezierPathWithRect:temp.layer.bounds] CGPath];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        //self.coverPic.hidden = YES;
    }
}

@end
