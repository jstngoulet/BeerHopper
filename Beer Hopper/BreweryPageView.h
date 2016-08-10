//
//  BreweryPageView.h
//  Beer Hopper
//
//  Created by Justin Goulet on 1/15/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Beer.h"
#import "BeerView.h"
#import "Brewery.h"
#import "AppDelegate.h"
#import "BreweryDetailsViewController.h"
#import "BeerTableViewCell.h"
#import "BeerView.h"
#import "BeerDetailViewController.h"
#import "HopperData.h"
#import "ImageActivityView.h"

@interface BreweryPageView : UIView <UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, UIAlertViewDelegate>
{
    AppDelegate *delagate;
    UIView *back;
    NSMutableArray *likedBeers;
    HopperData *myData;
    ImageActivityView *activity;
    UIImageView *mainImage;
}


@property (strong, nonatomic) UITableView *beerTable;
@property (strong, nonatomic) MKMapView *breweryMap;
@property (strong, nonatomic) Brewery *brewery;
@property (strong, nonatomic) UIImageView *coverPhoto;
@property (strong, nonatomic) UIImageView *profileImage;
@property (strong, nonatomic) NSMutableArray *beers;
@property (strong, nonatomic) UIButton *callButton;
@property (strong, nonatomic) UIButton *mapsButton;
@property (strong, nonatomic) UIButton *breweryInfoButton;
@property (strong, nonatomic) UIButton *breweryQuestionsButton;
@property (strong, nonatomic) UIScrollView *beersOnTapScroller;
@property (strong, nonatomic) UILabel *beersOnTapLabel;
@property (strong, nonatomic) NSMutableArray *beerList, *beerListIdens;    //Array of beer Objects
@property (strong, nonatomic) UIStoryboard *currentWindow;
@property (weak, nonatomic) UIViewController *tempView;
@property (nonatomic) BOOL loadedBeers, noBeersFound;

-(void)buildTable;
-(void)createTable;
-(void)getData;
//-(void)build;
-(void)currentWindow:(UIStoryboard *)wind viewController:(UIViewController *)tempViewController;

@end
