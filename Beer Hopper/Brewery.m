//
//  Brewery.m
//  Beer Hopper
//
//  Created by Justin Goulet on 1/14/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "Brewery.h"

@implementation Brewery

-(id)init{
    self.events = [[NSMutableArray alloc] init];
    self.beerList = [[NSMutableArray alloc] init];
    
    //Start without an image, then gain one
    self.coverPhoto = [UIImage imageNamed:@"SearchingForBrewery.png"];
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"Brewery Name: %@\n\tBeer List: %@\n\t", self.name, self.beerList];
}

- (NSComparisonResult) compareWithAnotherBrewery:(Brewery *) anotherBusiness
{
    @try{
        // if GPA is a float int double ...
        if ([anotherBusiness distance] == self.distance)
            return NSOrderedSame;
        else if ([anotherBusiness distance] < self.distance)
        {
            return NSOrderedAscending;
        }
        else if ([anotherBusiness distance] > self.distance)
            return NSOrderedDescending;
    }
    @catch(NSException *e){
        NSLog(@"Exception: %@", e);
    }
}
-(BOOL)isEqual:(Brewery *)object{
    
    if ([self.iden isEqualToString:object.iden])
        return YES;
    else return NO;
}

-(NSComparisonResult) compareNames:(Brewery *)another{
    @try {
        return [self.name compare:another.name];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception While sorting: %@", exception.description);
    }
}

/**
 
 
 @{@"Address1":type[@"fields"][@"Street Address"],
 @"City" : type[@"fields"][@"City"],
 @"State": type[@"fields"][@"State"],
 @"Zip" : type[@"fields"][@"Zip Code"]}];
 */

@end
