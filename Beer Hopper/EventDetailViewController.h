//
//  EventDetailViewController.h
//  Beer Hopper
//
//  Created by Justin Goulet on 1/21/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "ImageButton.h"
#import "HopperData.h"

@interface EventDetailViewController : UIViewController
{
    NSArray *keys;
    float currentY;
    HopperData *myData;
    NSString *yourResponse;
    NSArray *responseButtons;
}
@property (strong, nonatomic) Event *thisEvent;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIImageView *breweryProfilePicture, *breweryCoverPhoto;
@property (strong, nonatomic) UILabel *eventTitleLabel;
@property (strong, nonatomic) UIScrollView *background;

@end
