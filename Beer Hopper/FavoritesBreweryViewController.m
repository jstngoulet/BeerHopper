//
//  FavoritesBreweryViewController.m
//  Beer Hopper
//
//  Created by Justin Goulet on 4/15/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "FavoritesBreweryViewController.h"
#import "MyAnalytics.h"

@interface FavoritesBreweryViewController ()

@end

@implementation FavoritesBreweryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    breweriesAddedToArray = [[NSMutableArray alloc] init];
    //Start simple
    self.breweriesFavorited = [[NSMutableArray alloc] init];
}

-(void)viewDidAppear:(BOOL)animated{
    
    MyAnalytics *temp = [[MyAnalytics alloc] init];
    [temp viewShown:@"Favorites"];
    
    NSMutableArray *favoriteBreweriesID = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"favBreweries"]];
    self.breweryData = [[HopperData alloc] init];
    tempDelagate = [[UIApplication sharedApplication] delegate];
    [self.mainTable reloadData];
    
    //Add the frame for the liked beers image
    float tabbarHeight = self.navigationController.navigationBar.frame.size.height + self.tabBarController.tabBar.frame.size.height;
    noBeersLikedImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, tabbarHeight, self.view.frame.size.width, self.view.frame.size.height - tabbarHeight)];
    noBeersLikedImage.image = [UIImage imageNamed:@"HowToLikeBrewery.png"];
    [self.view addSubview:noBeersLikedImage];
    noBeersLikedImage.contentMode = UIViewContentModeScaleAspectFit;
    noBeersLikedImage.hidden = YES;
    noBeersLikedImage.backgroundColor = self.view.backgroundColor;
    noBeersLikedImage.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + tabbarHeight/4);
    
    if (self.breweriesFavorited.count == 0) {
        noBeersLikedImage.hidden = NO;
    }
    
    //Because we just have the ids, we have to get the cover photos of each brewery
    if(![self.breweriesFavorited isEqual:breweriesAddedToArray] || self.breweriesFavorited.count != favoriteBreweriesID.count){
        //REmove all objects
        [self.breweriesFavorited removeAllObjects];
        
    for (NSString *iden in favoriteBreweriesID) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/Breweries/%@?api_key=keyBAo5QorTmqZmN8", iden]];
        
        NSURLRequest *res = [NSURLRequest requestWithURL:url];
        NSOperationQueue*que=[NSOperationQueue new];
        //NSLog(@"Starting Request for id: %@", iden);
        
        //To save network collaboration, see of the brewery was already loaded
       /* if([self favoriteContains:iden]){
            //NSLog(@"Found Brewery: %@", iden);
            
            //Since the brewery already exists, we dont need to get the infomration again.
            for (Brewery *tem in tempDelagate.breweries) {
                if ([tem.iden isEqualToString:iden]) {
                    
                    holderBrewery = tem;
                    //Add the brewery
                    [self.breweriesFavorited addObject:tem];
                    [breweriesAddedToArray addObject:tem];
                    
                    [self.mainTable performSelectorOnMainThread:@selector(reloadData) withObject:NULL waitUntilDone:YES];
                }
            }
        }*/
        //else{
            //NSLog(@"Brewery: %@, ", iden);
            
            [NSURLConnection sendAsynchronousRequest:res queue:que completionHandler:^(NSURLResponse*rep,NSData*data,NSError*err){
                if ([data length]> 0 && err == nil) {
                    //NSString* rel=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    //NSLog(@"rel: %@", rel);
                    
                    NSDictionary* type = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:kNilOptions
                                          error:&err];
                    
                    //for (NSDictionary *type in json)
                    //{
                    //NSLog(@"%@", type);
                    Brewery *newBrewery = [[Brewery alloc] init];
                    
                    newBrewery.name = type[@"fields"][@"Brewery Name"];
                    //NSLog(@"brewery Name: %@", newBrewery.name);
                    newBrewery.iden = type[@"id"];
                    
                    NSDictionary *coverImageURL = type[@"fields"][@"Cover Photo"];
                    
                    for (NSDictionary *keys in coverImageURL) {
                        //NSLog(@"Keys: %@", keys);
                        newBrewery.coverPicURL = keys[@"url"];
                        
                    }
                    //NSLog(@"Cover Image URL: %@", coverImageURL);
                    NSDictionary *profileImageURL = type[@"fields"][@"Profile Picture"];
                    
                    //NSDictionary *keys
                    
                    for (NSDictionary *keys in profileImageURL) {
                        newBrewery.picURL = keys[@"url"];
                    }
                    
                    //Get the location
                    newBrewery.location = [[CLLocation alloc] initWithLatitude:[type[@"fields"][@"Latitude"] floatValue] longitude:[type[@"fields"][@"Longitude"] floatValue]];
                    
                    //Get the distance
                    CLLocationDistance meters = [newBrewery.location distanceFromLocation:self.breweryData.locationManager.location];
                    newBrewery.distance = meters*METERS_PER_MILE;
                    
                    // Add some info
                    newBrewery.phoneNumber = type[@"fields"][@"Phone Number"];
                    
                    newBrewery.address1 = type[@"fields"][@"Street Address"];
                    NSArray *cityArray = [NSArray arrayWithArray:type[@"fields"][@"City"]];
                    newBrewery.city = cityArray[0];
                    newBrewery.state = type[@"fields"][@"State"];
                    newBrewery.zip = type[@"fields"][@"Zip Code"];
                    
                    newBrewery.breweryDescription = type[@"fields"][@"About"];
                    newBrewery.hours = type[@"fields"][@"Hours"];
                    newBrewery.ammenities = type[@"fields"][@"Ammenities"];
                    newBrewery.hasFoodNearby = [type[@"fields"][@"Has Food Nearby"] boolValue];
                    newBrewery.hasIndoorOutdoorArea = [type[@"fields"][@"Indoor & Outdoor Area"]boolValue];
                    newBrewery.website = [NSURL URLWithString:type[@"fields"][@"Website"]];
                    newBrewery.beerList = [NSMutableArray arrayWithArray:type[@"fields"][@"Beer List"]];
                    newBrewery.numberOfTimesBeforeReview = [type[@"fields"][@"NumberOfVisitsBeforeReview"] intValue];
                    //NSLog(@"Beer list: %@", newBrewery.beerList);
                    
                    //Add the beers
                    /*
                    for (NSString *iden in type[@"fields"][@"Beer List"]) {
                        
                        
                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/Beers/%@?api_key=keyBAo5QorTmqZmN8", iden]];
                        NSURLRequest *res = [NSURLRequest requestWithURL:url];
                        NSOperationQueue*que=[NSOperationQueue new];
                        
                        [NSURLConnection sendAsynchronousRequest:res queue:que completionHandler:^(NSURLResponse*rep,NSData*data,NSError*err){
                            if ([data length]> 0 && err == nil) {
                                //NSString* rel=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                //NSLog(@"REL: %@", rel);
                                NSDictionary* type = [NSJSONSerialization
                                                      JSONObjectWithData:data
                                                      options:kNilOptions
                                                      error:&err];
                                //NSLog(@"%@",type);
                                
                                
                                Beer *newBeer = [[Beer alloc] initWithName:type[@"fields"][@"Beer Name"] type:@"" description:type[@"fields"][@"Beer Description"]];
                                newBeer.iden = type[@"id"];
                                newBeer.reviews = [NSArray arrayWithArray:type[@"fields"][@"Reviews"]];
                                newBeer.ABV = [type[@"fields"][@"ABV"] floatValue];
                                newBeer.beerType = [type[@"fields"][@"Beer Type"] objectAtIndex:0];
                                newBeer.fromTheBrewer = type[@"fields"][@"From the Brewmaster"];
                                newBeer.IBU = [type[@"fields"][@"IBU"] floatValue];
                                newBeer.servingGlass = type[@"fields"][@"Recommended Serving Glass"];
                                newBeer.isAvail = [type[@"fields"][@"isAvailable"] boolValue];
                                newBeer.votes = [type[@"fields"][@"TotalVotes"] intValue];
                                
                                //NSLog(@"New BEer is avail: %i", newBeer.isAvail);
                                
                                //Get the image
                                NSDictionary *coverImageURL = type[@"fields"][@"Picture"];
                                
                                for (NSDictionary *keys in coverImageURL) {
                                    //NSLog(@"Keys: %@", keys);
                                    //newBeer.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:keys[@"url"]]]];
                                    newBeer.imageURL = keys[@"url"];
                                    //Get other info
                                }
                                
                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                    UIImage *pic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:newBeer.imageURL]]];
                                    
                                    // update UI on the main thread
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        newBeer.image = pic;
                                    });
                                    
                                });
                                [newBrewery.beerList addObject:newBeer];
                                //NSLog(@"BRewery: %@", newBrewery.description);
                                
                                
                            }
                            
                            else{
                                NSLog(@"Data is Null");
                            }
                            
                        }
                         ];
                        
                    }*/
                    
                    
                    //Add the brewery
                    [self.breweriesFavorited addObject:newBrewery];
                    [breweriesAddedToArray addObject:newBrewery];
                    
                    //Now sort by brewwery name
                    self.breweriesFavorited = [NSMutableArray arrayWithArray:[self.breweriesFavorited sortedArrayUsingSelector:@selector(compareNames:)]];
                    //breweriesAddedToArray = [NSMutableArray arrayWithArray:[breweriesAddedToArray sortedArrayUsingSelector:@selector(compareNames:)]];
                
                    [self.mainTable performSelectorOnMainThread:@selector(reloadData) withObject:NULL waitUntilDone:YES];
                }
                else{
                    NSLog(@"Erorr: %@", err.localizedDescription);
                }
            }];
       // }
        //break;
        
    }
    }
}

-(BOOL)favoriteContains:(NSString *)temp{
    for(NSString *temp2 in tempDelagate.breweryIdens){
        if ([temp isEqualToString:temp2]) {
            //NSLog(@"Match Found!");
            return YES;
        }
        //else NSLog(@"No Match between %@ and %@", temp, temp2);
    }
    return NO;
}

-(void)addView:(Brewery *)temp{
    NSLog(@"Adding view for brewery: %@", temp.name);
}


/**
 *  Table view delagtes
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.breweriesFavorited.count > 0){
        self.noBeersFound = NO;
        noBeersLikedImage.hidden = YES;
        return self.breweriesFavorited.count;
    }
    else{
        self.noBeersFound = YES;
        noBeersLikedImage.hidden = NO;
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{//NSLog(@"Row Hieght (Home Detail): %.0f", tableView.frame.size.height/4);return tableView.frame.size.height/4;
    tableView.backgroundColor = [UIColor clearColor];
    return tableView.frame.size.height/3;
}


/**
 *  Build the cell (Note that the business labels should be replaced with feedback)
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(!self.noBeersFound){
    static NSString *identifier = @"FavoriteBreweryCell";
    [tableView registerNib:[UINib nibWithNibName:@"FavoriteBreweryCell" bundle:nil] forCellReuseIdentifier:identifier];
    
    // Get the cell's root view and set the table's
    // rowHeight to the root cell's height.
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FavoriteBreweryCell"
                                                 owner:self
                                               options:nil];
    BreweryView *cell = (BreweryView *)nib[0];
    @try {
        cell.thisBrewery = (Brewery *)[self.breweriesFavorited objectAtIndex:indexPath.row];
        cell.breweryName.text = cell.thisBrewery.name;
        
        //Only do next sectionsif not yet completed
        if (cell.thisBrewery.profilePicture.description.length == 0){
            
            cell.coverPhoto.image = [UIImage imageNamed:@"SearchingForBrewery.png"];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                
                UIImage *pro = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:cell.thisBrewery.picURL]]];
                UIImage *cov = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:cell.thisBrewery.coverPicURL]]];
                
                //[(Brewery *)[_breweries objectAtIndex:indexPath.row] setCoverPhoto:cover];
                //cell.loaded = YES;
                
                // update UI on the main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.profilePicture.image = pro;
                    cell.coverPhoto.image = cov;
                    cell.thisBrewery.coverPhoto = cov;
                    cell.thisBrewery.profilePicture = pro;
                    //cell.loaded = YES;
                });
                
            });
        }
        else{
            cell.coverPhoto.image = cell.thisBrewery.coverPhoto;
            cell.profilePicture.image = cell.thisBrewery.profilePicture;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
    //NSLog(@"Current Text: %@ /end text", currentCell.businessTitle.text);
    return cell;
    }else{
        //NSLog(@"Nothing Found");
        static NSString *identifier = @"NothingFound";
        [tableView registerNib:[UINib nibWithNibName:@"NothingFoundTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
        
        // Get the cell's root view and set the table's
        // rowHeight to the root cell's height.
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NothingFoundTableViewCell"
                                                     owner:self
                                                   options:nil];
        NothingFoundTableViewCell *cell = (NothingFoundTableViewCell *)nib[0];
        @try {
            cell.label.text = @"No Favorites Yet!";
        }@catch(NSException *e){
            NSLog(@"Exception: %@", e.description);
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.mainView.backgroundColor = cell.backgroundColor;
        return cell;
    }

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BreweryHomePage *temp = [self.storyboard instantiateViewControllerWithIdentifier:@"Brewery Home Page"];
    temp.title = [(Brewery *)[self.breweriesFavorited objectAtIndex:indexPath.row] name];
    temp.brewery = (Brewery *)[self.breweriesFavorited objectAtIndex:indexPath.row];
    
    //Send an event for dropping Pin
    //Google Analytics
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIEventLabel value:@"Favorites"];
    [tracker allowIDFACollection];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Favorites" action:@"Brewery Selected" label:[NSString stringWithFormat:@"%@ was selected by a user!", temp.brewery.name] value:0] build]];
    
    [self.navigationController pushViewController:temp animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
