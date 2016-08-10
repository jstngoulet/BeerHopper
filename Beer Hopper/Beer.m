//
//  Beer.m
//  Beer Hopper
//
//  Created by Justin Goulet on 1/14/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "Beer.h"

@implementation Beer

-(id)initWithName:(NSString *)nameOfBeer type:(NSString *)newBeerType description:(NSString *)beerShortDescription
{
    if (self) {
        _beerName = nameOfBeer;
        //enum beerType currentBeer = newBeerType;
        _beerDescription = beerShortDescription;
        //NSLog(@"Beer Type: %u", currentBeer);
    }
    
    return self;
}

-(NSComparisonResult)compareByName:(Beer *)other{
    return [self.beerName compare:other.beerName];
}
@end
