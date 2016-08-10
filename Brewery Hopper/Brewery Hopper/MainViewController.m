//
//  MainViewController.m
//  Brewery Hopper
//
//  Created by Justin Goulet on 5/31/16.
//  Copyright © 2016 Justin Goulet. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Add the breweries view
    self.breweriesView = [[InfoTableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width/3, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height)];
    [self.view addSubview:self.breweriesView];
    self.breweriesView.titleLabel.text = @"My Breweries";
    self.breweriesView.currentType = @"Brewery";
    [self.breweriesView.actionButton setTitle:@"Add Brewery" forState:UIControlStateNormal];
    [self addBreweries];
    //self.breweriesView.backgroundColor = [UIColor redColor];
    
    self.eventsView = [[InfoTableView alloc] initWithFrame:self.breweriesView.frame];
    self.eventsView.center = CGPointMake(self.view.frame.size.width - self.breweriesView.center.x, self.breweriesView.center.y);
    [self.view addSubview:self.eventsView];
    self.eventsView.titleLabel.text = @"My Events";
    self.eventsView.currentType = @"Event";
    [self.eventsView.actionButton setTitle:@"Add Event" forState:UIControlStateNormal];
    [self addEvents];
    
    //Add the final View, which will be the operations/functions
    self.operationsView = [[OperationsView alloc] initWithFrame:self.eventsView.frame];
    //self.operationsView.backgroundColor = [UIColor redColor];
    self.operationsView.center = CGPointMake(self.view.frame.size.width/2, self.eventsView.center.y);
    self.operationsView.titleLabel.text = @"Operations";
    [self.view addSubview:self.operationsView];
}

//For sake of testing
-(void)addBreweries{
    NSLog(@"Adding Breweries");
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/%@?maxRecords=20&view=IsShown&filter(City='Vista')&api_key=keyBAo5QorTmqZmN8", @"Breweries"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *res = [NSURLRequest requestWithURL:url];
    NSOperationQueue*que=[NSOperationQueue new];
    
    [NSURLConnection sendAsynchronousRequest:res queue:que completionHandler:^(NSURLResponse*rep,NSData*data,NSError*err){
        if ([data length]> 0 && err == nil) {
            NSString* rel=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSDictionary* json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:&err];
            //NSLog(@"Rel: %@", rel);
            //NSLog(@"%@",json[@"records"]);
            if(rel.length > 0){
                //Create a brewery
                @try {
                    [self performSelectorOnMainThread:@selector(createBreweriesWithDictionary:) withObject:json[@"records"] waitUntilDone:YES];
                    //[self createBreweriesWithDictionary:json[@"records"]];
                }
                @catch (NSException *exception) {
                    NSLog(@"Error Obtaining Brewery information: \n%@", exception);
                }
            }
        }
    }];
}

-(void)addEvents{
    NSLog(@"Adding Events");
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/%@?view=Future_Events&api_key=keyBAo5QorTmqZmN8", @"Events"]];
    NSURLRequest *res = [NSURLRequest requestWithURL:url];
    NSOperationQueue*que=[NSOperationQueue new];
    
    //NSLog(@"URL Request: %@", url.absoluteString);
    
    [NSURLConnection sendAsynchronousRequest:res queue:que completionHandler:^(NSURLResponse*rep,NSData*data,NSError*err){
        if ([data length]> 0 && err == nil) {
            NSString* rel=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSDictionary* json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:&err];
            //NSLog(@"Rel: %@", rel);
            //NSLog(@"%@",json[@"records"]);
            if(rel.length > 0){
                //Create an event
                [self performSelectorOnMainThread:@selector(createEventsWithDictionary:) withObject:json[@"records"] waitUntilDone:YES];
            }
        }
    }];
}

-(void)createEventsWithDictionary:(NSDictionary *)eventsDict{
    //NSLog(@"Events Dict: %@", eventsDict);
    events = [[NSMutableArray alloc] init];
    [events removeAllObjects];
    []
    
    for(NSDictionary *type in eventsDict){
        Event *newEvent = [[Event alloc] initWithName:type[@"fields"][@"Name"]];
        newEvent.iden = type[@"id"];
        newEvent.eventdDescription = type[@"fields"][@"Event Description"];
        newEvent.eventDateString = type[@"fields"][@"Date Of Event"];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        
        //The Z at the end of your string represents Zulu which is UTC
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        newEvent.eventDate = [dateFormatter dateFromString:newEvent.eventDateString];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMMM d, YYYY '@' hh:mm a"];
        newEvent.eventDateString = [formatter stringFromDate:newEvent.eventDate];
        
        newEvent.minAge = [type[@"fields"][@"Min Age"] intValue];
        newEvent.maxAge = [type[@"fields"][@"Max Age"] intValue];
        newEvent.cost = type[@"fields"][@"Cover"];
        
        //NSLog(@"Beer ID: %@", newBeer.iden);
        [events addObject:newEvent];
        
        //Run through the brewery list
        NSArray *tempbreweries = type[@"fields"][@"Host Brewery"];
        for (Brewery *temp in breweries) {
            if ([tempbreweries containsObject:temp.iden]) {
                [temp.events addObject:newEvent];
                newEvent.thisBrewery = temp;
                newEvent.thisBrewery.eventsCount++;
                //NSLog(@"Should be adding: %@ to %@", newEvent.eventName, temp.name);
            }
            //NSLog(@"Brewery: %@", breweries);
        }
    }
    //Now that I have all of the information, set the values
    
    NSLog(@"Events (count): %i", (int)[events count]);
    self.eventsView.currentInfo = events;
    [self.eventsView.mainTable reloadData];
}

-(void)createBreweriesWithDictionary:(NSDictionary *)breweryDictionary{
    breweries = [[NSMutableArray alloc] init];
    
    NSLog(@"Creating Breweries...");
    for (NSDictionary *type in breweryDictionary) {
        //NSLog(@"%@", type);
        Brewery *newBrewery = [[Brewery alloc] init];
        
        newBrewery.name = type[@"fields"][@"Brewery Name"];
        newBrewery.iden = type[@"id"];
        //NSLog(@"brewery Name: %@", newBrewery.name);
        
        NSDictionary *coverImageURL = type[@"fields"][@"Cover Photo"];
        
        for (NSDictionary *keys in coverImageURL) {
            //NSLog(@"Keys: %@", keys);
            newBrewery.coverPicURL = keys[@"url"];
            //newBrewery.coverPhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:keys[@"url"]]]];
            
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
        CLLocationDistance meters = [newBrewery.location distanceFromLocation:locationManager.location];
        newBrewery.distance = meters*METERS_PER_MILE;
        
        // Add some info
        newBrewery.phoneNumber = type[@"fields"][@"Phone Number"];
        
        newBrewery.address1 = type[@"fields"][@"Street Address"];
        NSArray *cityArray = [NSArray arrayWithArray:type[@"fields"][@"City"]];
        newBrewery.city = cityArray[0];
        newBrewery.state = type[@"fields"][@"State"];
        newBrewery.zip = type[@"fields"][@"Zip Code"];
        
        newBrewery.breweryDescription = type[@"fields"][@"About"];
        newBrewery.notes = type[@"fields"][@"Notes"];
        newBrewery.hours = type[@"fields"][@"Hours"];
        newBrewery.ammenities = type[@"fields"][@"Ammenities"];
        newBrewery.hasFoodNearby = [type[@"fields"][@"Has Food Nearby"] boolValue];
        newBrewery.hasIndoorOutdoorArea = [type[@"fields"][@"Indoor & Outdoor Area"]boolValue];
        newBrewery.website = [NSURL URLWithString:type[@"fields"][@"Website"]];
        newBrewery.numberOfTimesBeforeReview = [type[@"fields"][@"NumberOfVisitsBeforeReview"] intValue];
        
        //NSLog(@"Getting Cover Photo for brewery: %@", newBrewery.name);
        
        if (newBrewery.profilePicture.description.length == 0){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                
                UIImage *pro = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[newBrewery picURL]]]];
                [newBrewery setProfilePicture:pro];
                UIImage *cover = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[newBrewery coverPicURL]]]];
                [newBrewery setCoverPhoto:cover];
                
                
                // update UI on the main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //Send a notification to update data elsewhere
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"coverPhoto" object:self];
                    
                });
                
                
            });
        }
        
        //Add the brewery
        [breweries addObject:newBrewery];
    }
    NSLog(@"Done");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"breweriesAdded" object:self];
    
    NSLog(@"Breweries (count): %i", (int)[breweries count]);
    self.breweriesView.currentInfo = breweries;
    [self.breweriesView.mainTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
