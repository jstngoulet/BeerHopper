//
//  BreweryHomePage.h
//  Beer Hopper
//
//  Created by Justin Goulet on 1/14/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brewery.h"
#import "Beer.h"
#import "BreweryPageView.h"

@interface BreweryHomePage : UIViewController
{
    BreweryPageView *homePage;
}

@property (strong, nonatomic) Brewery *brewery;
@property (strong, nonatomic) NSMutableArray *beerListIdens;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favoritesButton;

@end
