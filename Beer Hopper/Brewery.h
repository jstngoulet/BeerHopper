//
//  Brewery.h
//  Beer Hopper
//
//  Created by Justin Goulet on 1/14/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Brewery : NSObject

@property (nonatomic) NSString *name, *formattedPhoneNumber, *phoneNumber, *iden, *picURL, *coverPicURL, *address1, *city, *state, *zip, *breweryDescription, *hours, *ammenities, *notes;
@property (nonatomic) NSURL *website;
@property (nonatomic) CLLocation *location;
@property (nonatomic) float distance, rating;
@property (strong, nonatomic) UIImage *profilePicture, *coverPhoto;
@property (strong, nonatomic) NSMutableArray *beerList, *events, *discounts;
@property (nonatomic) NSDictionary *businessHours, *tastingHours;
@property (nonatomic) BOOL hasFoodNearby, servesFood, hasIndoorOutdoorArea;
@property (nonatomic) int beersOnNitro, beersOnCO2, eventsCount, beerCount, numberOfTimesBeforeReview;

- (NSComparisonResult) compareWithAnotherBrewery:(Brewery *) anotherBusiness;
-(NSComparisonResult) compareNames:(Brewery *)another;
@end
