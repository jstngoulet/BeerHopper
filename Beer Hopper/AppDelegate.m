//
//  AppDelegate.m
//  Beer Hopper
//
//  Created by Justin Goulet on 1/13/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "AppDelegate.h"
#import "Home.h"
#import "HomeDetail.h"
#import "Brewery.h"
#import "Beer.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //UITabBarController *tabBar = (UITabBarController *)self.window.rootViewController;
    //tabBar.selectedIndex = 2;
    
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
   // gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //Start getting location data in background
    [self.myHopperData.locationManager startMonitoringSignificantLocationChanges];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[NSUserDefaults standardUserDefaults] setBool:0 forKey:@"nullMyLocation"];
}

-(void)getBrewInfo{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventHandler:) name:@"addEventsNow" object:nil];
    self.myHopperData = [[HopperData alloc] init];
    
        [self.myHopperData getFromTable:@"breweries"];
        //[self.myHopperData getFromTable:@"Beers"];
        //[self.myHopperData getFromTable:@"events"];
        [self.myHopperData getFromTable:@"messages"];
    
    /*
    [self addIronFist];
    [self addMotherEarth];
    [self addBoozeBrothers];
    [self addBelchingBeaver];
     */
}

-(void)getMessages{
    [self.myHopperData getFromTable:@"messages"];
}

-(void)getEvents{
    [self.myHopperData getEvents];
}

-(void)eventHandler:(NSNotification *)notif{
    if([notif.name isEqualToString:@"addEventsNow"]){
        //NSLog(@"Adding events");
        [self.myHopperData getEvents];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
