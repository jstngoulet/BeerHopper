//
//  AppInfoViewController.h
//  Beer Hopper
//
//  Created by Justin Goulet on 6/27/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HopperData.h"
#import "CustomTableView.h"

@interface AppInfoViewController : UIViewController
{
    HopperData *myData;
    CustomTableView *table;
}

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *breweryCoverPhoto, *breweryProfilePicture;

@end
