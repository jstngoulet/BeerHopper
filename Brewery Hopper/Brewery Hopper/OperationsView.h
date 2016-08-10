//
//  OperationsView.h
//  Brewery Hopper
//
//  Created by Justin Goulet on 5/31/16.
//  Copyright © 2016 Justin Goulet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageButton.h"

@interface OperationsView : UIView

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) ImageButton *beerManager, *eventManager, *breweryManager, *feedBackManager;

@end
