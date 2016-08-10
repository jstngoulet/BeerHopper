//
//  MainViewController.h
//  Brewery Hopper
//
//  Created by Justin Goulet on 5/31/16.
//  Copyright © 2016 Justin Goulet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoTableView.h"
#import <MapKit/MapKit.h>
#import "OperationsView.h"

@interface MainViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    NSMutableArray *breweries, *events;
}
@property (strong, nonatomic) InfoTableView *breweriesView, *eventsView;
@property (strong, nonatomic) OperationsView *operationsView;

@end
