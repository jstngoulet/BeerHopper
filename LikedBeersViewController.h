//
//  LikedBeersViewController.h
//  Beer Hopper
//
//  Created by Justin Goulet on 6/24/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeerTableViewCell.h"
#import "BeerDetailViewController.h"
#import "ImageActivityView.h"
#import "HopperData.h"
#import "Brewery.h"
#import "NothingFoundTableViewCell.h"

@interface LikedBeersViewController : UIViewController < UITableViewDelegate, UITableViewDataSource>
{
    ImageActivityView *activity;
    HopperData *myData;
    Brewery *thisBrewery;
    UIImageView *noBeersLikedImage;
}

@property (nonatomic) BOOL loadedBeerList, noBeersFound;
@property (nonatomic) int beerListCount;
@property (strong, nonatomic) NSMutableArray *beerList, *beers, *likedBeers; //BEerlist is for records while beers is completed beer list
@property (weak, nonatomic) IBOutlet UITableView *mainTable;

@end
