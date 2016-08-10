//
//  RoutesViewController.h
//  Beer Hopper
//
//  Created by Justin Goulet on 1/16/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RouteCell.h"
#import "RouteObject.h"
#import "AppDelegate.h"

@interface RoutesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>
{
    AppDelegate *delagate;
}
@property (nonatomic) NSArray *myRoutes;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *routesTable;

@end
