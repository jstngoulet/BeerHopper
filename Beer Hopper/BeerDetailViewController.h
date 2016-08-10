//
//  BeerDetailViewController.h
//  Beer Hopper
//
//  Created by Justin Goulet on 6/5/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Beer.h"
#import "Brewery.h"
#import "CustomTableView.h"
#import "RatingsMasterView.h"
#import "HopperData.h"
#import "ImageActivityView.h"

@interface BeerDetailViewController : UIViewController{
    ImageActivityView *activity;
    HopperData *myData;
    float yourRating;
}

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) Brewery *thisBrewery;
@property (strong, nonatomic) Beer *thisBeer;
@property (nonatomic) BOOL ratingsEnabled;
@property (strong, nonatomic) UIImageView *breweryCoverPhoto, *breweryProfilePicture;
@property (strong, nonatomic) CustomTableView *mainBeerTableView;
@end
