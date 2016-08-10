//
//  ImageButton.m
//  Brewery Hopper
//
//  Created by Justin Goulet on 5/31/16.
//  Copyright © 2016 Justin Goulet. All rights reserved.
//

#import "ImageButton.h"

@implementation ImageButton

-(id)init{
    self = [super init];
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self build];
    //self.backgroundColor = [UIColor grayColor];
    return self;
}

-(void)build{
    
    self.bckView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.height/3 * 2, self.frame.size.height/3 * 2)];
    [self addShadowToView:self.bckView];
    [self addSubview:self.bckView];
    self.bckView.backgroundColor = [UIColor whiteColor];
    
    float difference = self.bckView.frame.size.height/7.75;
    
    //First, we are going to build the primary image view. This view is going to have a shadow
    self.mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(difference, difference, self.bckView.frame.size.width - (difference*2), self.bckView.frame.size.height - (difference*2))];
    self.mainImageView.backgroundColor = [UIColor whiteColor];
    [self.bckView addSubview:self.mainImageView];
    [self.mainImageView setContentMode:UIViewContentModeScaleAspectFit];
    self.mainImageView.center = CGPointMake(self.bckView.frame.size.width/2, self.bckView.frame.size.height/2);
    self.mainImageView.image = [UIImage imageNamed:@"gift.png"];
    //[self addShadowToView:self.mainImageView];
    
    self.bckView.center = CGPointMake(self.frame.size.width/2, self.mainImageView.center.y);
    
    //Next, we are going to add the title label directly under the view
    self.primaryTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, self.bckView.frame.origin.y + self.bckView.frame.size.height, self.frame.size.width - 20, self.frame.size.height/3)];
    self.primaryTitle.text = @"Test Text";
    self.primaryTitle.textAlignment = NSTextAlignmentCenter;
    self.primaryTitle.center = CGPointMake(self.bckView.center.x, self.primaryTitle.center.y);
    self.primaryTitle.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.primaryTitle];
    
    self.primaryButton = [[UIButton alloc] initWithFrame:self.bckView.frame];
    self.primaryButton.showsTouchWhenHighlighted = YES;
    [self addSubview:self.primaryButton];
    
    [self sendSubviewToBack:self.mainImageView];
    [self sendSubviewToBack:self.bckView];
    
    //self.showsTouchWhenHighlighted = YES;
}

-(void)addShadowToView:(UIView *)temp{
    temp.layer.shadowOffset = CGSizeMake(2, 2);
    temp.layer.shadowColor = [UIColor grayColor].CGColor;
    temp.layer.shadowRadius = 10.0f;
    temp.layer.shadowOpacity = 1;
    temp.layer.shadowPath = [[UIBezierPath bezierPathWithRect:temp.layer.bounds] CGPath];
}

-(void)setOperable:(BOOL)value{
    self.enabled = value;
    if(value){
        //If the button is enabled, set to standard
        self.backgroundColor = [UIColor clearColor];
    }
    else{
        //Set as a custom disabled
        //self.bckView.backgroundColor = [UIColor redColor];
        [self.primaryButton setEnabled:NO];
        self.mainImageView.image = self.disabledImage;
        self.mainImageView.backgroundColor = [UIColor whiteColor];
        
        self.bckView.backgroundColor = self.mainImageView.backgroundColor;
    }
}

@end
