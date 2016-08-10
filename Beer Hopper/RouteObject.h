//
//  RouteObject.h
//  Beer Hopper
//
//  Created by Justin Goulet on 1/16/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Brewery.h"

@interface RouteObject : NSObject

@property (strong, nonatomic) NSString *routeName;
@property (strong, nonatomic) NSDate *dateLastTraveled;
@property (strong, nonatomic) NSArray *breweries;

-(id)initWithName: (NSString *)newName lastTraveled:(NSDate *)newDate andBreweries:(NSArray *)breweriesInRoute;

@end
