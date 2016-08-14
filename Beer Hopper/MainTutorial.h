//
//  MainTutorial.h
//  Beer Hopper
//
//  Created by Justin Goulet on 6/22/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleTutorialPage.h"
#import "Constants.h"
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "MyAnalytics.h"

@interface MainTutorial : UIView <CLLocationManagerDelegate>
{
    SingleTutorialPage *current;
    int pageNumber;
    CLLocationManager *locationManager;
    UITextField *currentTextField;
    NSString *userEmail, *userAlias;
    MyAnalytics *analytics;
}
@property (nonatomic, nonnull) UIImage *headerImage;
@property (nonatomic, nonnull) UIColor *mainColor;
@property (nonatomic, nonnull) UIScrollView *mainScroller;

-(void)build;

@end
