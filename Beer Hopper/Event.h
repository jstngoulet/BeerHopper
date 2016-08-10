//
//  Event.h
//  Beer Hopper
//
//  Created by Justin Goulet on 1/16/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Brewery.h"

@interface Event : NSObject

@property (nonatomic) NSString *eventName, *eventdDescription, *iden, *eventDateString, *notes;
@property (nonatomic) NSDate *eventDate;
@property (nonatomic) int minAge, maxAge;
@property (nonatomic) NSString *cost;
@property (nonatomic) UIImage *coverPic, *profilePic;
@property (nonatomic) Brewery *thisBrewery;

-(id)initWithName:(NSString *)newName;
-(NSComparisonResult)sortByEventDate:(Event *)other;
@end
