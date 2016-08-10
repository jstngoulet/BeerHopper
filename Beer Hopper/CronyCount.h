//
//  CronyCount.h
//  Crony
//
//  Created by Justin Goulet on 9/25/15.
//  Copyright © 2015 Justin Goulet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "Error.h"


#define prototypeName @"Cronies"

@interface CronyCount : NSObject <NSURLConnectionDelegate>
{
    int numberOfCronies;
    CLLocation *currentDeviceLocation;
    NSDictionary *userInfo;
    NSDictionary *currentCrony;
    
    NSString *pawd, *username;
    
    //Repo stuff
    NSMutableData *_responseData;
    
    //for signin and for getting information
    NSURLConnection *loginConnection, *createConnection, *getCronyInfo, *cronieCountResponse;
    
    //Temp
    UILabel *temp;
    UIViewController *newController;
    UIViewController *vc; //Main view controller
}

@property (weak) NSString *placeID;

-(id)initWithLocation:(CLLocation *)currentLocation placeID:(NSString *)currentPlaceID;
-(void)submitCronyCount:(CLLocation *)currentLocation;
-(int)getCronyCount;
-(void)setCronyCount:(int)newCount;
-(int)getBusinessCronyCount:(CLLocation *)location;
-(void)loginToOurServerUsingUser:(NSString *)userEamil password:(NSString *)pwd errorLabel:(UILabel *)lbl presentViewControllerWhenComplete:(UIViewController *)view;
-(void)CreateAccountUsingUser:(NSString *)userEamil password:(NSString *)pwd errorLabel:(UILabel *)lbl;
-(void)getCronyInfo;
-(void)logout;

@end
