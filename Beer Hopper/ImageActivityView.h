//
//  ImageActivityView.h
//  Beer Hopper
//
//  Created by Justin Goulet on 5/26/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageActivityView : UIView
{
    UILabel *circles[5];
    CGRect mainFrame, maxFrame;
    BOOL shouldAnimate;
    CGPoint orig[5];
    int count;
}

@property (strong, nonatomic) UIImageView *mainImage;
@property (strong, nonatomic) UIImage *waitingImage;
@property (nonatomic) BOOL isAnimating, hidesWhenNotAnimating;
@property (nonatomic) UIColor *tintColor, *backgroundC;
@property (nonatomic) float animationDuration;


-(void)startAnimating;
-(void)stopAnimating;
-(void)useImage:(UIImage *)img;

@end
