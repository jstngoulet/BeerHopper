//
//  LikedBeersViewController.m
//  Beer Hopper
//
//  Created by Justin Goulet on 6/24/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "LikedBeersViewController.h"

@interface LikedBeersViewController ()

@end

@implementation LikedBeersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Load beer list
    myData = [[HopperData alloc] init];
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    self.mainTable.allowsSelection = YES;
    self.mainTable.backgroundColor = [UIColor clearColor];
    self.likedBeers = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"likedBeers"]];
    
    //Add the frame for the liked beers image
    float tabbarHeight = self.navigationController.navigationBar.frame.size.height + self.tabBarController.tabBar.frame.size.height;
    noBeersLikedImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, tabbarHeight, self.view.frame.size.width, self.view.frame.size.height - tabbarHeight)];
    noBeersLikedImage.image = [UIImage imageNamed:@"HowToLikeBeers.png"];
    [self.view addSubview:noBeersLikedImage];
    noBeersLikedImage.contentMode = UIViewContentModeScaleAspectFit;
    noBeersLikedImage.hidden = YES;
    noBeersLikedImage.backgroundColor = self.view.backgroundColor;
    noBeersLikedImage.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + tabbarHeight/4);
    
    activity = [[ImageActivityView alloc] init];
    [self.view addSubview:activity];
    activity.tintColor = [UIColor colorWithRed:0.380 green:0.490 blue:0.541 alpha:1.00];
    [activity useImage:[UIImage imageNamed:@"BeerHopperLogo.png"]];
    [activity startAnimating];
    
    [self loadBeerList];
    
    if(self.beerListCount > 0){
        NSLog(@"Beers Found: %i", self.beerListCount);
        [self loadBeersFromList];
    }
    else{
        NSLog(@"No Beers Found!");
        //Display the "Blank view" here
        [activity stopAnimating];
        noBeersLikedImage.hidden = NO;
    }
    
}

//Load the beer list
-(void)loadBeerList{
    self.beerList = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"likedBeers"]];
    self.beerListCount = (int)self.beerList.count;
}


-(void)loadBeersFromList{
    
    //Create the query to get all beers that match the record ID within the beer list
    NSURL *url = [self BeerQuery];
    
    NSURLRequest *res = [NSURLRequest requestWithURL:url];
    NSOperationQueue*que=[NSOperationQueue new];
    
    //NSMutableArray *foundRecords = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reDoBeers) name:@"beersLoaded" object:nil];
    
    [NSURLConnection sendAsynchronousRequest:res queue:que completionHandler:^(NSURLResponse*rep,NSData*data,NSError*err){
        if ([data length]> 0 && err == nil) {
            NSString* rel=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSDictionary* json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:&err];
            int iterator = 0;
            //NSLog(@"Rel: %@", rel);
            //NSLog(@"%@",json[@"records"]);
            if(rel.length > 0){
                //NSLog(@"Records: %@", json);
                [myData createBeersWithDictionary:json[@"records"]];
                /*
                 //Now, filter
                 for (NSDictionary *tem in json[@"records"]) {
                 NSLog(@"tem: %@", tem);
                 
                 }*/
                self.beers = [[NSMutableArray alloc] init];
                
                for(NSDictionary *type in json[@"records"]){
                    
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
                    newBeer.breweryName = [type[@"fields"][@"BreweryName"] objectAtIndex:0];
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
                    iterator++;
                    //if([newBeer.style isEqualToString:@"CO2"]) self.brewery.beersOnCO2++;
                    //else if([newBeer.style isEqualToString:@"Nitro"]) self.brewery.beersOnNitro++;
                    
                    [self.beers addObject:newBeer];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        UIImage *pic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:newBeer.imageURL]]];
                        
                        // update UI on the main thread
                        dispatch_async(dispatch_get_main_queue(), ^{
                            newBeer.image = pic;
                            //NSLog(@"Beers Count: %i", (int)self.beers.count);
                            self.loadedBeerList = YES;
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"beersLoaded" object:self];
                            [self.mainTable performSelectorOnMainThread:@selector(reloadData) withObject:NULL waitUntilDone:NO];
                        });
                        
                    });
                    
                    //Run through the brewery list
                    //NSArray *breweries = type[@"fields"][@"Brewery"];
                    /*
                     for (Brewery *temp in self.breweries) {
                     if ([breweries containsObject:temp.iden]) {
                     [temp.beerList addObject:newBeer];
                     
                     //Check the serving style and add to the total count
                     //if(newBeer.isAvail){
                     if([type[@"fields"][@"Serving Style"] isEqualToString:@"CO2"]) temp.beersOnCO2++;
                     else if([type[@"fields"][@"Serving Style"] isEqualToString:@"Nitro"]) temp.beersOnCO2++;
                     //}
                     //NSLog(@"Should be adding: %@ to %@", newBeer.beerName, temp.name);
                     }
                     //NSLog(@"Brewery: %@", breweries);
                     }*/
                }
                
                
                //[self.beerTable performSelectorOnMainThread:@selector(reloadData) withObject:NULL waitUntilDone:NO];
                
                if (iterator ==0 ) {
                    NSLog(@"No Beers found!");
                }
            }
            else{
                NSLog(@"Error: %@", err.localizedDescription);
            }
        }
    }];

}


-(void)reDoBeers{
    //NSLog(@"Refreshing Beer List");
    [activity stopAnimating];
    [activity removeFromSuperview];
    //self.brewery.beerList = self.beers;
    [self.mainTable reloadData];
}

/**
 *  Filter by formula creation. Note, this is assuming the query already has the initial phrase setup. Tis area will only add the AND or the ORs in the correct order
 */
-(NSString *)compoundFormulaWithSingleOperator:(NSString *)op andBeers:(NSArray *)operations{
    
    //NSLog(@"Creating compound formula with breweries (count): %i", (int)operations.count);
    NSString *query = [NSString stringWithFormat:@"%@(", op];
    
    for (int i = 0; i < operations.count; i++) {
        if(i >= 0 && i < operations.count -1){
            //Middle
            query = [query stringByAppendingString:[NSString stringWithFormat:@"RECORD_ID()=\"%@\",%@(", [operations objectAtIndex:i], op]];
        }
        else{
            query = [query stringByAppendingString:[NSString stringWithFormat:@"RECORD_ID()=\"%@\"", [operations objectAtIndex:i]]];
        }
    }
    
    //Add the remaining parenthesis
    for (int i = 0; i < operations.count; i++) {
        query = [query stringByAppendingString:@")"];
    }
    
    //NSLog(@"Query: %@", query);
    return query;
}

-(NSURL *)BeerQuery{
    
    NSURL *temp;
    NSString *currentQuery = [self compoundFormulaWithSingleOperator:@"OR" andBeers:self.beerList];
    
    /*
     NSLog(@"Beer List");
     for (NSString *temp in self.brewery.beerList) {
     NSLog(@"Beer: %@", temp);
     }*/
    
    temp = [NSURL URLWithString:[[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/Beers?filterByFormula=%@&api_key=keyBAo5QorTmqZmN8", currentQuery] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    // temp = [NSURL URLWithString:[[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/Beers?filterByFormula=Brewery=\"%@\"&api_key=keyBAo5QorTmqZmN8", self.brewery.name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //NSLog(@"URL: %@", temp.absoluteString);
    return temp;
}



-(void)viewDidAppear:(BOOL)animated{
    [self loadBeerList];
    
    if(!self.loadedBeerList || self.beers.count != self.beerList.count){
        [self loadBeersFromList];
    }
    /*
    for (int i = 0; i < self.beerListCount; i++) {
        NSLog(@"BeerList: %@", [self.beerList objectAtIndex:i]);
    }*/
    
    MyAnalytics *temp = [[MyAnalytics alloc] init];
    [temp viewShown:@"Liked Beers Page"];
    
    [self.mainTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.loadedBeerList){
        if(self.beerListCount > 0){
            self.noBeersFound = NO;
            noBeersLikedImage.hidden = YES;
            return self.beers.count;
        }
        else{
            self.noBeersFound = YES;
            [activity stopAnimating];
            noBeersLikedImage.hidden = NO;
            return 1;
        }
    }
    else{
        self.noBeersFound = YES;
        [activity stopAnimating];
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{//NSLog(@"Row Hieght (Home Page): %.0f", tableView.frame.size.height/4);
    //return tableView.frame.size.height/2;
    return 152;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [activity stopAnimating];
    [activity removeFromSuperview];
    
    if(self.noBeersFound){
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
                cell.label.text = @"No Liked Beers Yet!";
            }@catch(NSException *e){
                NSLog(@"Exception: %@", e.description);
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.mainView.backgroundColor = cell.backgroundColor;
            return cell;

    }
    else{
        static NSString *identifier = @"BeerViewCell";
        [tableView registerNib:[UINib nibWithNibName:@"BeerView" bundle:nil] forCellReuseIdentifier:identifier];
        
        // Get the cell's root view and set the table's
        // rowHeight to the root cell's height.
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BeerView"
                                                     owner:self
                                                   options:nil];
        BeerTableViewCell *cell = (BeerTableViewCell *)nib[0];
        
        if(self.loadedBeerList)
            @try {
                cell.thisBeer = (Beer *)[self.beers objectAtIndex:indexPath.row];
                cell.abvLabel.text = [NSString stringWithFormat:@"%.2f%%", cell.thisBeer.ABV];
                cell.ibuLabel.text = (cell.thisBeer.IBU == 0) ? @"N/A" : [NSString stringWithFormat:@"%.0f", cell.thisBeer.IBU];
                cell.likeCountLabel.text = [NSString stringWithFormat:@"%i", cell.thisBeer.votes];
                //cell.likeCountLabel.text = [NSString stringWithFormat:@"%i", (int)indexPath.row];
                cell.beernNameLabel.text = cell.thisBeer.beerName;
                
                //This will change based on the serving style
                cell.servingTypeImage.image = [UIImage imageNamed:@"beer.png"];
                cell.beerImage.image = [UIImage imageWithCGImage:[cell.thisBeer.image CGImage] scale:2.0f orientation:UIImageOrientationUp];
                cell.beerTypeLabel.text = cell.thisBeer.beerType;
                cell.isAvailableLabel.text = (cell.thisBeer.isAvail) ? @"Available" : @"Not Available";
                cell.servingStyle.text = cell.thisBeer.style;
                
                if([self.likedBeers containsObject:cell.thisBeer.iden])[cell setLiked:YES];
                
                if (!cell.lineAdded) {
                    //Adjust the rating label
                    //NSLog(@"Beer Rating: %.2f", cell.thisBeer.rating);
                    UILabel *beerRatingLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.beernNameLabel.frame.origin.x, cell.beernNameLabel.frame.origin.y + cell.beernNameLabel.frame.size.height, cell.beernNameLabel.frame.size.width, cell.beernNameLabel.frame.size.height/7.5)];
                    beerRatingLabel.layer.masksToBounds = YES;
                    beerRatingLabel.layer.cornerRadius = beerRatingLabel.frame.size.height/2;
                    //beerRatingLabel.backgroundColor = [UIColor greenColor];
                    [cell.parentView addSubview:beerRatingLabel];
                    beerRatingLabel.center = CGPointMake(beerRatingLabel.center.x, cell.beernNameLabel.frame.size.height + cell.beernNameLabel.frame.origin.y);
                    
                    //Now, if the beer rating exists
                    if (cell.thisBeer.rating > 0) {
                        [UIView animateWithDuration:5 animations:^{
                            beerRatingLabel.frame = CGRectMake(beerRatingLabel.frame.origin.x, beerRatingLabel.frame.origin.y, (beerRatingLabel.frame.size.width/10) * cell.thisBeer.rating, beerRatingLabel.frame.size.height);}];
                    }
                    else {
                        beerRatingLabel.backgroundColor = [UIColor colorWithRed:0.380 green:0.490 blue:0.541 alpha:1.00];
                    }
                    
                    if(self.view.frame.size.width >= 375){
                        beerRatingLabel.frame = CGRectMake(cell.beernNameLabel.frame.origin.x, beerRatingLabel.frame.origin.y, beerRatingLabel.frame.size.width, beerRatingLabel.frame.size.height);
                    }
                    else{
                        beerRatingLabel.frame = CGRectMake(cell.beernNameLabel.frame.origin.x/2, beerRatingLabel.frame.origin.y, beerRatingLabel.frame.size.width, beerRatingLabel.frame.size.height);
                    }
                    
                    //Now for the colors
                    if (cell.thisBeer.rating > 0 && cell.thisBeer.rating < 5) beerRatingLabel.backgroundColor = [UIColor colorWithRed:0.827 green:0.125 blue:0.114 alpha:1.00];
                    if(cell.thisBeer.rating >= 5 && cell.thisBeer.rating < 7.5)beerRatingLabel.backgroundColor = [UIColor colorWithRed:1.000 green:0.886 blue:0.353 alpha:1.00];
                    if(cell.thisBeer.rating >= 7.5 && cell.thisBeer.rating < 10) beerRatingLabel.backgroundColor = [UIColor colorWithRed:0.482 green:0.765 blue:0.306 alpha:1.00];
                    if(cell.thisBeer.rating == 10 || cell.thisBeer.rating == 0) beerRatingLabel.backgroundColor = [UIColor colorWithRed:0.380 green:0.490 blue:0.541 alpha:1.00];
                    
                    
                    cell.lineAdded = YES;
                    
                    [cell setLiked:YES];
                }
                
                //if([likedBeers containsObject:cell.thisBeer.iden]) [cell setLiked:YES];
                
                if (cell.thisBeer.image.description.length == 0) {
                    cell.beerImage.image = [UIImage imageNamed:@"beer2.png"];
                    //cell.beerImage.image = self..profilePicture;
                }
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
            } @catch (NSException *exception) {
                
            }
        
        //NSLog(@"Beer: %@", [self.brewery.beerList objectAtIndex:indexPath.row]);
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BeerDetailViewController *temp = [self.storyboard instantiateViewControllerWithIdentifier:@"beerDetail"];
    //temp.thisBrewery = self.brewery;
    temp.thisBeer = (Beer *)[self.beers objectAtIndex:indexPath.row];
    temp.title = temp.thisBeer.beerName;
    temp.ratingsEnabled = YES;
    temp.navigationController.toolbar.tintColor = [UIColor whiteColor];
    //NSLog(@"Beer Opened: %@", temp.thisBeer.beerName);
    
    //Send an event for dropping Pin
    //Google Analytics
    /*
     id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
     [tracker set:kGAIEventLabel value:@"Home Detail"];
     [tracker allowIDFACollection];
     [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Home Page" action:@"Brewery Selected" label:[NSString stringWithFormat:@"%@ was selected by a user!", temp.thisbrewery.name] value:0] build]];*/
    
    [self.navigationController pushViewController:temp animated:YES];
}


@end
