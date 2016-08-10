//
//  ImageActivityView.m
//  Beer Hopper
//
//  Created by Justin Goulet on 5/26/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "ImageActivityView.h"

@implementation ImageActivityView

-(id)init{
    
    maxFrame = [[[[UIApplication sharedApplication] delegate] window] rootViewController].view.frame;
    CGRect aFrame = CGRectMake(0, 0, maxFrame.size.width/2.5, maxFrame.size.height/5);
    self = [super initWithFrame:aFrame];
    
    
    [self build:aFrame custom:YES];
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self build:frame custom:YES];
    return self;
}

-(void)build:(CGRect) thisFrame custom:(BOOL)value{
    count = 4;
    //NSLog(@"Building activity View");
    self.backgroundColor = [UIColor whiteColor];
    
    maxFrame = [[[[UIApplication sharedApplication] delegate] window] rootViewController].view.frame;
    self.center = CGPointMake(maxFrame.size.width/2, maxFrame.size.height/2);
    
    if (value) {
        //If it is a custom frame
        //NSLog(@"Custom Frame");
        mainFrame = thisFrame;
    }
    else{
        //If it is a standard frame
        mainFrame = CGRectMake(0, 0, maxFrame.size.width/1.75, maxFrame.size.height/3);
        //NSLog(@"Standard Frame");
    }
    
    //Add the image, if null, set it to the application image
    self.mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainFrame.size.width, mainFrame.size.height/3 * 2)];
    [self addSubview:self.mainImage];
    self.mainImage.center = CGPointMake(self.frame.size.width/2, self.mainImage.center.y);
    self.mainImage.contentMode = UIViewContentModeScaleAspectFit;
    self.mainImage.layer.masksToBounds = YES;
    self.mainImage.layer.cornerRadius = 10;
    
    //Add three labels that will change colors to show animation. They will also change size
    for (int i = 0; i < count; i++) {
        circles[i] = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height/15, self.frame.size.height/15)];
        circles[i].backgroundColor = self.tintColor;
        circles[i].layer.masksToBounds = YES;
        circles[i].layer.cornerRadius = circles[i].frame.size.height/2;
        [self addSubview:circles[i]];
        circles[i].center = CGPointMake((i+1)*(self.frame.size.width/(count+1)), self.frame.size.height - (self.frame.size.height - self.mainImage.frame.size.height)/2);
        orig[i] = circles[i].center;
    }
    
    //self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    self.animationDuration = .25;
    [self addShadowToView:self];
    shouldAnimate = YES;
    self.hidden = YES;
}

-(void)addShadowToView:(UIView *)temp{
    temp.layer.shadowOffset = CGSizeMake(2, 2);
    temp.layer.shadowColor = [UIColor grayColor].CGColor;
    temp.layer.shadowRadius = 5.0f;
    temp.layer.shadowOpacity = 1;
    temp.layer.shadowPath = [[UIBezierPath bezierPathWithRect:temp.layer.bounds] CGPath];
}

-(void)startAnimating{
    shouldAnimate = YES;
    self.isAnimating = YES;
    for (int i = 0; i < count; i++) {
        circles[i].backgroundColor = self.tintColor;
    }
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [self animate];
}


-(void)animate{
    //NSLog(@"Animating");
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController].view bringSubviewToFront:self];
    self.mainImage.image = self.waitingImage;
    self.hidden = NO;
    
    
    if(shouldAnimate){
        
        [UIView animateWithDuration:self.animationDuration animations:^{
            //One
            circles[0].center = CGPointMake(circles[0].center.x, circles[0].center.y - circles[0].frame.size.height);
        }completion:^(BOOL fin){
            if (fin) {
                [UIView animateWithDuration:self.animationDuration animations:^{
                    //Two
                    circles[0].center = CGPointMake(circles[0].center.x, circles[0].center.y + circles[0].frame.size.height);
                    circles[1].center = CGPointMake(circles[1].center.x, circles[1].center.y - circles[1].frame.size.height);
                }completion:^(BOOL fine){
                    if (fine) {
                        [UIView animateWithDuration:self.animationDuration animations:^{
                            //Three
                            circles[1].center = CGPointMake(circles[1].center.x, circles[1].center.y + circles[1].frame.size.height);
                            circles[2].center = CGPointMake(circles[2].center.x, circles[2].center.y - circles[2].frame.size.height);
                        }completion:^(BOOL fined){
                            if (fined) {
                                //Four
                                [UIView animateWithDuration:self.animationDuration animations:^{
                                    circles[2].center = CGPointMake(circles[2].center.x, circles[2].center.y + circles[2].frame.size.height);
                                    circles[3].center = CGPointMake(circles[3].center.x, circles[3].center.y - circles[3].frame.size.height);
                                }completion:^(BOOL end){
                                    if(end) {
                                        //redo
                                        [UIView animateWithDuration:self.animationDuration animations:^{
                                            circles[3].center = CGPointMake(circles[3].center.x, circles[3].center.y + circles[3].frame.size.height);
                                        }completion:^(BOOL isDone){
                                            if(isDone)[self animate];
                                        }];
                                    }
                                }];
                               
                            }
                        }];
                    }
                }];
            }
        }];
    }
}

-(void)useImage:(UIImage *)img{
    self.waitingImage = img;
    self.mainImage.image = self.waitingImage;
}

-(void)stopAnimating{
    self.isAnimating = NO;
    shouldAnimate = NO;
    self.hidden = YES;
    if([[UIApplication sharedApplication] isIgnoringInteractionEvents])[[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

@end
