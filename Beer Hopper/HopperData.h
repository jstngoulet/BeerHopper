//
//  HopperData.h
//  Beer Hopper
//
//  Created by Justin Goulet on 1/21/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Brewery.h"
#import "Beer.h"
#import "Event.h"
#import "ForumObject.h"
#import "Alert.h"
#define METERS_PER_MILE 1609.344

@interface HopperData : NSObject <NSURLConnectionDelegate, CLLocationManagerDelegate>
{
    NSArray *tempArry;
    NSURLConnection *postBeerReview, *postBreweryReview, *postEventInviteResult, *postTopic, *postComment, *postUser;
    Beer *thisBeer;
    Brewery *thisBrewery;
    ForumObject *thisForumPost;
    Event *thisEvent;
    BOOL aLoaded;
    NSURLConnection *getBeer;
}
-(void)getFromTable:(NSString *)tableName;
-(void)getFromQuery:(NSString *)query;
-(void)getEvents;
-(void)submitReviewForBeer:(Beer *)aBeer rating:(float)ratingValue ratingMessage:(NSString *)message;
-(void)submitEventInvite:(Event *)anEvent rsvp:(NSString *)response;
-(void)createBeersWithDictionary:(NSDictionary *)beersDict;
-(void)submitReviewForBrewery:(Brewery *)aBrewery rating:(float)ratingValue ratingMessage:(NSString *)message;
-(void)submitNewTopic:(ForumObject *)message event:(Event *)anEvent;
-(void)submitNewComment:(NSString *)message Topic:(ForumObject *)topic;
-(void)submitNewUserWithEmail:(NSString *)email alias:(NSString *) alias;

@property (strong, nonatomic) NSMutableArray *breweries, *beers, *events, *forumPosts ,*beerIdens;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL isNulled;
-(void)nullMyLocation;

//NSURL Stuff
@property (nonatomic, strong) NSMutableData *responseData;

@end
