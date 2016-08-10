//
//  ForumsCellClass.m
//  Beer Hopper
//
//  Created by Justin Goulet on 1/17/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "ForumsCellClass.h"

@implementation ForumsCellClass

- (void)awakeFromNib {
    // Initialization code
    
    //[self makeViewRound:self.likeBubble];
    //[self addBorderToView:self.likeBubble width:3 color:[UIColor whiteColor]];
    
    //[self makeViewRound:self.commentBubble];
    //[self addBorderToView:self.commentBubble width:3 color:[UIColor whiteColor]];
    
    //[self makeViewRound:self.colorView];
    [self makeCircle:self.likeBubble];
    [self makeCircle:self.commentBubble];
    [self makeCircle:self.dislikeBubble];
    //[self addShadowToView:self.colorView];
    
}

-(void)addBorderToView:(UIView *)view width:(float)width color:(UIColor *)col{
    view.layer.borderWidth = width;
    view.layer.borderColor = col.CGColor;
}

-(void)addShadowToView:(UIView *)temp{
    temp.layer.shadowOffset = CGSizeMake(1, 1);
    temp.layer.shadowColor = [UIColor grayColor].CGColor;
    temp.layer.shadowRadius = 2.0f;
    temp.layer.shadowOpacity = 1;
    temp.layer.shadowPath = [[UIBezierPath bezierPathWithRect:temp.layer.bounds] CGPath];
}

-(void)makeCircle:(UIView *)temp{
    temp.layer.masksToBounds = YES;
    temp.layer.cornerRadius = temp.frame.size.height/2;
}

-(void)makeViewRound:(UIView *)view{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = view.frame.size.height/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
