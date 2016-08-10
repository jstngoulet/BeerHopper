//
//  AddBreweryAddressViewController.m
//  Brewery Hopper
//
//  Created by Justin Goulet on 5/31/16.
//  Copyright © 2016 Justin Goulet. All rights reserved.
//

#import "AddBreweryAddressViewController.h"

@interface AddBreweryAddressViewController ()

@end

@implementation AddBreweryAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Add the "Use current location" button
    self.useCurrentLocationButton = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/4, self.view.frame.size.width/4)];
    self.useCurrentLocationButton.primaryTitle.text = @"Use Current Location";
    self.useCurrentLocationButton.center = CGPointMake(self.primaryView.frame.size.width/2, self.primaryView.frame.size.height - (self.orLabel.center.y + self.orLabel.frame.size.height) + self.useCurrentLocationButton.frame.size.height/1.5);
    [self.primaryView addSubview:self.useCurrentLocationButton];
    [self.useCurrentLocationButton addTarget:self action:@selector(getCurrentLocation) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)getCurrentLocation{
    //Get current location;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    //[self->_locationManager requestAlwaysAuthorization];
    
    //fill in missing address info here
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
