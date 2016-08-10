//
//  AppDelegate.h
//  Beer Hopper
//
//  Created by Justin Goulet on 1/13/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brewery.h"
#import "Beer.h"
#import "HopperData.h"
#import <Google/Analytics.h>
/**
 *  Analytics were completed for the favorites view and hte home page. Still need to complete:
 *      Favorites, Routes, Forums, Liking a brewery, and Events;
 */

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    //Add some breweries
    Brewery *motherEarth, *ironFist, *belchingBeaver, *boozeBrothers;
}
@property (strong, nonatomic) NSArray *breweries, *breweryIdens, *beerIdens;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HopperData *myHopperData;
@property (weak, nonatomic) UITableView *currentTable;
-(void)getBrewInfo;
-(void)getMessages;
-(void)getEvents;

@end

