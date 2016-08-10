//
//  RouteObject.m
//  Beer Hopper
//
//  Created by Justin Goulet on 1/16/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "RouteObject.h"

@implementation RouteObject

-(id)initWithName: (NSString *)newName lastTraveled:(NSDate *)newDate andBreweries:(NSArray *)breweriesInRoute{
    
    @try {
        self.routeName = newName;
        self.dateLastTraveled = newDate;
        self.breweries = breweriesInRoute;
    }
    @catch (NSException *exception) {
        NSLog(@"Error upon Loading Route: %@", exception);
    }
    
    return self;
}

@end
