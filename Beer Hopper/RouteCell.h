//
//  RouteCell.h
//  Beer Hopper
//
//  Created by Justin Goulet on 1/16/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "RouteObject.h"
#import "AppDelegate.h"

@interface RouteCell : UITableViewCell <MKMapViewDelegate>
{
    //AppDelegate *delagate;
}

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet MKMapView *routeMap;
@property (weak, nonatomic) IBOutlet UILabel *nameOfRoute;
@property (weak, nonatomic) IBOutlet UILabel *numberTimeTakenLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastTourLabel;
@property (weak, nonatomic) IBOutlet UIImageView *beweryProfilePic1;
@property (weak, nonatomic) IBOutlet UIImageView *beweryProfilePic2;
@property (weak, nonatomic) IBOutlet UIImageView *beweryProfilePic3;
@property (weak, nonatomic) IBOutlet UIImageView *beweryProfilePic4;
@property (strong, nonatomic) RouteObject *currentRoute;

-(void)setDelagate;
-(void)dropPins;
-(void)addShadowToView:(UIView *)temp;

@end
