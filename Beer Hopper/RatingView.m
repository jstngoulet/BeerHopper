//
//  RatingView.m
//  Beer Hopper
//
//  Created by Justin Goulet on 6/7/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "RatingView.h"

@implementation RatingView

-(id)initWithFrame:(CGRect)frame Post:(ForumObject *)post{
    self = [super initWithFrame:frame];
    self.thisPost = post;
    //self.backgroundColor = [UIColor blueColor];
    [self build];
    return self;
}

-(void)build{
    
    //Add main view (this one will have a shadow)
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, self.frame.size.width - 60, self.frame.size.height - 20)];
    [self addSubview:self.mainView];
    
    //Add date label to the top left
    self.dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.mainView.frame.size.width - 10, self.mainView.frame.size.height/8 - 5)];
    self.dataLabel.text = self.thisPost.dateString;
    [self.mainView addSubview:self.dataLabel];
    self.dataLabel.textColor = [UIColor grayColor];
    self.dataLabel.font = [UIFont boldSystemFontOfSize:16];
    
    //Add the rating label
    self.ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.dataLabel.frame.origin.y*2 + self.dataLabel.frame.size.height, self.dataLabel.frame.size.width, self.dataLabel.frame.size.height/3)];
    self.ratingLabel.backgroundColor = [UIColor redColor];
    self.ratingLabel.layer.masksToBounds = YES;
    self.ratingLabel.layer.cornerRadius = self.ratingLabel.frame.size.height/2;
    [self.mainView addSubview:self.ratingLabel];
    
    float currentY = self.ratingLabel.frame.origin.y + self.ratingLabel.frame.size.height*2;
    
    NSLog(@"Locating User");
    //Add the user label, if it exists
    @try{
    if(self.thisPost.user){
        //NSLog(@"Craete Frame");
        self.aliasLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, currentY, self.dataLabel.frame.size.width, self.mainView.frame.size.height - currentY)];
        //self.aliasLabel.backgroundColor = [UIColor blueColor];
        
        //NSLog(@"Set Text");
        self.aliasLabel.text = [NSString stringWithFormat:@"By: %@", self.thisPost.user];
        self.aliasLabel.font = [UIFont systemFontOfSize:12];
        self.aliasLabel.textColor = [UIColor grayColor];
        [self.mainView addSubview:self.aliasLabel];
        
        //Set the new frame size to fit the text
        [self.aliasLabel sizeToFit];
        
        //Adjust the new center
        self.aliasLabel.center = CGPointMake(self.aliasLabel.frame.size.width/2 + 5, currentY + self.aliasLabel.frame.size.height/2);
        
        //NSLog(@"Update the current Y");
        currentY += self.aliasLabel.frame.size.height;
    }
    }@catch(NSException *e){
        NSLog(@"Exception Found: %@", e.description);
    }
    
    //Add the main message label
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, currentY, self.dataLabel.frame.size.width, self.mainView.frame.size.height - currentY)];
    self.messageLabel.text = self.thisPost.messageBody;
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.font = [UIFont systemFontOfSize:14];
    [self.messageLabel sizeToFit];
    self.messageLabel.frame = CGRectMake(0, 0, self.dataLabel.frame.size.width, self.messageLabel.frame.size.height);
    self.messageLabel.center = CGPointMake(self.mainView.frame.size.width/2, self.ratingLabel.center.y + self.ratingLabel.frame.size.height + self.messageLabel.frame.size.height/2 + 10);
    //self.messageLabel.backgroundColor = [UIColor blueColor];
    [self.mainView addSubview:self.messageLabel];
    
    //If the user label exists, adjust the center again
    if(self.thisPost.user){
        self.messageLabel.center = CGPointMake(self.mainView.frame.size.width/2, self.aliasLabel.center.y + self.aliasLabel.frame.size.height + self.messageLabel.frame.size.height/2);
    }
    
    self.mainView.frame = CGRectMake(20, 10, self.frame.size.width - 60, self.messageLabel.frame.origin.y + self.messageLabel.frame.size.height + 10);
    self.mainView.backgroundColor = [UIColor whiteColor];
    
    //Add a fancy shadow to the main view
    self.mainView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.mainView.layer.shadowOffset = CGSizeMake(1, 2);
    self.mainView.layer.shadowOpacity = 1;
    self.mainView.layer.shadowRadius = 3;
    
    //Change the background color of the rating view
    if (self.thisPost.rating > 0 && self.thisPost.rating < 5) _ratingLabel.backgroundColor = [UIColor colorWithRed:0.827 green:0.125 blue:0.114 alpha:1.00];
    if(self.thisPost.rating >= 5 && self.thisPost.rating < 7.5)_ratingLabel.backgroundColor = [UIColor colorWithRed:1.000 green:0.886 blue:0.353 alpha:1.00];
    if(self.thisPost.rating >= 7.5 && self.thisPost.rating < 10) _ratingLabel.backgroundColor = [UIColor colorWithRed:0.482 green:0.765 blue:0.306 alpha:1.00];
    if(self.thisPost.rating == 10 || self.thisPost.rating == 0) _ratingLabel.backgroundColor = [UIColor colorWithRed:0.380 green:0.490 blue:0.541 alpha:1.00];
    
    //Now, if the beer rating exists
    if (self.thisPost.rating > 0) {
        [UIView animateWithDuration:5 animations:^{
            _ratingLabel.frame = CGRectMake(_ratingLabel.frame.origin.x, _ratingLabel.frame.origin.y, (_ratingLabel.frame.size.width/10) * self.thisPost.rating, _ratingLabel.frame.size.height);}];
    }
    else {
        _ratingLabel.backgroundColor = [UIColor colorWithRed:0.380 green:0.490 blue:0.541 alpha:1.00];
    }
}

- (CGPathRef)fancyShadowForRect:(CGRect)rect
{
    CGSize size = rect.size;
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    //right
    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(size.width, 0.0f)];
    [path addLineToPoint:CGPointMake(size.width, size.height + 15.0f)];
    
    //curved bottom
    [path addCurveToPoint:CGPointMake(0.0, size.height + 15.0f)
            controlPoint1:CGPointMake(size.width - 15.0f, size.height)
            controlPoint2:CGPointMake(15.0f, size.height)];
    
    [path closePath];
    
    return path.CGPath;
}



@end
