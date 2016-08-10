//
//  MyAnalytics.h
//  Beer Hopper
//
//  Created by Justin Goulet on 7/5/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <Foundation/Foundation.h>

//Import all needed files
#import "Beer.h"
#import "Brewery.h"
#import "Event.h"
#import "Routes.h"
#import "ForumObject.h"
#import <Google/Analytics.h>

@interface MyAnalytics : NSObject <NSURLConnectionDelegate>{
    NSArray *masterArray;
    NSURLConnection *tempConnection;
}

//NSURL Stuff
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSString *thisAction, *thisCategory, *thisDescription, *thisBreweryIden, *thisBeerIden, *thisEventIden, *userID;

-(void)viewShown:(NSString *)viewName;
-(void)eventAction:(NSString *)action category:(NSString *)category description:(NSString *)label breweryIden:(NSString *)breweryIden beerIden:(NSString *)beerIden eventIden:(NSString *)eventIden;

@end
