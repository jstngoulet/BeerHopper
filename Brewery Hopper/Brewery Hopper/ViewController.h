//
//  ViewController.h
//  Brewery Hopper
//
//  Created by Justin Goulet on 5/31/16.
//  Copyright © 2016 Justin Goulet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageButton.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *mainSubview;
@property (strong, nonatomic) ImageButton *claim, *create;

@end

