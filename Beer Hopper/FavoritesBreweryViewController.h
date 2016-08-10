//
//  FavoritesBreweryViewController.h
//  Beer Hopper
//
//  Created by Justin Goulet on 4/15/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HopperData.h"
#import "BreweryView.h"
#import "BreweryHomePage.h"
#import "Brewery.h"
#import "AppDelegate.h"
#import "NothingFoundTableViewCell.h"

@interface FavoritesBreweryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UIImage *beer;
    NSMutableArray *breweriesAddedToArray;
    AppDelegate *tempDelagate;
    Brewery *holderBrewery;
    UIImageView *noBeersLikedImage;
}

@property (nonatomic, strong) NSMutableArray *breweriesFavorited;
@property (nonatomic, strong) HopperData *breweryData;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;

@property (nonatomic) BOOL noBeersFound;


@end
