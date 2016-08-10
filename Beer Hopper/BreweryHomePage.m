//
//  BreweryHomePage.m
//  Beer Hopper
//
//  Created by Justin Goulet on 1/14/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "BreweryHomePage.h"

@implementation BreweryHomePage

-(void)viewDidAppear:(BOOL)animated{
    [homePage.beerTable reloadData];
    
    MyAnalytics *temp = [[MyAnalytics alloc] init];
    [temp viewShown:@"Brewery Main Page"];
    [temp eventAction:@"Opened Brewery Main Page" category:@"Brewery Main Page" description:@"The user viewed a brewery by either selecting the brewery name in the event, the brewery from the home page, or from the favorites menu" breweryIden:self.brewery.iden beerIden:@"" eventIden:@""];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //Keep
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    //Bring in the other view
    /*
    BreweryPageView *brew = [[BreweryPageView alloc] initWithFrame:self.view.frame];
    brew.brewery = self.brewery;
    [brew build];
    //[brew getData];
    [brew buildTable];
    [brew currentWindow:self.storyboard viewController:self];
     
     [self.view addSubview:brew];
     */
    
    homePage = [[BreweryPageView alloc] initWithFrame:self.view.frame];
    homePage.brewery = self.brewery;
   // self.beerListIdens = self.brewery.beerList;
    //NSLog(@"BEer List count: %i", (int)self.beerListIdens.count);
    homePage.beerListIdens = homePage.brewery.beerList;
    [homePage currentWindow:self.storyboard viewController:self];
    [homePage createTable];
    [self.view addSubview:homePage];
    
    
    NSMutableArray *favoriteBreweriesID = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"favBreweries"]];
    
    //If the array contains the brewery, set liked
    [self setLiked:[favoriteBreweriesID containsObject:self.brewery.iden]];
    
}


-(void)setLiked:(BOOL)value{
    if(value) [self.favoritesButton setTintColor:[UIColor colorWithRed:1.000 green:0.878 blue:0.235 alpha:1.00]];
    else [self.favoritesButton setTintColor:[UIColor whiteColor]];
    
    
}

-(IBAction)alterFavorites:(id)sender{
    //Determines whether the beer is in favorites or not
    NSMutableArray *favoriteBreweriesID = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"favBreweries"]];
    if([favoriteBreweriesID containsObject:self.brewery.iden]){
        [favoriteBreweriesID removeObject:self.brewery.iden];
        [self setLiked:NO];
    }
    else {
        [favoriteBreweriesID addObject:self.brewery.iden];
        [self setLiked:YES];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[favoriteBreweriesID copy] forKey:@"favBreweries"];
}

@end
