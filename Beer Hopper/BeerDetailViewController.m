//
//  BeerDetailViewController.m
//  Beer Hopper
//
//  Created by Justin Goulet on 6/5/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "BeerDetailViewController.h"
#import "MyAnalytics.h"

@interface BeerDetailViewController ()

@end

@implementation BeerDetailViewController

-(void)viewDidAppear:(BOOL)animated{
    
    MyAnalytics *temp = [[MyAnalytics alloc] init];
    [temp viewShown:@"Beer Details"];
    [temp eventAction:@"Opened Main Beer Information Detail" category:[[self class] description] description:@"The User opened the details of a beer image from the main brewery page" breweryIden:self.thisBrewery.iden beerIden:self.thisBeer.iden eventIden:@""];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
    //Add background view (White)
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, self.tabBarController.tabBar.frame.size.height/2, self.view.frame.size.width - 20, self.view.frame.size.height - 10 - self.tabBarController.tabBar.frame.size.height*2)];
    self.backgroundView.layer.masksToBounds = YES;
    self.backgroundView.layer.cornerRadius = 15;
    self.backgroundView.center = CGPointMake(self.view.center.x, self.view.center.y);
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundView];
    
    //Add the cover photo
    self.breweryCoverPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height/3)];
    //self.breweryCoverPhoto.image = self.thisBrewery.coverPhoto;
    self.breweryCoverPhoto.image = self.thisBeer.image;
    self.breweryCoverPhoto.layer.masksToBounds = YES;
    [self.breweryCoverPhoto setContentMode:UIViewContentModeScaleAspectFit];
    [self.backgroundView addSubview:self.breweryCoverPhoto];
    
    if(self.breweryCoverPhoto.image.description.length == 0 ){
        self.breweryCoverPhoto.image = [UIImage imageNamed:@"Beer_Hopper_Banner.png"];
        self.breweryCoverPhoto.backgroundColor = [UIColor grayColor];
    }
    
    //NSLog(@"Image Info: %@", self.breweryCoverPhoto.image.description);
    //NSLog(@"Image Dimensions: \nHeight: %.0f\nWidth: %.0f", self.breweryCoverPhoto.frame.size.height, self.breweryCoverPhoto.frame.size.width);
    if(self.breweryCoverPhoto.image.description.length == 0) self.breweryCoverPhoto.image = [UIImage imageNamed:@"SearchingForBrewery.png"];
    
    //Add the profile photo
    self.breweryProfilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.backgroundView.frame.size.width/5, self.backgroundView.frame.size.width/5)];
    self.breweryProfilePicture.image = self.thisBrewery.profilePicture;
    //self.breweryProfilePicture.layer.masksToBounds = YES;
    self.breweryProfilePicture.center = CGPointMake(self.breweryProfilePicture.center.x, self.breweryProfilePicture.frame.origin.y + self.breweryCoverPhoto.frame.size.height - self.breweryProfilePicture.frame.size.height * 1.5 + self.navigationController.navigationBar.frame.size.height);
    [self.breweryProfilePicture setContentMode:UIViewContentModeScaleAspectFit];
    //self.breweryProfilePicture.layer.cornerRadius = self.breweryProfilePicture.frame.size.height/2;
    [self.backgroundView addSubview:self.breweryProfilePicture];
    
    //Add table view;
    self.mainBeerTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(10, self.breweryCoverPhoto.frame.size.height + self.breweryCoverPhoto.frame.origin.y, self.backgroundView.frame.size.width - 20, self.backgroundView.frame.size.height - self.breweryCoverPhoto.frame.size.height)];
    self.mainBeerTableView.thisBeer = self.thisBeer;
    self.mainBeerTableView.forWhat = @"Beer";
    self.mainBeerTableView.parentViewController = self;
    [self.backgroundView addSubview:self.mainBeerTableView];
    [self addSectionsToTable];
    
    //myData = [[HopperData alloc] init];
    //[myData getBeersFromBrewery:self.thisBrewery.iden];
    

}

-(void)addSectionsToTable{
    
    //Add a custom rating view within the customtable view. This can be a customized cell as well. - Add a submit button, rating scale, and title
    NSLog(@"Iden: %@", self.thisBeer.iden);
    BOOL rated = [self hasReviewedBeer];
    if(!rated && self.ratingsEnabled)[self.mainBeerTableView addRatingSystemWithScale:NSMakeRange(1, 10) title:@"Rate" helpText:@"Use the slider to adjust the rating. When complete, tap to submit." submissionURl:NULL];
    else if(rated)[self.mainBeerTableView addRow:@"You Rated" info:[NSString stringWithFormat:@"%.1f out of 10", yourRating]];
    
    //Add beer info
    [self.mainBeerTableView addRow:@"Beer Name" info:[NSString stringWithFormat:@"%@", self.thisBeer.beerName]];
    [self.mainBeerTableView addRow:@"Brewery" info:[NSString stringWithFormat:@"%@", (self.thisBrewery.name.length > 0) ? self.thisBrewery.name : self.thisBeer.breweryName]];
    if(self.thisBeer.rating > 0)[self.mainBeerTableView addRow:@"Avg. Rating" info:[NSString stringWithFormat:@"%.2f out of 10", self.thisBeer.rating]];
    [self.mainBeerTableView addRow:@"Likes" info:[NSString stringWithFormat:@"%i", self.thisBeer.votes]];
    if(self.thisBeer.beerType.length > 0)[self.mainBeerTableView addRow:@"Type" info:[NSString stringWithFormat:@"%@", self.thisBeer.beerType]];
    if(self.thisBeer.ABV > 0)[self.mainBeerTableView addRow:@"ABV" info:[NSString stringWithFormat:@"%.2f%%", self.thisBeer.ABV]];
    if(self.thisBeer.IBU > 0)[self.mainBeerTableView addRow:@"IBU's" info:[NSString stringWithFormat:@"%i", (int)self.thisBeer.IBU]];
    if(self.thisBeer.servingGlass.length > 0)[self.mainBeerTableView addRow:@"Served In" info:[NSString stringWithFormat:@"%@", self.thisBeer.servingGlass]];
    if(self.thisBeer.style.length > 0)[self.mainBeerTableView addRow:@"Style" info:[NSString stringWithFormat:@"%@", self.thisBeer.style]];
    [self.mainBeerTableView addRow:@"Is Available" info:(self.thisBeer.isAvail)? @"Yes" : @"No"];
    if(self.thisBeer.awards.length > 0) [self.mainBeerTableView addSection:@"Awards" info:self.thisBeer.awards];
    if(self.thisBeer.beerDescription.length > 0) [self.mainBeerTableView addSection:@"Beer Description" info:self.thisBeer.beerDescription];
    if(self.thisBeer.fromTheBrewer.length > 0) [self.mainBeerTableView addSection:@"From the Brewer" info:self.thisBeer.fromTheBrewer];
    if(self.thisBeer.pairings.length > 0) [self.mainBeerTableView addSection:@"Pairings" info:self.thisBeer.pairings];
    
    activity = [[ImageActivityView alloc] init];
    [self.view addSubview:activity];
    activity.tintColor = [UIColor colorWithRed:0.380 green:0.490 blue:0.541 alpha:1.00];
    [activity useImage:[UIImage imageNamed:@"BeerHopperLogo.png"]];
    [activity startAnimating];
    
    //Now, add all of the beer reviews
    //Add a header label
    [self addReviews];
   
}

-(void)addReviews{
    //Get the reviews
    //This one works
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/Reviews?filterByFormula=Beer=\"%@\"&api_key=keyBAo5QorTmqZmN8", self.thisBeer.beerName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //NSLog(@"Request: %@", url.absoluteString);
    
    NSURLRequest *res = [NSURLRequest requestWithURL:url];
    NSOperationQueue*que=[NSOperationQueue new];
    
    NSMutableArray *foundRecords = [[NSMutableArray alloc] init];
    
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
                
                //Now, filter
                for (NSDictionary *tem in json[@"records"]) {
                    //NSLog(@"tem: %@", tem);
                    ForumObject *tempObject = [[ForumObject alloc] initWithTitle:@"" message:tem[@"fields"][@"Review"] imageAddress:@"" rating:[tem[@"fields"][@"Rating"] doubleValue] dateOfPost:tem[@"createdTime"] messageType:@"BeerReview" likes:0 dislikes:0 user:[tem[@"fields"][@"User Email"] objectAtIndex:0]];
                    /*if([[tem[@"fields"][@"Beer"] objectAtIndex:0] isEqualToString:self.thisBeer.iden])*/[foundRecords addObject:tempObject];
                    iterator++;
                }
                //NSLog(@"Count: %i", iterator);
                
                
                if (iterator ==0 ) {
                    NSLog(@"No Reviews found!");
                    [self performSelectorOnMainThread:@selector(hideActivity) withObject:NULL waitUntilDone:NO];
                }
                else{
                    [self performSelectorOnMainThread:@selector(addRatingsView:) withObject:foundRecords waitUntilDone:NO];
                }
            }
            else{
                NSLog(@"Error: %@", err.localizedDescription);
            }
        }
    }];

}

-(BOOL)hasReviewedBeer{
    
    //Load in the current array
    NSArray *commentArray = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"comments"]];
    
    //Loop through
    for (NSDictionary *temp in commentArray) {
        //NSLog(@"Comment Array: %@", temp);
        if([temp[@"id"] isEqualToString:self.thisBeer.iden]){
            yourRating = [temp[@"Rating"] floatValue];
            return YES;
        }
    }
    
    return NO;
}

-(void)hideActivity{
    [activity stopAnimating];
    [activity removeFromSuperview];
}

-(void)addRatingsView:(NSMutableArray *) foundRecords{
    if(foundRecords.count > 0){
    [self.mainBeerTableView addSection:@"Reviews" info:@""];
    RatingsMasterView *ratingsView = [[RatingsMasterView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2) andPosts:[foundRecords sortedArrayUsingSelector:@selector(sortByDate:)]];
    [self.mainBeerTableView addView:ratingsView];
    [activity stopAnimating];
    [activity removeFromSuperview];
    }
    else{
        //[self.mainBeerTableView addSection:@"Reviews" info:@"No Reviews Yet!\nSubmit one above!"];
    }
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
