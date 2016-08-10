//
//  BreweryDetailsViewController.m
//  Beer Hopper
//
//  Created by Justin Goulet on 1/31/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "BreweryDetailsViewController.h"

@interface BreweryDetailsViewController ()

@end

@implementation BreweryDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Add background view (White)
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, self.tabBarController.tabBar.frame.size.height/2, self.view.frame.size.width - 20, self.view.frame.size.height - 10 - self.tabBarController.tabBar.frame.size.height*2)];
    self.backgroundView.layer.masksToBounds = YES;
    self.backgroundView.layer.cornerRadius = 15;
    self.backgroundView.center = CGPointMake(self.view.center.x, self.view.center.y);
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundView];
    
    //Add the cover photo
    self.breweryCoverPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height/3)];
    self.breweryCoverPhoto.image = self.thisBrewery.coverPhoto;
    self.breweryCoverPhoto.layer.masksToBounds = YES;
    [self.breweryCoverPhoto setContentMode:UIViewContentModeScaleAspectFill];
    [self.backgroundView addSubview:self.breweryCoverPhoto];
    
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
    
    //Get the current website
    self.currentSite = self.thisBrewery.website;
    
    //Now, add a customized table that will show the details of the brewery
    [self addInfoTable];
}

-(void)addInfoTable{
    
    newTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(0, self.breweryCoverPhoto.frame.origin.y + self.breweryCoverPhoto.frame.size.height, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height - (self.breweryCoverPhoto.frame.origin.y + self.breweryCoverPhoto.frame.size.height))];
    newTableView.forWhat = @"Brewery";
    newTableView.thisBrewery = self.thisBrewery;
    newTableView.parentViewController = self;
    [self.backgroundView addSubview:newTableView];
    
    int numberOfVisits = [self numberOfTimesVisted];
    //NSLog(@"Visits Required: %i", self.thisBrewery.numberOfTimesBeforeReview);
    
    if(numberOfVisits >= self.thisBrewery.numberOfTimesBeforeReview)[newTableView addRatingSystemWithScale:NSMakeRange(1, 10) title:@"Rate Brewery" helpText:@"Rate the Brewery by slideing the scale to the left and right! When you are satisfied with your response, submit it or add a comment!" submissionURl:NULL];
    else{
        int difference = self.thisBrewery.numberOfTimesBeforeReview - numberOfVisits;
        [newTableView addSection:@"In Order To Review:" info:[NSString stringWithFormat:@"To review, you must visit this brewery %i more time%@ seperated by at least 12 hours.", difference, (difference == 1)?@"":@"s"]];
    }
    
    [newTableView addRow:@"Visits:" info:[NSString stringWithFormat:@"%i", numberOfVisits]];
    if(![self.thisBrewery.phoneNumber isEqual:NULL])[newTableView addRow:@"Phone #:" info:self.thisBrewery.phoneNumber];
    if(![self.thisBrewery.address1 isEqual:NULL])[newTableView addRow:@"Address: " info:[NSString stringWithFormat:@"%@\n%@, %@ %@", self.thisBrewery.address1, self.thisBrewery.city, self.thisBrewery.state, self.thisBrewery.zip]];
    //[newTableView addRow:@"In/Out\nSeating:" info:(!self.thisBrewery.hasIndoorOutdoorArea) ? @"No" : @"Yes"];
    [newTableView addRow:@"Seating:" info:(!self.thisBrewery.hasIndoorOutdoorArea) ? @"No" : @"Yes"];
    [newTableView addRow:@"Nearby Grub:" info:(!self.thisBrewery.hasFoodNearby) ? @"No" : @"Yes"];
    [newTableView addRow:@"Food Onsite:" info:(!self.thisBrewery.servesFood) ? @"No" : @"Yes"];
    //newTableView.offset += 20;
    if (self.thisBrewery.ammenities.length != 0) [newTableView addSection:@"Ammenities" info:self.thisBrewery.ammenities];
    if (![self.thisBrewery.hours isEqual:NULL]) [newTableView addSection:@"Hours" info:self.thisBrewery.hours];
    if (![self.thisBrewery.breweryDescription isEqual:NULL]) [newTableView addSection:@"About" info:self.thisBrewery.breweryDescription];
    if (self.thisBrewery.notes.length > 0) [newTableView addSection:@"Notes" info:self.thisBrewery.notes];
    if (self.currentSite.description.length != 0) [newTableView addButton:@"Website" target:@selector(goToWebsite)];
    newTableView.currentSite = self.currentSite;
    
    [self addReviews];
    
    NSLog(@"Location: Lat: %f, Lng: %f", self.thisBrewery.location.coordinate.latitude, self.thisBrewery.location.coordinate.longitude);
    
}

-(int)numberOfTimesVisted{
    int number = 0, iterator = 0;
    
    //Load location array
    NSArray *locationData = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"locations"]];
    NSDate *firstDate;
    BOOL counted = NO;
    float timeInterval;
    
    //Read each value
    for (NSDictionary *tempDict in locationData) {
        //If the lat is the same
        //NSLog(@"Number: %i", number);
        
        if([tempDict[@"LocationData"][@"Lat"]floatValue] == self.thisBrewery.location.coordinate.latitude &&
           [tempDict[@"LocationData"][@"Lng"]floatValue] == self.thisBrewery.location.coordinate.longitude){
            //NSLog(@"Found Time! %@", tempDict);
            if(!counted) {number++; counted = YES;}
            
            //Determine if the visits were more than 12 hours apart
            if(iterator == 0){ firstDate = tempDict[@"LocationData"][@"Date"];}
            else{
                //NSLog(@"First Date: %@", firstDate);
                timeInterval = [firstDate timeIntervalSinceDate:tempDict[@"LocationData"][@"Date"]];
                //NSLog(@"Time since last visit: %f", timeInterval);
                
                //Compare the first date with the second date
                if(timeInterval < -(3600 * 12)){
                    //Show the difference numerically
                    NSLog(@"Been a 12 hour period since: %f", timeInterval);
                    number++;
                }
                firstDate = tempDict[@"LocationData"][@"Date"];
                
            }
            
        }
        iterator++;
    }
    
    
    return number;
}

-(void)goToWebsite{
    //Open website in safari
    [[UIApplication sharedApplication] openURL:self.currentSite];
    
}
-(void)addReviews{
    //Get the reviews
    //This one works
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/Reviews?filterByFormula=Brewery=\"%@\"&api_key=keyBAo5QorTmqZmN8", self.thisBrewery.name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
                    NSLog(@"tem: %@", tem);
                    ForumObject *tempObject = [[ForumObject alloc] initWithTitle:@"" message:tem[@"fields"][@"Review"] imageAddress:@"" rating:[tem[@"fields"][@"Rating"] doubleValue] dateOfPost:tem[@"createdTime"] messageType:@"BreweryReview" likes:0 dislikes:0 user:[tem[@"fields"][@"User Email"] objectAtIndex:0]];
                    NSLog(@"User Name: %@", [tem[@"fields"][@"User Email"] objectAtIndex:0]);
                    /*if([[tem[@"fields"][@"Beer"] objectAtIndex:0] isEqualToString:self.thisBeer.iden])*/
                    [foundRecords addObject:tempObject];
                    iterator++;
                }
                //NSLog(@"Count: %i", iterator);
                
                [self performSelectorOnMainThread:@selector(addRatingsView:) withObject:foundRecords waitUntilDone:NO];
                
                if (iterator ==0 ) {
                    NSLog(@"No Reviews found!");
                    [self performSelectorOnMainThread:@selector(hideActivity) withObject:NULL waitUntilDone:NO];
                }
            }
            else{
                NSLog(@"Error: %@", err.localizedDescription);
            }
        }
    }];
    
}
-(void)hideActivity{
    [activity stopAnimating];
    [activity removeFromSuperview];
}

-(void)addRatingsView:(NSMutableArray *) foundRecords{
    if(foundRecords.count > 0){
        [newTableView addSection:@"Reviews" info:@""];
        RatingsMasterView *ratingsView = [[RatingsMasterView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2) andPosts:[foundRecords sortedArrayUsingSelector:@selector(sortByDate:)]];
        [newTableView addView:ratingsView];
        [activity stopAnimating];
        [activity removeFromSuperview];
    }
    else{
        //[newTableView addSection:@"Reviews" info:@"No Reviews Yet!\nSubmit one above!"];
    }
}



/*
-(UIView *)addRow:(NSString *)title info:(NSString *)description{
    
    //Create the container view
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, self.backgroundView.frame.size.width, self.background.frame.size.height/5)];
    
    //Now, add the title (1/3 the width)
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, container.frame.size.width/3 - 10, container.frame.size.height - 10)];
    titleLabel.numberOfLines = 0;
    titleLabel.text = title;
    titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:14];
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.textAlignment = NSTextAlignmentRight;
    //titleLabel.backgroundColor = [UIColor blueColor];
    [titleLabel sizeToFit];
    
    //Add the content
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.size.width + 50, 10, container.frame.size.width - titleLabel.frame.size.width - 50, titleLabel.frame.size.height)];
    descriptionLabel.text = description;
    descriptionLabel.textAlignment = NSTextAlignmentLeft;
    descriptionLabel.font = [UIFont fontWithName:@"Courier" size:14];
    [descriptionLabel adjustsFontSizeToFitWidth];
    descriptionLabel.numberOfLines = 0;
    [descriptionLabel sizeToFit];
    //descriptionLabel.backgroundColor = [UIColor redColor];
    
    //Set the title label to be the same height as the description
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, descriptionLabel.frame.origin.y, container.frame.size.width/3 - 10, (descriptionLabel.frame.size.height >= titleLabel.frame.size.height) ? descriptionLabel.frame.size.height + 10 : titleLabel.frame.size.height + 10);
    descriptionLabel.frame = CGRectMake(titleLabel.frame.origin.x*4 + titleLabel.frame.size.width, descriptionLabel.frame.origin.y, descriptionLabel.frame.size.width, descriptionLabel.frame.size.height);
    
    [container addSubview:titleLabel];
    [container addSubview:descriptionLabel];
    
    container.frame = CGRectMake(0, currentY, self.backgroundView.frame.size.width, (descriptionLabel.frame.size.height >= titleLabel.frame.size.height) ? descriptionLabel.frame.size.height + 5 : titleLabel.frame.size.height + 5);
    
    //Adjust the center of the description label if the title is larger
    if ((descriptionLabel.frame.size.height <= titleLabel.frame.size.height)) {
        descriptionLabel.center = CGPointMake(descriptionLabel.center.x, titleLabel.center.y);
    }
    
    currentY += container.frame.size.height;
    
    return container;
    
}

-(void)addSection:(NSString *)text info:(NSString *)description{
    
    //Add a line to seperate
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(5, currentY, self.view.frame.size.width, 2)];
    line.backgroundColor = [UIColor blackColor];
    line.layer.masksToBounds = YES;
    line.layer.cornerRadius = line.frame.size.height/2;
    line.center = CGPointMake(self.backgroundView.frame.size.width/2, line.center.y);
    [self.background addSubview:line];
    
    currentY += 5;
    
    //Add an about section with a header and cell instead of other methods
    UILabel *aboutTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, currentY, self.background.frame.size.width - 20, 20)];
    aboutTitle.text = text;
    aboutTitle.font = [UIFont fontWithName:@"Courier-Bold" size:14];
    aboutTitle.textColor = [UIColor lightGrayColor];
    [self.background addSubview:aboutTitle];
    
    currentY += aboutTitle.frame.size.height + 5;
    
    //Add the description
    UILabel *aboutText = [[UILabel alloc] initWithFrame:CGRectMake(10, currentY, self.background.frame.size.width - 20, self.background.frame.size.height/5)];
    aboutText.numberOfLines = 0;
    aboutText.text = description;
    aboutText.font = [UIFont fontWithName:@"Courier" size:14];
    [aboutText sizeToFit];
    aboutText.frame = CGRectMake(10, currentY, self.background.frame.size.width - 20, aboutText.frame.size.height);
    [self.background addSubview:aboutText];
    currentY += aboutText.frame.size.height + 10;
}

-(void)addButton:(NSString *)title target:(SEL)selector{
    //Adds a button
    UIButton *temp = [[UIButton alloc] initWithFrame:CGRectMake(10, currentY, self.background.frame.size.width - 20, self.tabBarController.tabBar.frame.size.height)];
    temp.backgroundColor = self.view.backgroundColor;
    temp.layer.masksToBounds = YES;
    temp.layer.cornerRadius = temp.frame.size.height/2;
    [temp setTitle:title forState:UIControlStateNormal];
    [temp.titleLabel setFont:[UIFont fontWithName:@"Courier-Bold" size:18]];
    [temp addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.background addSubview:temp];
    currentY += temp.frame.size.height + 10;
}
 */

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
