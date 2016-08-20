//
//  BreweryDetailsViewController.h
//  Beer Hopper
//
//  Created by Justin Goulet on 1/31/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brewery.h"
#import "CustomTableView.h"
#import "ImageActivityView.h"
#import "RatingsMasterView.h"
#import "CollapseableView.h"

@interface BreweryDetailsViewController : UIViewController{
    ImageActivityView *activity;
    CustomTableView *newTableView;
}

@property (strong, nonatomic) Brewery *thisBrewery;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIScrollView *background;
@property (nonatomic) float offset;
@property (nonatomic) NSURL *currentSite;
@property (strong, nonatomic) UIImageView *breweryProfilePicture, *breweryCoverPhoto;
@end
