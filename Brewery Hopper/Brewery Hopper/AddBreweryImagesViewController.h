//
//  AddBreweryImagesViewController.h
//  Brewery Hopper
//
//  Created by Justin Goulet on 5/31/16.
//  Copyright © 2016 Justin Goulet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageButton.h"

@interface AddBreweryImagesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) ImageButton *coverImageSelect, *profileImageSelect;

@end
