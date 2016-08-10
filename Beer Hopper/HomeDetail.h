//
//  HomeDetail.h
//  Beer Hopper
//
//  Created by Justin Goulet on 1/13/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Brewery.h"
#import "Beer.h"
#import "AppDelegate.h"
#import "HopperData.h"
#import "ImageActivityView.h"
#import "NothingFoundTableViewCell.h"
#import "MyAnalytics.h"
#import "Alert.h"
#define METERS_PER_MILE 1609.344

@interface HomeDetail : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate>
{
    AppDelegate *delagate;
    CLLocationManager *locationManager;
    NSMutableArray *breweryCoverPhotos;
    int breweryCount;
    UIImageView *mainImage;
    ImageActivityView *activity;
    BOOL alertAdded;
    Alert *tempAlert;
}
@property (nonatomic) NSArray *breweries;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mainMapView;
@property (strong, nonatomic) IBOutlet UITableView *mainBreweriesTable;
@property (weak, nonatomic) IBOutlet UIView *back;
@property (nonatomic) BOOL noBreweriesFound, loaded;

-(IBAction)refreshBreweries;

@end
