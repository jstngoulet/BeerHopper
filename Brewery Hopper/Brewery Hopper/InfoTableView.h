//
//  InfoTableView.h
//  Brewery Hopper
//
//  Created by Justin Goulet on 5/31/16.
//  Copyright © 2016 Justin Goulet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BreweryView.h"
#import "Brewery.h"
#import "Event.h"
#import "EventCellClass.h"
#import "ImageActivityView.h"
#define METERS_PER_MILE 1609.344

@interface InfoTableView : UIView <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) NSString *currentType;
@property (strong, nonatomic) NSArray *currentInfo;
@property (strong, nonatomic) UITableView *mainTable;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *actionButton;
@property (strong, nonatomic) ImageActivityView *activity;

@end
