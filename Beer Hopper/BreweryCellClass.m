//
//  BreweryCellClass.m
//  Beer Hopper
//
//  Created by Justin Goulet on 1/14/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "BreweryCellClass.h"

@implementation BreweryCellClass

@synthesize backgroundView;

- (void)awakeFromNib {
    // Initialization code
    [self.profilePic setContentMode:UIViewContentModeScaleAspectFit];
    //self.onTapBackground.layer.masksToBounds = YES;
    //self.onTapBackground.layer.cornerRadius = self.onTapBackground.frame.size.height/2;
    
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    
    [self addShadowToView:self.backgroundView];
    
    self.beersOnCO2.layer.masksToBounds = YES;
    self.beersOnCO2.layer.cornerRadius = self.beersOnCO2.frame.size.height/2;
    self.beersOnNitro.layer.masksToBounds = YES;
    self.beersOnNitro.layer.cornerRadius = self.beersOnCO2.frame.size.height/2;
    self.eventsCount.layer.masksToBounds = YES;
    self.eventsCount.layer.cornerRadius = self.beersOnCO2.frame.size.height/2;
    
    [self addShadowToView:self.beersOnCO2];
    [self addShadowToView:self.beersOnNitro];
    [self addShadowToView:self.eventsCount];
    
    
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
    //NSLog(@"Width of view: %f", self.frame.size.width);
}

@end
