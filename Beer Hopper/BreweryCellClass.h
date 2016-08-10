//
//  BreweryCellClass.h
//  Beer Hopper
//
//  Created by Justin Goulet on 1/14/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BreweryCellClass : UITableViewCell


@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *breweryName;
@property (weak, nonatomic) IBOutlet UILabel *beersOnNitro, *beersOnCO2, *eventsCount;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (nonatomic) BOOL loaded;
@end
