//
//  HopperData.m
//  Beer Hopper
//
//  Created by Justin Goulet on 1/21/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "HopperData.h"
#import "AppDelegate.h"
#import "MyAnalytics.h"

@implementation HopperData

-(id)init{
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager startMonitoringSignificantLocationChanges];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.isNulled = NO;
    //[self.locationManager requestAlwaysAuthorization];
    
    //Send an event for starting to ge data
    
    MyAnalytics *temp = [[MyAnalytics alloc] init];
    [temp eventAction:@"Initialized Data Grasps" category:[[self class] description] description:[NSString stringWithFormat:@"The User: %@ just started a request!", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"][@"id"]] breweryIden:@"" beerIden:@"" eventIden:@""];
    
    
    return self;
}

-(void)nullMyLocation{
    NSLog(@"Locaiton Nulled");
    self.isNulled = YES;
    //[self getFromTable:@"breweries"];
    //[self getEvents];
}

-(void)saveCurrentLocation:(CLLocation *)location{
    
    //If location is not null or zero
    if([location isEqual:NULL] || location.coordinate.latitude == 0){
    //Load in the current array of location data
    NSMutableArray *currentLocationArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"locations"]];
    
    //Create a dictionary with the current location
    NSDictionary *currentLocation = @{@"LocationData":@{
                                              @"Lat" : [NSNumber numberWithFloat:location.coordinate.latitude],
                                              @"Lng" : [NSNumber numberWithFloat:location.coordinate.longitude],
                                              @"Date": [NSDate date]
                                              }
    
                                      };
    
    //Add the object to the array
    [currentLocationArray addObject:currentLocation];
    
    //Save the array
    [[NSUserDefaults standardUserDefaults] setObject:currentLocationArray forKey:@"locations"];
    }
    
}

-(void)saveIdenPosted:(NSString *)postIden toArray:(NSString *)arrayName WithRating:(float) rating{
    
    //Load in the current array of location data
    NSMutableArray *currentLocationArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:arrayName]];
    
    //Create a dictionary with the current location
    NSDictionary *currentLocation = @{@"id" : postIden, @"Rating":[NSNumber numberWithFloat:rating]};
    
    //Add the object to the array
    [currentLocationArray addObject:currentLocation];
    
    //Save the array
    [[NSUserDefaults standardUserDefaults] setObject:currentLocationArray forKey:arrayName];
    
}

-(void)saveIdenRSVP:(NSString *)postIden withResponse:(NSString *)resp{
    
    //Load in the current array of location data
    NSMutableArray *currentLocationArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"rsvp"]];
    
    //Create a dictionary with the current location
    NSDictionary *currentLocation = @{@"id" : postIden, @"Response":resp};
    
    //Add the object to the array
    [currentLocationArray addObject:currentLocation];
    
    //Save the array
    [[NSUserDefaults standardUserDefaults] setObject:currentLocationArray forKey:@"rsvp"];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //NSLog(@"Updating Locations");
    for (CLLocation *temp in locations) {
        [self saveCurrentLocation:temp];
    }
}

-(NSString *)cities{
    //Gets the cities from a saved array and returns as string in format 'city=xxx|city=yyy'
    return @"City='Vista'";
}

-(NSURL *)futureEventsQueryFromExistingBreweries{
    
    NSURL *temp;
    NSString *currentQuery = [self compoundFormulaWithSingleOperator:@"OR" andBreweries:self.breweries];
    
    temp = [NSURL URLWithString:[[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/Events?view=Future_Events&fiterByFormula(%@)&api_key=keyBAo5QorTmqZmN8", currentQuery] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //NSLog(@"URL: %@", temp.absoluteString);
    return temp;
}

/**
 *  Filter by formula creation. Note, this is assuming the query already has the initial phrase setup. Tis area will only add the AND or the ORs in the correct order
 */
-(NSString *)compoundFormulaWithSingleOperator:(NSString *)op andBreweries:(NSArray *)operations{
    
    //NSLog(@"Creating compound formula with breweries (count): %i", (int)operations.count);
    NSString *query = @"";
    
    for (int i = 0; i < operations.count; i++) {
        query = [query stringByAppendingString:[NSString stringWithFormat:@"%@(%@,", op, [(Brewery *)[operations objectAtIndex:i] name]]];
    }
    
    //Add the remaining parenthesis
    for (int i = 0; i < operations.count; i++) {
        query = [query stringByAppendingString:@")"];
    }
    
    //NSLog(@"Query: %@", query);
    return query;
}

-(void)getFromTable:(NSString *)tableName{
    
    NSURL*url;
    if ([tableName isEqualToString:@"breweries"]) {
        
        float myLat = self.locationManager.location.coordinate.latitude;
        float myLong = self.locationManager.location.coordinate.longitude;
        //NSLog(@"My Lat: %f, My Long: %f", myLat, myLong);
        
        NSLog(@"Location: %@", self.locationManager.location);
        
        //If the location is 0, choose a location on the hop highway
        if(self.locationManager.location || [[[NSUserDefaults standardUserDefaults] objectForKey:@"nullMyLocation"]boolValue]){
            NSLog(@"Could not find location because the location services is disabled");
            if(myLat == 0) myLat = 32.81042400;
            if(myLong == 0){
                myLong = -117.14521670; //NSLog(@"Location not found");
                MyAnalytics *temp = [[MyAnalytics alloc] init];
                [temp eventAction:@"Could not locate user" category:[[self class] description] description:[NSString stringWithFormat:@"The User: %@ just started a request!", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"][@"id"]] breweryIden:@"" beerIden:@"" eventIden:@""];
            }
        }
        else{
            NSLog(@"Is not nulled");
            //Add the alert here
            /*if(!aLoaded){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"nullLocation" object:self];
                aLoaded = YES;
            }*/
        }
        
        //NSLog(@"My Lat: %f, Long: %f", myLat, myLong);
        float distance = 0.5f;
        
        //Becasue we want to get all of the breweries within a particular boundary, we need to create a custom request
        //This does not work yet
        url = [NSURL URLWithString:[[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/%@?maxRecords=25&view=IsShown&filterByFormula=AND(Latitude < %f, AND(Latitude > %f, AND(Longitude > %f, AND(Longitude < %f))))&api_key=keyBAo5QorTmqZmN8", tableName, myLat+distance, myLat-distance, myLong-distance, myLong+distance] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        //NSLog(@"RANGE: XCoordinates: %f -> %f, YCoordinates: %f -> %f", myLat - distance, myLat + distance, myLong + distance, myLong - distance);
        
        //This one works
        //url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/%@?maxRecords=20&view=IsShown&api_key=keyBAo5QorTmqZmN8", tableName]];
        //NSLog(@"BRewery URL: %@", url.absoluteString);
    }
    else if([tableName isEqualToString:@"messages"]){
        /*url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/Messages?maxRecords=3&view=Topics&api_key=keyBAo5QorTmqZmN8"]];*/
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/Topics?view=Main&api_key=keyBAo5QorTmqZmN8"]];
    }
    else if([tableName isEqualToString:@"events"]){
        NSLog(@"No longer using this event method");
        //Create a query such that we only locate the future events at the breweries shown
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/%@?view=Future_Events&api_key=keyBAo5QorTmqZmN8", tableName]];
    }
    else {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/%@?api_key=keyBAo5QorTmqZmN8", tableName]];
    }
    
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
            //Create a brewery
            if ([tableName isEqualToString:@"breweries"]) {
               // NSLog(@"Found BReweries: %@", json[@"records"]);
                @try {
                    //NSLog(@"REsults: %@", json[@"records"]);
                    [self performSelectorOnMainThread:@selector(createBreweriesWithDictionary:) withObject:json[@"records"] waitUntilDone:YES];
                    //[self createBreweriesWithDictionary:json[@"records"]];
                }
                @catch (NSException *exception) {
                    NSLog(@"Error Obtaining Brewery information: \n%@", exception);
                }
            }
            else if ([tableName isEqualToString:@"Beers"]){
                @try {
                    [self performSelectorOnMainThread:@selector(createBeersWithDictionary:) withObject:json[@"records"] waitUntilDone:YES];
                    //NSLog(@"Request: %@", url.absoluteString);
                    NSLog(@"Old Method for beers");
                    //[self createBeersWithDictionary:json[@"records"]];
                }
                @catch (NSException *exception) {
                    NSLog(@"Error Obtaining Beer information: \n%@", exception);
                }
            }
            else if ([tableName isEqualToString:@"events"]){
                @try {
                    NSLog(@"No longer using this method for events;");
                    [self performSelectorOnMainThread:@selector(createEventsWithDictionary:) withObject:json[@"records"] waitUntilDone:YES];
                    //[self createBeersWithDictionary:json[@"records"]];
                }
                @catch (NSException *exception) {
                    NSLog(@"Error Obtaining Event information: \n%@", exception);
                }
            }
            else if([tableName isEqualToString:@"messages"]){
                //NSLog(@"Result: %@", json);
                @try {
                    [self performSelectorOnMainThread:@selector(createMessagesWithDictionary:) withObject:json[@"records"] waitUntilDone:YES];
                    //[self createBeersWithDictionary:json[@"records"]];
                }
                @catch (NSException *exception) {
                    NSLog(@"Error Obtaining Brewery information: \n%@", exception);
                }
            }
            }
            else {
                
            }
            
        }
        else{
            NSLog(@"Data is Null");
            if(err) NSLog(@"Error: %@", err.localizedDescription);
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"NullData-%@", tableName] object:self];
        }
        if (err) {
            NSLog(@"Error Found: %@", err.localizedDescription);
        }
    }
     ];
    
}




-(void)getEvents{
    
    //NSLog(@"Using new method");
    //Create the query first
    //Use the existing breweries
    
    //Make sure that the results only contain future events
    NSURL *url = [self futureEventsQueryFromExistingBreweries];
    
    //Create Request
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
                //Create events
                [self performSelectorOnMainThread:@selector(createEventsWithDictionary:) withObject:json[@"records"] waitUntilDone:YES];
            }
        }
    }];
    
}

-(void)getFromQuery:(NSString *)query
{
    NSURL*url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&api_key=keyBAo5QorTmqZmN8", query]];
    NSURLRequest *res = [NSURLRequest requestWithURL:url];
    NSOperationQueue*que=[NSOperationQueue new];
    
    [NSURLConnection sendAsynchronousRequest:res queue:que completionHandler:^(NSURLResponse*rep,NSData*data,NSError*err){
        if ([data length]> 0 && err == nil) {
            //NSString* rel=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSDictionary* json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:&err];
            NSLog(@"%@",json[@"records"]);
            
        }else{
            NSLog(@"Data is Null");
        }
        
    }
     ];
    
}

-(void)createBeersWithDictionary:(NSDictionary *)beersDict{
    //NSLog(@"Beers Dict: %@", beersDict);
    self.beers = [[NSMutableArray alloc] init];
    
    for(NSDictionary *type in beersDict){
        
        //NSLog(@"Beer Found: %@", type[@"fields"]);
        
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
        newBeer.style = type[@"fields"][@"ServingStyle"];
        newBeer.rating = [type[@"fields"][@"Average Rating"] floatValue];
        newBeer.pairings = type[@"fields"][@"Pairings"];
        newBeer.awards = type[@"fields"][@"Awards"];
        //NSLog(@"New Beer Name: %@", newBeer.beerName);
        
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
                [self.beers addObject:newBeer];
                //NSLog(@"Beers Count: %i", (int)self.beers.count);
            });
            
        });
        
        //Run through the brewery list
        /*
        NSArray *breweries = type[@"fields"][@"Brewery"];
        for (Brewery *temp in self.breweries) {
            if ([breweries containsObject:temp.iden]) {
                [temp.beerList addObject:newBeer];
                NSLog(@"type: %@", type);
                //Check the serving style and add to the total count
                //if(newBeer.isAvail){
                if([type[@"fields"][@"ServingStyle"] isEqualToString:@"CO2"]) temp.beersOnCO2++;
                else if([type[@"fields"][@"ServingStyle"] isEqualToString:@"Nitro"]) temp.beersOnCO2++;
                //}
                //NSLog(@"Should be adding: %@ to %@", newBeer.beerName, temp.name);
            }
            //NSLog(@"Brewery: %@", breweries);
        }*/
    }
    
    //NSLog(@"Breweries (count): %i", (int)[self.breweries count]);
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    del.breweries = self.breweries;
}

-(void)updateIdens{
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for(Brewery *a in del.breweries) [temp addObject:a.iden];
    del.breweryIdens = [temp copy];
}

-(Beer *)beerForID:(NSString *)ident{
    
    for (Beer *tmep in self.beers) {
        if ([ident isEqualToString:tmep.iden]) {
            return tmep;
        }
    }
    return NULL;
}

-(Brewery *)breweryFoID:(NSString *)ident{
    for (Brewery *tmep in self.breweries) {
        if ([ident isEqualToString:tmep.iden]) {
            return tmep;
        }
    }
    return NULL;
}

-(void)createBreweriesWithDictionary:(NSDictionary *)breweryDictionary{
    _breweries = [[NSMutableArray alloc] init];
    
    //NSLog(@"Creating Breweries...");
    for (NSDictionary *type in breweryDictionary) {
        //NSLog(@"%@", type);
        Brewery *newBrewery = [[Brewery alloc] init];
        
        newBrewery.name = type[@"fields"][@"Brewery Name"];
        newBrewery.iden = type[@"id"];
        //NSLog(@"brewery Name: %@", newBrewery.name);
        newBrewery.beerList = type[@"fields"][@"Beer List"];
        newBrewery.beerCount = [type[@"fields"][@"Beer Count"] intValue];
        
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
        CLLocationDistance meters = [newBrewery.location distanceFromLocation:self.locationManager.location];
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
        [self.breweries addObject:newBrewery];
        
    }
    NSLog(@"Done. Brewery Count: %i", (int)self.breweries.count);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"breweriesAdded" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addEventsNow" object:self];
    
    //NSLog(@"Breweries (count): %i", (int)[self.breweries count]);
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    del.breweries = [self.breweries sortedArrayUsingSelector:@selector(compareWithAnotherBrewery:)];
    del.breweries = [[del.breweries reverseObjectEnumerator] allObjects];
    self.breweries = [NSMutableArray arrayWithArray:del.breweries];
    //self.breweries = [NSMutableArray arrayWithArray:[self.breweries sortedArrayUsingSelector:@selector(compareWithAnotherBrewery:)]];
    
    [self updateIdens];
    //NSLog(@"Breweries Found: %i", (int) del.breweries.count);
}

-(void)createEventsWithDictionary:(NSDictionary *)eventsDict{
    //NSLog(@"Events Dict: %@", eventsDict);
    self.events = [[NSMutableArray alloc] init];
    [self.events removeAllObjects];
    
    for(NSDictionary *type in eventsDict){
        Event *newEvent = [[Event alloc] initWithName:type[@"fields"][@"Name"]];
        newEvent.iden = type[@"id"];
        newEvent.eventdDescription = type[@"fields"][@"Event Description"];
        newEvent.eventDateString = type[@"fields"][@"Date Of Event"];
        newEvent.notes = type[@"fields"][@"Notes"];
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
        [self.events addObject:newEvent];
        
        //Run through the brewery list
        NSArray *breweries = type[@"fields"][@"Host Brewery"];
        for (Brewery *temp in self.breweries) {
            if ([breweries containsObject:temp.iden]) {
                [temp.events addObject:newEvent];
                newEvent.thisBrewery = temp;
                newEvent.thisBrewery.eventsCount++;
                //NSLog(@"Should be adding: %@ to %@", newEvent.eventName, temp.name);
            }
            //NSLog(@"Brewery: %@", breweries);
        }
    }
    //Now that I have all of the information, set the values
    
    //NSLog(@"Breweries (count): %i", (int)[self.breweries count]);
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    del.breweries = self.breweries;
    
}

-(void)createMessagesWithDictionary:(NSDictionary *)messagesDictionary{
    self.forumPosts = [[NSMutableArray alloc] init];
    
    //NSLog(@"Dictionary: %@", messagesDictionary);
    
    for(NSDictionary *type in messagesDictionary){
        
        ForumObject *post = [[ForumObject alloc] init];
        post.messageBody = type[@"fields"][@"Message"];
        post.iden = type[@"id"];
        post.titleOfPost = type[@"fields"][@"Title"];
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        
        //The Z at the end of your string represents Zulu which is UTC
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        post.messageDate = [dateFormatter dateFromString:type[@"createdTime"]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMMM d, YYYY"];
        post.dateString = [formatter stringFromDate:post.messageDate];
        
        post.rating = [type[@"fields"][@"Rating"] intValue];
        post.messageType = type[@"fields"][@"Type"];
        post.numberOfLikes = [type[@"fields"][@"TotalLikes"] intValue];
        post.numberOfDislikes = [type[@"fields"][@"TotalDislikes"] intValue];
        
        //Add the comments
        //NSLog(@"Comments: %@", type[@"fields"]);
        post.comments = [NSArray arrayWithArray:type[@"fields"][@"Comments"]];
        if([[NSArray arrayWithArray:type[@"fields"][@"UserName"]]count]> 0)
            post.user = [[NSArray arrayWithArray:type[@"fields"][@"UserName"]] objectAtIndex:0];
        post.numberOfComments = (int)post.comments.count;
        
        //NSLog(@"Beer ID: %@", newBeer.iden);
        [self.forumPosts addObject:post];
        
        //Run through the brewery list
        /*
         NSArray *breweries = type[@"fields"][@"Host Brewery"];
         for (Brewery *temp in self.breweries) {
         if ([breweries containsObject:temp.iden]) {
         [temp.events addObject:newEvent];
         newEvent.thisBrewery = temp;
         //NSLog(@"Should be adding: %@ to %@", newEvent.eventName, temp.name);
         }
         //NSLog(@"Brewery: %@", breweries);
         }*/
    }
    //Now that I have all of the information, set the values
    
    //NSLog(@"Breweries (count): %i", (int)[self.breweries count]);
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    del.breweries = self.breweries;
}

//Now for some reviews
-(void)submitReviewForBeer:(Beer *)aBeer rating:(float)ratingValue ratingMessage:(NSString *)message
{
    thisBeer = aBeer;
    
    if (message.length == 0) {
        message = @"";
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/Reviews?api_key=keyBAo5QorTmqZmN8"]]];
    
    //NSDictionary *credentials = [NSDictionary dictionaryWithObjectsAndKeys:@"email", @"jstngoulet@me.com", @"password", @"password", nil];
    NSString *cred = [NSString stringWithFormat:@"{\"fields\":{\"User\":[\"%@\"], \"Rating\":%f, \"Review\":\"%@\", \"Beer\":[\"%@\"]}}",  [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"][@"id"], ratingValue, message, aBeer.iden];
    NSLog(@"Curl Request: %@", request.URL.absoluteString);
    NSLog(@"Credentials: %@", cred);
    
    //NSDictionary *toUpdate = @{@"fields":@{@"Dislikes":[NSNumber numberWithInt:self.comment.numberOfDislikes]}};
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSString *stringData = cred.description;
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    
    // Create url connection and fire request
    postBeerReview = [[NSURLConnection alloc] initWithRequest:request delegate:self];

}

-(void)submitReviewForBrewery:(Brewery *)aBrewery rating:(float)ratingValue ratingMessage:(NSString *)message
{
    thisBrewery = aBrewery;
    
    if (message.length == 0) {
        message = @"";
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/Reviews?api_key=keyBAo5QorTmqZmN8"]]];
    
    //NSDictionary *credentials = [NSDictionary dictionaryWithObjectsAndKeys:@"email", @"jstngoulet@me.com", @"password", @"password", nil];
    NSString *cred = [NSString stringWithFormat:@"{\"fields\":{\"User\":[\"%@\"], \"Rating\":%f, \"Review\":\"%@\", \"Brewery\":[\"%@\"]}}",  [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"][@"id"], ratingValue, message, aBrewery.iden];
    //NSLog(@"Credentials: %@", cred);
    
    //NSDictionary *toUpdate = @{@"fields":@{@"Dislikes":[NSNumber numberWithInt:self.comment.numberOfDislikes]}};
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSString *stringData = cred.description;
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    
    // Create url connection and fire request
    postBreweryReview = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

-(void)submitNewTopic:(ForumObject *)message event:(Event *)anEvent{
    
    thisForumPost = message;
    
    if (message.titleOfPost.length == 0) {
        message.titleOfPost = @"Misc. Topics";
    }
    if(message.messageBody.length == 0){
        message.messageBody = @"No Message Body";
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/Topics?api_key=keyBAo5QorTmqZmN8"]]];
    
    //NSDictionary *credentials = [NSDictionary dictionaryWithObjectsAndKeys:@"email", @"jstngoulet@me.com", @"password", @"password", nil];
    //\"User\":\"%@\",
    NSString *cred;
    if(anEvent.description.length > 0){
        NSLog(@"Event Found");
        cred = [NSString stringWithFormat:@"{\"fields\":{\"User\":[\"%@\"], \"Title\":\"%@\", \"Message\":\"%@\", \"Event\":[\"%@\"]}}", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"][@"id"], message.titleOfPost, message.messageBody, anEvent.iden];
    }
    else{
        NSLog(@"No Event Found");
        cred = [NSString stringWithFormat:@"{\"fields\":{\"User\":[\"%@\"], \"Title\":\"%@\", \"Message\":\"%@\"}}",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"][@"id"], message.titleOfPost, message.messageBody];
    }
    //NSLog(@"Credentials: %@", cred);
    
    //NSDictionary *toUpdate = @{@"fields":@{@"Dislikes":[NSNumber numberWithInt:self.comment.numberOfDislikes]}};
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSString *stringData = cred.description;
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    
    // Create url connection and fire request
    postTopic = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)submitNewComment:(NSString *)message Topic:(ForumObject *)topic{
    thisForumPost = topic;
    
    if(message.length == 0){
        message = @"No Message Body";
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/Messages?api_key=keyBAo5QorTmqZmN8"]]];
    
    //NSDictionary *credentials = [NSDictionary dictionaryWithObjectsAndKeys:@"email", @"jstngoulet@me.com", @"password", @"password", nil];
    //\"User\":\"%@\",
    NSString *cred = [NSString stringWithFormat:@"{\"fields\":{\"User\":[\"%@\"], \"Message\":\"%@\", \"Topics\":[\"%@\"]}}",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"][@"id"], message, topic.iden]; //Add user
    //NSLog(@"Credentials: %@", cred);
    
    //NSDictionary *toUpdate = @{@"fields":@{@"Dislikes":[NSNumber numberWithInt:self.comment.numberOfDislikes]}};
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSString *stringData = cred.description;
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    
    // Create url connection and fire request
    postComment = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (NSString *)newUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

-(void)submitEventInvite:(Event *)anEvent rsvp:(NSString *)response{
    
    thisEvent = anEvent;
    
    if (response.length == 0) {
        response = @"";
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/EventInvite?api_key=keyBAo5QorTmqZmN8"]]];
    
    //NSDictionary *credentials = [NSDictionary dictionaryWithObjectsAndKeys:@"email", @"jstngoulet@me.com", @"password", @"password", nil];
    NSString *cred = [NSString stringWithFormat:@"{\"fields\":{\"User Email\":\"%@\", \"Response\":\"%@\", \"EventResponded\":[\"%@\"]}}",  [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"][@"fields"][@"Email"], response, anEvent.iden];
    //NSLog(@"Credentials: %@", cred);
    
    //NSDictionary *toUpdate = @{@"fields":@{@"Dislikes":[NSNumber numberWithInt:self.comment.numberOfDislikes]}};
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSString *stringData = cred.description;
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    
    // Create url connection and fire request
    postEventInviteResult = [[NSURLConnection alloc] initWithRequest:request delegate:self];

}


-(void)submitNewUserWithEmail:(NSString *)email alias:(NSString *) alias{
    //NSLog(@"Attempting to submit new user");
    
    NSString *userName = [self newUUID];
    if(![email containsString:@"@"]){
        //Add it to the end
        email = [email stringByAppendingString:@"@beerhopper.com"];
    }
    if (alias.length == 0) {
        alias = @"Guest Taster";
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/User?api_key=keyBAo5QorTmqZmN8"]]];
    
    //NSDictionary *credentials = [NSDictionary dictionaryWithObjectsAndKeys:@"email", @"jstngoulet@me.com", @"password", @"password", nil];
    NSString *cred = [NSString stringWithFormat:@"{\"fields\":{\"UserName\":\"%@\", \"Email\":\"%@\", \"Alias\":\"%@\"}}",  userName, email, alias];
    //NSLog(@"Credentials: %@", cred);
    
    //NSDictionary *toUpdate = @{@"fields":@{@"Dislikes":[NSNumber numberWithInt:self.comment.numberOfDislikes]}};
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSString *stringData = cred.description;
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    
    // Create url connection and fire request
    postUser = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}


//Delagate stuff
#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
    //NSLog(@"Data: %@", self.responseData);
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}
- (void) connection:(NSURLConnection *) connection didFailWithError:(NSError *)error {
    NSLog(@"Failed with error: %@", error.localizedDescription);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSError *localError;
    NSDictionary *readJSON = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&localError];
    
    NSLog(@"Response: %@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    
    if (!localError) {
        if (connection == postBeerReview) {
            //NSLog(@"Connection-Vote4Beer: %@", readJSON);
            if (![readJSON[@"code"] isEqualToString:@"temporarily_unavailable"])
            {
                //NSLog(@"Success: %@", readJSON);
                @try {
                    thisBeer.rating = [[readJSON[@"fields"][@"Average_Beer_Rating"] objectAtIndex:0] doubleValue];
                    [self saveIdenPosted:[readJSON[@"fields"][@"Beer"] objectAtIndex:0] toArray:@"comments" WithRating:[readJSON[@"fields"][@"Rating"]floatValue]];
                } @catch (NSException *exception) {
                    NSLog(@"Exception: %@", readJSON);
                }
                
            }
        }
        else if(connection == postEventInviteResult){
            if (![readJSON[@"code"] isEqualToString:@"temporarily_unavailable"])
            {
                //NSLog(@"Successfully rsvp:%@", readJSON);
                [self saveIdenRSVP:thisEvent.iden withResponse:readJSON[@"fields"][@"Response"]];
            }
        }
        else if (connection == getBeer){
            NSLog(@"Got beers: %@", readJSON);
        }
        else if (connection == postBreweryReview){
            NSLog(@"Success on Brewery");
            if([readJSON[@"fields"][@"Average_Beer_Rating"] count] > 0)thisBrewery.rating = [[readJSON[@"fields"][@"Average_Beer_Rating"] objectAtIndex:0] doubleValue];
        }
        else if (connection == postTopic){
            NSLog(@"Topic Posted");
            if(![readJSON[@"Error"] isEqual:NULL])[self saveIdenPosted:readJSON[@"id"] toArray:@"comments" WithRating:0];
        }
        else if (connection == postComment){
            NSLog(@"Comment Posted: %@", readJSON);
            if(![readJSON[@"Error"] isEqual:NULL])[self saveIdenPosted:readJSON[@"id"] toArray:@"comments" WithRating:0];
        }
        else if (connection == postUser){
            NSLog(@"User Submitted: %@", readJSON);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userCreated" object:self];
            [[NSUserDefaults standardUserDefaults] setObject:readJSON forKey:@"currentUser"];
        }
        else{
            NSLog(@"JSON: %@", readJSON);
        }
        
        //NSLog(@"JSON: %@", readJSON);
    }
    else
        NSLog(@"Error: %@", localError);
    
    //NSLog(@"Final Array: %@", readJSON);
    
}


@end
