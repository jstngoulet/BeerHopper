//
//  AddBreweryAddressViewController.h
//  Brewery Hopper
//
//  Created by Justin Goulet on 5/31/16.
//  Copyright © 2016 Justin Goulet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageButton.h"
#import <MapKit/MapKit.h>

@interface AddBreweryAddressViewController : UIViewController <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (strong, nonatomic) ImageButton *useCurrentLocationButton;
@property (weak, nonatomic) IBOutlet UIView *primaryView;
@property (weak, nonatomic) IBOutlet UIButton *nextPageBtn;
@end
