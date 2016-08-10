//
//  Beer.h
//  Beer Hopper
//
//  Created by Justin Goulet on 1/14/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Beer : NSObject
{
    
}
@property (nonatomic) enum beerType {Porter, Stout, Ale, IPA, DoubleIPA, Sour, BlondeAle, Holiday, Lager};
@property (nonatomic) float ABV, IBU;
@property (nonatomic) enum servingStyle;    //For Nitro/CO2
@property (nonatomic) double glassServed;
@property (nonatomic) NSArray *hopsUsed, *reviews;
@property (nonatomic) NSString *beerDescription;
@property (nonatomic) int votes;            //Users can choose to upvote a beer, just as a quick rating
@property (nonatomic) double rating;        //Users can rate votes
@property (nonatomic) NSString *beerName, *iden, *imageURL, *fromTheBrewer, *beerType, *breweryName, *servingGlass, *style, *pairings, *awards;
@property (nonatomic) UIImage *image;
@property (nonatomic) BOOL isAvail;

-(id)initWithName:(NSString *)nameOfBeer type:(NSString *)newBeerType description:(NSString *)beerShortDescription;
-(NSComparisonResult)compareByName:(Beer *)other;

@end
