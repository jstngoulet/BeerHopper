//
//  Error.h
//  TestProject_ErrorView
//
//  Created by Justin Goulet on 9/29/15.
//  Copyright © 2015 Justin Goulet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface Error : UIView
{
    NSString *currentError, *currentErrorDescription, *currentLongErrorDescription;
    UIView *backgroundView, *mainView;
    UILabel *errorDescriptionLabel;
    UILabel *titleLabel;
    UITapGestureRecognizer *tapped;
    UISwipeGestureRecognizer *swipeUp;
    UIButton *report, *dismiss;
    int counter;
    NSTimer *dismissTimer;
    UIScrollView *backgroundScroller;
}

-(id)initWithError:(NSString *)errorTitle errorMessage:(NSString *)shortErrorDescription description:(NSString *)longErrorDescription;
-(void)newError:(NSString *)newError shortDescription:(NSString *)description longDescription:(NSString *)newLongDescription;
-(void)setError:(NSString *)newError;
-(void)setDescription:(NSString *)newDescription;
-(void)setLongErrorDescription:(NSString *)newDescription;

-(NSString *)error;
-(NSString *)shortErrorDescription;
-(NSString *)longErrorDescription;
@end
