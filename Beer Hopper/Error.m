//
//  Error.m
//  TestProject_ErrorView
//
//  Created by Justin Goulet on 9/29/15.
//  Copyright © 2015 Justin Goulet. All rights reserved.
//

#import "Error.h"

@implementation Error
-(id)initWithError:(NSString *)errorTitle errorMessage:(NSString *)errorDescription description:(NSString *)longErrorDescription
{
    [self setError:errorTitle];
    [self setDescription:errorDescription];
    [self setLongErrorDescription:longErrorDescription];
    
    //Adds the black background to the view
    mainView = [[[[[UIApplication sharedApplication] delegate] window] rootViewController] view];
    self = [super initWithFrame:CGRectMake(0, 0, mainView.frame.size.width, mainView.frame.size.width/2)];
    
    //Intit background view
    //[self addBackgroundView];
    
    //Add error view to the top
    [self addErrorView];
    
    //Adjust framesize
    [self adjustFrameSize];
    [self.layer removeAllAnimations];
    
    //Add the gesture recognizer that will stop the timer and will expand the view.
    //When the view is expanded, we will also add the "Cancel" and "Report" buttons.
    self.layer.masksToBounds = YES;
    
    if (errorTitle.length != 0 && errorDescription.length != 0) {
        [self bringIntoView];
    }
    
    //NSDictionary *currentCrony = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentCrony"];
    
    return self;
}

-(void)newError:(NSString *)newError shortDescription:(NSString *)description longDescription:(NSString *)newLongDescription
{
    [self setError:newError];
    [self setDescription:description];
    [self setLongErrorDescription:newLongDescription];
    
    mainView = [[[[[UIApplication sharedApplication] delegate] window] rootViewController] view];
    self.frame = CGRectMake(0, 0, mainView.frame.size.width, mainView.frame.size.width/2);
    
    
    //Add error view to the top
    [self addErrorView];
    
    //Adjust framesize
    [self adjustFrameSize];
    [self.layer removeAllAnimations];
    
    if (newError.length != 0 && description.length != 0) {
        [self bringIntoView];
    }
    
    if (newError.length == 0 && description.length == 0 && newLongDescription.length == 0) {
        [self removeFromSuperview];
    }
}

-(void)bringIntoView
{
    
    if (titleLabel.text.length == 0 && errorDescriptionLabel.text.length == 0) {
        [self removeFromSuperview];
    }
    else{
        [UIView animateWithDuration:.5 animations:^{
            self.center = CGPointMake(self.center.x, self.frame.size.height/2);
        }];
    }
    
    
}

-(void)setError:(NSString *)newError
{
    currentError = newError;
}

-(void)setDescription:(NSString *)newDescription
{
    currentErrorDescription = newDescription;
}

-(void)setLongErrorDescription:(NSString*)newDescription
{
    currentLongErrorDescription = newDescription;
}

-(NSString *)error
{
    return currentError;
}

-(NSString *)shortErrorDescription
{
    return currentErrorDescription;
}

-(NSString *)longErrorDescription
{
    return currentLongErrorDescription;
}

-(void)addBackgroundView
{
    //Adds the black background to the view
    mainView = [[[[[UIApplication sharedApplication] delegate] window] rootViewController] view];
    
    backgroundView = [[UIView alloc] initWithFrame:mainView.frame];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = .5;
    backgroundView.center = CGPointMake(backgroundView.frame.size.width/2, backgroundView.frame.size.height/2);
    //[mainView addSubview:backgroundView];
}

-(void)addErrorView
{
    //This is going to be a new view at the top, added to the background view
    self.backgroundColor = [UIColor blackColor];
    
    //Add the title label, which contains the main erorr message.
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height/5)];
    titleLabel.text = currentError;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:24];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor redColor];
    [self addSubview:titleLabel];
    
    backgroundScroller = [[UIScrollView alloc] init];
    backgroundScroller.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.size.height + titleLabel.frame.origin.y, titleLabel.frame.size.width, self.frame.size.height/2);
    [backgroundScroller sizeToFit];
    [self addSubview:backgroundScroller];
    
    //Add the description label, which expands when the viewis touched.
    errorDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height, titleLabel.frame.size.width, mainView.frame.size.height/2)];
    errorDescriptionLabel.text = currentErrorDescription;
    errorDescriptionLabel.textColor = [UIColor whiteColor];
    errorDescriptionLabel.numberOfLines = 2;
    [errorDescriptionLabel sizeToFit];
    errorDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    errorDescriptionLabel.center = CGPointMake(mainView.center.x, errorDescriptionLabel.center.y);
    [backgroundScroller addSubview:errorDescriptionLabel];
    
    if (currentLongErrorDescription != NULL) {
        tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandView)];
        [self addGestureRecognizer:tapped];
    }
    
    swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipeUp];
    
    //Move the view out of sight so it can bounce in
    self.center = CGPointMake(self.center.x, -self.frame.size.height);
    
    [self startTimer];
}

-(void)adjustFrameSize
{
    
    [errorDescriptionLabel sizeToFit];
    [backgroundScroller sizeToFit];
    
    float startingY = 10, currentViewHeight = 0, innerY = 0;
    
    for (UIView *temp in self.subviews) {
        //NSLog(@"View Type: %@", [temp class]);
        if ([temp isKindOfClass:[UIScrollView class]]) {
            //Check for the label within
            for(UIView *inner in temp.subviews)
            {
                [inner sizeToFit];
                inner.frame = CGRectMake(self.frame.size.width/2 - inner.frame.size.width/2, innerY, titleLabel.frame.size.width, inner.frame.size.height);
                inner.center = CGPointMake(temp.frame.size.width/2, inner.center.y);
                innerY += inner.frame.size.height+ 10;
                currentViewHeight = inner.frame.size.height;
            }
            
            temp.frame = CGRectMake(temp.frame.origin.x, temp.frame.origin.y, temp.frame.size.width, currentViewHeight);
        }
        else{
            temp.frame = CGRectMake(self.frame.size.width/2 - temp.frame.size.width/2, startingY, titleLabel.frame.size.width, temp.frame.size.height);
            startingY += temp.frame.size.height + 10;
            currentViewHeight += temp.frame.size.height;
        }
    }
    
    //Make the back view the correct size ow that the subviews are sized
    [UIView animateWithDuration:.5 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, titleLabel.frame.size.height + errorDescriptionLabel.frame.size.height + 20);
        backgroundScroller.contentSize = CGSizeMake(titleLabel.frame.size.width, errorDescriptionLabel.frame.size.height);
        backgroundScroller.frame = CGRectMake(backgroundScroller.frame.origin.x, backgroundScroller.frame.origin.y, titleLabel.frame.size.width, errorDescriptionLabel.frame.size.height);
        
        
        //Set the frame to the label size
        if (backgroundScroller.frame.size.height > mainView.frame.size.height/3) {
            backgroundScroller.frame = CGRectMake(backgroundScroller.frame.origin.x, backgroundScroller.frame.origin.y, backgroundScroller.frame.size.width, mainView.frame.size.height/3);
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, titleLabel.frame.origin.y + titleLabel.frame.size.height + backgroundScroller.frame.size.height + 10);
        }
        
    }];
}

-(void)expandView
{
    //When tapped, change the descrtption text to the long descriptions.
    NSLog(@"View Tapped");
    errorDescriptionLabel.numberOfLines = -1;
    errorDescriptionLabel.text = currentLongErrorDescription;
    [self adjustFrameSize];
    
    //Remove the sesture listener
    [self removeGestureRecognizer:tapped];
    
    //Add the buttons
    dismiss = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, mainView.frame.size.height/15)];
    [dismiss.layer setBorderWidth:.5];
    [dismiss setTitle:@"Dismiss" forState:UIControlStateNormal];
    [dismiss addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [dismiss.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]];
    [self addSubview:dismiss];
    
    report = [[UIButton alloc] initWithFrame:dismiss.frame];
    [report.layer setBorderWidth:.5];
    [report setTitle:@"Report" forState:UIControlStateNormal];
    [report.titleLabel setFont:dismiss.titleLabel.font];
    [report setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [report addTarget:self action:@selector(reportError) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:report];
    
    dismiss.center = CGPointMake(self.frame.size.width/4 * 3, backgroundScroller.frame.size.height + backgroundScroller.frame.origin.y + dismiss.frame.size.height/1.5);
    report.center = CGPointMake(self.frame.size.width/4, dismiss.center.y);
    
    [UIView animateWithDuration:.5 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + dismiss.frame.size.height + 10);
    }];
    [self endTimer];
}

-(void)reportError{
    NSLog(@"Error Reported");
}

-(void)removeView
{
    //Dismiss view
    [UIView animateWithDuration:.5 animations:^{
        self.center = CGPointMake(self.center.x, -self.frame.size.height/2);
    }completion:^(BOOL fin){
        if(fin)
        {
            [self removeFromSuperview];
        }
    }];
}



-(void)startTimer
{
    dismissTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dismissView) userInfo:NULL repeats:YES];
}

-(void)endTimer
{
    [dismissTimer invalidate];
}

-(void)dismissView
{
    if (counter == 3) {
        [self endTimer];
        
        //Dismiss view
        [UIView animateWithDuration:.5 animations:^{
            self.center = CGPointMake(self.center.x, -self.frame.size.height/2);
        }completion:^(BOOL fin){
            if(fin)
            {
                [self removeFromSuperview];
            }
        }];
    }
    else
        counter++;
}

@end
