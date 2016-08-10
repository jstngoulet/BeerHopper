//
//  HomeDetail.m
//  Beer Hopper
//
//  Created by Justin Goulet on 1/13/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "HomeDetail.h"
#import "BreweryHomePage.h"
#import "BreweryCellClass.h"

@interface HomeDetail ()

@end

@implementation HomeDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loaded = NO;
    //Get current location;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    //[self->locationManager requestAlwaysAuthorization];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];
    
    delagate = [[UIApplication sharedApplication] delegate];
    self.mainMapView.delegate = self;
    delagate.currentTable = self.mainBreweriesTable;
    
    
    //[self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBreweries) name:@"userCreated" object:nil];
    
    breweryCoverPhotos = [[NSMutableArray alloc] init];
    //[self refreshBreweries];
    [self addView:[UIImage imageNamed:@"Beer_Hopper_Banner.png"] index:0];
    self.view.backgroundColor = [UIColor colorWithRed:0.906 green:0.922 blue:0.933 alpha:1.00];
    
    //Save for use
    UINavigationBar *currentBar = self.navigationController.navigationBar;
    UITabBar *tab = self.navigationController.tabBarController.tabBar;
    
    //Fix the main scroller
    self.mainBreweriesTable = [[UITableView alloc] initWithFrame:CGRectMake(0, currentBar.frame.size.height*2 + mainImage.frame.origin.y + mainImage.frame.size.height + 25, self.view.frame.size.width, self.view.frame.size.height - (mainImage.frame.origin.y + mainImage.frame.size.height + 25 + tab.frame.size.height) - currentBar.frame.size.height*2)];
    self.mainBreweriesTable.backgroundColor = [UIColor clearColor];
    self.mainBreweriesTable.dataSource = self;
    self.mainBreweriesTable.delegate = self;
    [self.view addSubview:self.mainBreweriesTable];
    
    
    activity = [[ImageActivityView alloc] init];
    [activity hidesWhenNotAnimating];
    [self.view addSubview:activity];
    activity.tintColor = [UIColor colorWithRed:0.380 green:0.490 blue:0.541 alpha:1.00];
    [activity useImage:[UIImage imageNamed:@"BeerHopperLogo.png"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventHandler:) name:@"NullData-events" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventHandler:) name:@"NullData-breweries" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventHandler:) name:@"NullData-messages" object:nil];
    
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"][@"id"]length] ==0){
    //if(1==1){
        // NSLog(@"Showing Tutorial");
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Tutorial"];
        [self.tabBarController presentViewController:vc animated:NO completion:nil];
    }
    else{
        //NSLog(@"Already Shown");
        [activity startAnimating];
        [self loadData];
    }
    
    //register to listen for event
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventHandler:) name:@"breweriesAdded" object:nil];
}

/**
-(void)animateScroller:(int)startingValue{
    
    NSLog(@"Starting Value: %i of %i", startingValue, (int)self.breweries.count);
    NSLog(@"Modded: %i", startingValue % (int)self.breweries.count);
    startingValue = startingValue % (self.breweries.count);
    
    [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        //[self.coverScroller setContentOffset:maximumOffsetPoint]; //spin all the way up?
        [self.coverScroller setContentOffset:
         CGPointMake(self.coverScroller.frame.size.width + (self.coverScroller.frame.size.width * startingValue), 0)];
    }completion:^(BOOL finished){
        if (finished){
          [self animateScroller:startingValue+1];
        }
    }];
    
}
 */

-(void)loadData{
    self.loaded = NO;
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [delagate getBrewInfo];
        
        // update UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"Refreshing Table");
            [self getTableData];
            self.loaded = YES;
            //self.breweries = [[delagate breweries] sortedArrayUsingSelector:@selector(compareWithAnotherBrewery:)];
            //self.breweries = [[self.breweries reverseObjectEnumerator] allObjects];
            [self.mainBreweriesTable reloadData];
            
            //Looking for notification
            //register to listen for event
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventHandler:) name:@"coverPhoto" object:nil];
            
            
        });
        
    });
}

-(void)eventHandler:(NSNotification *)notif{
    //NSLog(@"Ended, %@", notif.name);
    
    if([notif.name isEqualToString:@"coverPhoto"]){
    breweryCount++;
    
        self.breweries = [delagate breweries];
        [self.mainBreweriesTable reloadData];
        
    
    //NSLog(@"Brewery Count: %i, total: %i", breweryCount, self.breweries.count);
    if(breweryCount == (int)self.breweries.count){
        //NSLog(@"Refreshing");
        
        //Get the brewery cover photos
        for (Brewery *temp in delagate.breweries) {
            
            if (temp.coverPhoto.description.length > 0 && ![temp.coverPhoto isEqual:[UIImage imageNamed:@"SearchingForBrewery.png"]]) {
                //Add it into the array
                //NSLog(@"Brewery added: %@", temp.name);
                [breweryCoverPhotos addObject:temp.coverPhoto];
            }
        }
        
        //if(breweryCount == 1){
        //Now, set the images
        mainImage.animationImages = [breweryCoverPhotos copy];
        mainImage.animationDuration = breweryCoverPhotos.count * 5;
        mainImage.contentMode = UIViewContentModeScaleAspectFill;
        [mainImage startAnimating];
        //}
        
    }
    }
    else if ([notif.name isEqualToString:@"breweriesAdded"]){
        //self.breweries = [[delagate breweries] sortedArrayUsingSelector:@selector(compareWithAnotherBrewery:)];
        if(self.breweries.count == 0){
            self.noBreweriesFound = YES;
        }
        self.loaded = YES;
        [self.mainBreweriesTable reloadData];
        if (self.breweries.count == 0 && !alertAdded) {
            alertAdded = YES;
            //[self addAlert];
        }
        NSLog(@"Finished Loading");
    }
    else if ([notif.name isEqualToString:@"NullData-breweries"]){
        NSLog(@"No Breweries Found");
        self.noBreweriesFound = YES;
        [self.mainBreweriesTable reloadData];
    }
    else{
        NSLog(@"Notif not accounted for: %@", notif.name);
    }
    [activity stopAnimating];
}

-(void)addAlert{
    
    tempAlert = [[Alert alloc] initWithTitle:@"No Breweries Found!" text:@"We were unable to locate breweries near you. \nIf you have location services turned off, please turn it on by going to:\n\nSettings->Privacy->Beer Hopper\n\nOr, we can set your location to the Famous \n\"Hop Highway\" in Vista, CA.\n\nWould you like us to set it for you?" closeBtnTitle:@"No Thanks" customBtnTitle:@"Yes" withAction:@selector(setLocationNull) fromClass:self];
    tempAlert.title.backgroundColor = [UIColor colorWithRed:0.306 green:0.416 blue:0.471 alpha:1.00];
    tempAlert.title.textColor = [UIColor whiteColor];
    [tempAlert show];
    tempAlert.title.font = [UIFont boldSystemFontOfSize:24];
    
    
}

-(void)setLocationNull{
    //Present a new notification in NSNotification Center to tell the delegate class that I do not want to use the location Manager to get my information
    [[delagate myHopperData] nullMyLocation];
    
    [[NSUserDefaults standardUserDefaults] setBool:1 forKey:@"nullMyLocation"];
    
    //Then, refresh the brewery list
    [self refreshBreweries];
}

-(void)viewDidAppear:(BOOL)animated{
    
    //Refresh the actual breweries
    self.mainBreweriesTable.contentInset = UIEdgeInsetsMake(5, 0, 10, 0);
    //[self getTableData];
    
    
    //Google analytics
    
    MyAnalytics *temp = [[MyAnalytics alloc] init];
    [temp viewShown:@"Home Detail"];
    
    //if(activity.isAnimating) [activity startAnimating];
    //else [activity stopAnimating];
    
    
    
}

-(IBAction)refreshBreweries{
    NSLog(@"Bool Value: %i", [[[NSUserDefaults standardUserDefaults] objectForKey:@"nullMyLocation"] boolValue]);
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"][@"fields"][@"Alias"] length] > 0) self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome Back, %@!", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"][@"fields"][@"Alias"]];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"nullMyLocation"] boolValue] || locationManager.location){
    //Update the breweries
    [activity startAnimating];
    [self loadData];
    
    //Send an event for dropping Pin
    MyAnalytics *temp = [[MyAnalytics alloc] init];
    [temp eventAction:@"Refreshed Breweries" category:@"Home Detail" description:@"The refresh button was either tapped or loaded by the user" breweryIden:@"" beerIden:@"" eventIden:@""];
    
    //copy your annotations to an array
    NSMutableArray *annotationsToRemove = [[NSMutableArray alloc] initWithArray: self.mainMapView.annotations];
    //Remove the object userlocation
    [annotationsToRemove removeObject: self.mainMapView.userLocation];
    //Remove all annotations in the array from the mapView
    [self.mainMapView removeAnnotations: annotationsToRemove];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude), 5*METERS_PER_MILE, 5*METERS_PER_MILE);
    [self.mainMapView setRegion:[self.mainMapView regionThatFits:region] animated:NO];
    }
    else{
        [self addAlert];
    }
}

-(void)getTableData{
    //_breweries = [delagate.breweries sortedArrayUsingSelector:@selector(compareWithAnotherBrewery:)];
    [self.mainBreweriesTable reloadData];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude), 5*METERS_PER_MILE, 5*METERS_PER_MILE);
    [self.mainMapView setRegion:[self.mainMapView regionThatFits:region] animated:NO];
    
    /*
    for (Brewery *temp in self.breweries) {
        //Pin the location
        [self dropPinAt:temp onMap:self.mainMapView];
    }*/
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    
    //[self getTableData];
}

-(void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered{
    //[self getTableData];
}

/**
 *  Adds a pin to the given map
 */
-(void)dropPinAt:(Brewery *)business onMap:(MKMapView *)currentMap
{
    //Create a location
    CLLocationCoordinate2D businessLocation = CLLocationCoordinate2DMake(business.location.coordinate.latitude, business.location.coordinate.longitude);
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate =  businessLocation;
    point.title = business.name;
    point.subtitle = @"~0 People Nearby";
    [currentMap addAnnotation:point];
    //[self updateCameraOnMap:currentMap];
    
    //Send an event for dropping Pin
    MyAnalytics *temp = [[MyAnalytics alloc] init];
    [temp eventAction:@"Dropped Pin" category:[[self class] description] description:[NSString stringWithFormat:@"%@ was found on the map!", business.name] breweryIden:business.iden beerIden:@"" eventIden:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  Table view delagtes
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.breweries.count == 0 && self.loaded) {
        //NSLog(@"No Breweries found");
        self.noBreweriesFound = YES;
        return 1;
    }
    else {
        self.noBreweriesFound = NO;
        delagate.breweries = self.breweries;
        [tempAlert hide];
        //NSLog(@"Breweries Found: %i", (int)self.breweries.count);
        return self.breweries.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{//NSLog(@"Row Hieght (Home Detail): %.0f", tableView.frame.size.height/4);return tableView.frame.size.height/4;
    return 80;
}

/**
 *  Build the cell (Note that the business labels should be replaced with feedback)
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _mainBreweriesTable = tableView;
    //NSLog(@"Count = %i", (int)self.breweries.count);
    if(!self.noBreweriesFound){
        static NSString *identifier = @"customBreweryCell";
        [tableView registerNib:[UINib nibWithNibName:@"BreweryCell" bundle:nil] forCellReuseIdentifier:identifier];
        
        // Get the cell's root view and set the table's
        // rowHeight to the root cell's height.
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BreweryCell"
                                                     owner:self
                                                   options:nil];
        BreweryCellClass *cell = (BreweryCellClass *)nib[0];
        @try {
            cell.breweryName.text = [(Brewery *)[_breweries objectAtIndex:indexPath.row] name];
            Brewery *temp = (Brewery *)[_breweries objectAtIndex:indexPath.row];
            CLLocationDistance meters = [temp.location distanceFromLocation:locationManager.location];
            cell.distanceLabel.text = [NSString stringWithFormat:@"%.1f", meters/METERS_PER_MILE];
            //NSLog(@"Distance of brewery: %@, %.2f", cell.breweryName.text, meters/METERS_PER_MILE);
            //cell.beersOnCO2.text = [NSString stringWithFormat:@"%i", temp.beersOnCO2];
            //cell.beersOnNitro.text = [NSString stringWithFormat:@"%i", temp.beersOnNitro];
            cell.eventsCount.text = [NSString stringWithFormat:@"%i", temp.eventsCount];
            cell.beersOnCO2.text = [NSString stringWithFormat:@"%i", temp.beerCount];
            
            //Only do next sectionsif not yet completed
            if (temp.profilePicture.description.length == 0){
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    
                    UIImage *pro = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[(Brewery *)[_breweries objectAtIndex:indexPath.row]picURL]]]];
                    [temp setProfilePicture:pro];
                    UIImage *cover = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[(Brewery *)[_breweries objectAtIndex:indexPath.row]coverPicURL]]]];
                    [temp setCoverPhoto:cover];
                    
                    // update UI on the main thread
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.profilePic.image = [(Brewery *)[_breweries objectAtIndex:indexPath.row]profilePicture];
                        cell.loaded = YES;
                        temp.coverPhoto = cover;
                        //[self addView:cover index:(int)indexPath.row];
                    });
                    
                });
            }
            else{
                cell.profilePic.image = [temp profilePicture];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: %@", exception);
        }
        
        //NSLog(@"Current Text: %@ /end text", currentCell.businessTitle.text);
        return cell;
    }
    if(self.noBreweriesFound && self.loaded){
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
            cell.label.text = @"No Breweries Found!";
        }@catch(NSException *e){
            NSLog(@"Exception: %@", e.description);
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.mainView.backgroundColor = cell.backgroundColor;
        return cell;
    }
}

-(void)addView:(UIImage *)cover index:(int)row{
    //Now, add an image to the main scroller
    
    //self.back.frame = CGRectMake(0, self.back.frame.origin.y, self.view.frame.size.width, self.view.frame.size.width*.5);
    self.back.frame = CGRectMake(0, self.back.frame.origin.y + self.back.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height/4);
    mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.back.frame.size.width*.9, self.back.frame.size.height*.95)];
    mainImage.image = cover;
    mainImage.layer.masksToBounds = YES;
    mainImage.contentMode = UIViewContentModeScaleAspectFit;
    mainImage.layer.borderColor = [UIColor whiteColor].CGColor;
    mainImage.layer.borderWidth = 5;
    mainImage.center = CGPointMake(self.back.frame.size.width/2, self.back.frame.size.height/2);
    //mainImage.backgroundColor = [UIColor blueColor];
    
    UIView *tem = [[UIView alloc] initWithFrame:mainImage.frame];
    [self.back addSubview:tem];
    
    //Add shadow to view
    //changed to zero for the new fancy shadow
    CALayer *layer = tem.layer;
    
    layer.shadowOffset = CGSizeZero;
    
    layer.shadowColor = [[UIColor blackColor] CGColor];
    
    //changed for the fancy shadow
    layer.shadowRadius = 1.0f;
    
    layer.shadowOpacity = 0.60f;
    
    //call our new fancy shadow method
    layer.shadowPath = [self fancyShadowForRect:tem.layer.frame];
    
    [self.back addSubview:mainImage];
}

- (CGPathRef)fancyShadowForRect:(CGRect)rect
{
    CGSize size = rect.size;
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    //right
    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(size.width, 0.0f)];
    [path addLineToPoint:CGPointMake(size.width, size.height + 15.0f)];
    
    //curved bottom
    [path addCurveToPoint:CGPointMake(0.0, size.height + 15.0f)
            controlPoint1:CGPointMake(size.width - 15.0f, size.height)
            controlPoint2:CGPointMake(15.0f, size.height)];
    
    [path closePath];
    
    return path.CGPath;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BreweryHomePage *temp = [self.storyboard instantiateViewControllerWithIdentifier:@"Brewery Home Page"];
    temp.title = [(Brewery *)[_breweries objectAtIndex:indexPath.row] name];
    temp.brewery = (Brewery *)[_breweries objectAtIndex:indexPath.row];
    
    //NSLog(@"Brewery Opened: %@", temp.brewery.description);
    
    //Send an event for dropping Pin
    //Google Analytics
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIEventLabel value:@"Home Detail"];
    [tracker allowIDFACollection];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Home Page" action:@"Brewery Selected" label:[NSString stringWithFormat:@"%@ was selected by a user!", temp.brewery.name] value:0] build]];
    
    [self.navigationController pushViewController:temp animated:YES];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
