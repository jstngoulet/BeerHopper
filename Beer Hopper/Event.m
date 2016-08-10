//
//  Event.m
//  Beer Hopper
//
//  Created by Justin Goulet on 1/16/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "Event.h"

@implementation Event

-(id)initWithName:(NSString *)newName{
    self.eventName = newName;
    return self;
}

-(NSComparisonResult)sortByEventDate:(Event *)other{
    return [self.eventDate compare:other.eventDate];
}

@end
