//
//  BreweryView.h
//  Beer Hopper
//
//  Created by Justin Goulet on 4/15/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brewery.h"

@interface BreweryView : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *breweryName;
@property (nonatomic, strong) Brewery *thisBrewery;

@end
