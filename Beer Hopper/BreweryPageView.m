//
//  BreweryPageView.m
//  Beer Hopper
//
//  Created by Justin Goulet on 1/15/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "BreweryPageView.h"
#import "HopperData.h"
#import "MyAnalytics.h"

@implementation BreweryPageView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    delagate = [[UIApplication sharedApplication] delegate];
    myData = [[HopperData alloc] init];
    
    
    return self;
}

-(void)eventHandler:(NSNotification *)notif{
    [self.beerTable reloadData];
}

-(void)createTable{
    
    MyAnalytics *temp = [[MyAnalytics alloc] init];
    [temp eventAction:@"Home Page Viewed" category:[[self class] description] description:[NSString stringWithFormat:@"%@ was viewed!", self.brewery.name] breweryIden:self.brewery.iden beerIden:@"" eventIden:@""];
    
    self.beerTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2 - self.tempView.tabBarController.tabBar.frame.size.height, self.frame.size.width, self.frame.size.height/2)];
    self.beerTable.contentInset = UIEdgeInsetsMake(-65, 0, 0, 0);
    self.beerTable.delegate = self;
    self.beerTable.dataSource = self;
    //self.beerTable.allowsSelection = NO;
    self.beerTable.backgroundColor = self.backgroundColor;
    self.beerTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.beerTable];
    //NSLog(@"Width: %f", self.frame.size.width);
    [self addView:self.brewery.coverPhoto index:0];
    
    //Adjust the view to fit in the screen
    self.beerTable.frame = CGRectMake(0, mainImage.frame.origin.y*3.5 + mainImage.frame.size.height + self.tempView.navigationController.navigationBar.frame.size.height, self.frame.size.width, self.frame.size.height - mainImage.frame.size.height - mainImage.frame.origin.y*3.5 - self.tempView.tabBarController.tabBar.frame.size.height*2);
    
    likedBeers = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"likedBeers"]];
    //NSLog(@"Liked BEers: %i", (int)likedBeers.count);
    
    if ((self.brewery.beerList.count > 0) && [[self.brewery.beerList objectAtIndex:0] isKindOfClass:[Beer class]]) {
        //NSLog(@"Beer Already");
        self.loadedBeers = YES;
    }
    else{
        activity = [[ImageActivityView alloc] init];
        [self.beerTable addSubview:activity];
        activity.center = CGPointMake(self.beerTable.frame.size.width/2, activity.frame.size.height/2);
        activity.tintColor = [UIColor colorWithRed:0.380 green:0.490 blue:0.541 alpha:1.00];
        [activity useImage:[UIImage imageNamed:@"BeerHopperLogo.png"]];
        [activity startAnimating];
        
        [self getBeers];
        //NSLog(@"Not yet beer");
    }
}

-(void)currentWindow:(UIStoryboard *)wind viewController:(UIViewController *)tempViewController{
    self.tempView = tempViewController;
    self.currentWindow = wind;
}

-(void)getData{
    
    //now, get the beer list
    myData = [[HopperData alloc] init];
    for (Beer *beeriden in self.brewery.beerList) {
        [myData getFromQuery:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/Beers/%@", beeriden.iden]];
    }
}

/*
-(void)build{
    
   
    
    //Add the background color
    self.backgroundColor = [UIColor colorWithRed:0.380 green:0.490 blue:0.541 alpha:1.00];
    
    //Add the cover picture
    self.coverPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2.25)];
    [self addSubview:self.coverPhoto];
    self.coverPhoto.layer.masksToBounds = YES;
    self.coverPhoto.backgroundColor = [UIColor whiteColor];
    if(![self.coverPhoto isEqual:[UIImage imageNamed:@"SearchingForBrewery.png"]]) [self.coverPhoto setContentMode:UIViewContentModeScaleAspectFill];
    
    
    //Add the profile picture
    self.profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.coverPhoto.frame.size.width/3.5, self.coverPhoto.frame.size.width/3.5)];
    
    //Set the profile image to be round
    //self.profileImage.layer.masksToBounds = YES;
    //self.profileImage.backgroundColor = [UIColor colorWithRed:0.961 green:0.937 blue:0.843 alpha:1.00];
    //self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
    //self.profileImage.layer.borderWidth = 3;
    //self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImage.center = CGPointMake(self.frame.size.width/2, self.coverPhoto.frame.size.height/2.25);
    [self.profileImage setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:self.profileImage];
    
    //Set the images if they were already found
    self.profileImage.image = self.brewery.profilePicture;
    self.coverPhoto.image = self.brewery.coverPhoto;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        UIImage *pro = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.brewery.picURL]]];
        UIImage *cover = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.brewery.coverPicURL]]];
        
        // update UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            self.brewery.profilePicture = pro;
            self.brewery.coverPhoto = cover;
            self.profileImage.image = self.brewery.profilePicture;
            self.coverPhoto.image = self.brewery.coverPhoto;
            
            //Aspect fit the cover image
            [self.coverPhoto setContentMode:UIViewContentModeScaleAspectFill];
            
            //Add Gradient to the cover image
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = CGRectMake(0, 0, self.frame.size.width, self.coverPhoto.layer.frame.size.height);
            gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor clearColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
            [self.coverPhoto.layer insertSublayer:gradient atIndex:0];
            self.coverPhoto.backgroundColor = [UIColor colorWithRed:0.961 green:0.937 blue:0.843 alpha:1.00];
        });
        
    });
    
    //Add the call, maps and messageboard buttons
    self.callButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.profileImage.frame.size.width*.75, self.profileImage.frame.size.width*.75)];
    [self.callButton setBackgroundImage:[UIImage imageNamed:@"CallBrewery.png"] forState:UIControlStateNormal];
    self.callButton.center = CGPointMake(self.profileImage.center.x, self.profileImage.center.y + self.profileImage.frame.size.height*1.1);
    [self addSubview:self.callButton];
    
    self.mapsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.callButton.frame.size.width/3 * 2, self.callButton.frame.size.width/3 * 2)];
    [self.mapsButton setBackgroundImage:[UIImage imageNamed:@"OpenInMaps.png"] forState:UIControlStateNormal];
    self.mapsButton.center = CGPointMake(self.callButton.center.x + self.mapsButton.frame.size.width, self.callButton.center.y + self.mapsButton.frame.size.width*.5);
    [self addSubview:self.mapsButton];
    [self.mapsButton addTarget:self action:@selector(openInMaps) forControlEvents:UIControlEventTouchUpInside];
    
    self.breweryQuestionsButton = [[UIButton alloc] initWithFrame:self.mapsButton.frame];
    [self.breweryQuestionsButton setBackgroundImage:[UIImage imageNamed:@"BreweryMessageBoard.png"] forState:UIControlStateNormal];
    self.breweryQuestionsButton.center = CGPointMake(self.callButton.center.x - self.mapsButton.frame.size.width, self.mapsButton.center.y);
    [self addSubview:self.breweryQuestionsButton];
    
    
    //Add the "Beers on tap label
    self.beersOnTapLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.coverPhoto.frame.origin.y + self.coverPhoto.layer.frame.size.height+5, self.frame.size.width * .95, self.callButton.frame.size.height/3)];
    self.beersOnTapLabel.text = @"Beers on Tap:";
    self.beersOnTapLabel.font = [UIFont fontWithName:@"Copperplate" size:18];
    [self.beersOnTapLabel adjustsFontSizeToFitWidth];
    self.beersOnTapLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.beersOnTapLabel];
    //self.beersOnTapLabel.backgroundColor = [UIColor colorWithRed:0.380 green:0.490 blue:0.541 alpha:1.00];
    
    //Add the breweryinfo button
    self.breweryInfoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.breweryInfoButton.tintColor = [UIColor whiteColor];
    self.breweryInfoButton.frame = CGRectMake(self.frame.size.width - self.beersOnTapLabel.frame.size.height*1.25, self.beersOnTapLabel.frame.origin.y, self.beersOnTapLabel.frame.size.height, self.beersOnTapLabel.frame.size.height);
    [self addSubview:self.breweryInfoButton];
    [self.breweryInfoButton addTarget:self action:@selector(getBreweryInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //Add the scroller
    self.beersOnTapScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.beersOnTapLabel.frame.origin.y + self.beersOnTapLabel.frame.size.height, self.frame.size.width, self.frame.size.height - (self.beersOnTapLabel.frame.origin.y + self.beersOnTapLabel.frame.size.height + self.frame.size.height/15))];
    //self.beersOnTapScroller.backgroundColor = [UIColor colorWithRed:0.000 green:0.573 blue:0.757 alpha:1];
    self.beersOnTapScroller.backgroundColor = [UIColor darkGrayColor];
    self.beersOnTapScroller.bounces = NO;
    [self addSubview:self.beersOnTapScroller];
}
*/

-(IBAction)getBreweryInfo:(id)sender{
    BreweryDetailsViewController *temp = [self.currentWindow instantiateViewControllerWithIdentifier:@"Brewery Details"];
    temp.thisBrewery = self.brewery;
    temp.title = [NSString stringWithFormat:@"Details"];
    [self.tempView.navigationController pushViewController:temp animated:YES];
}

-(void)updateToPage{
    //Set the profile image
    self.profileImage.image = self.brewery.profilePicture;
    
    //Set the cover image
    self.coverPhoto.image = self.brewery.coverPhoto;
    
    
    //Build the items within the scroller (The beer views)
    //[self buildTable];
}

-(void)addView:(UIImage *)cover index:(int)row{
    //Now, add an image to the main scroller
    
    //back = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.origin.y + self.tempView.navigationController.navigationBar.frame.size.height*1.5, self.frame.size.width, self.frame.size.width*.5)];
    back = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.origin.y + self.tempView.navigationController.navigationBar.frame.size.height*1.5, self.frame.size.width, self.frame.size.height/4)];
    //back.backgroundColor = [UIColor greenColor];
    mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, back.frame.size.width*.9, back.frame.size.height*.95)];
    mainImage.image = cover;
    mainImage.layer.masksToBounds = YES;
    mainImage.contentMode = UIViewContentModeScaleAspectFill;
    mainImage.layer.borderColor = [UIColor whiteColor].CGColor;
    mainImage.layer.borderWidth = 5;
    mainImage.center = CGPointMake(back.frame.size.width/2, back.frame.size.height/1.75);
    //mainImage.backgroundColor = [UIColor blueColor];
    mainImage.backgroundColor = [UIColor whiteColor];
    
    UIView *tem = [[UIView alloc] initWithFrame:mainImage.frame];
    [back addSubview:tem];
    
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
    
    [back addSubview:mainImage];
    [self addSubview:back];
    
    self.profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainImage.frame.size.width/3.5, mainImage.frame.size.width/3.5)];
    self.profileImage.center = mainImage.center;
    self.profileImage.image = self.brewery.profilePicture;
    [self.profileImage setContentMode:UIViewContentModeScaleAspectFill];
    [back addSubview:self.profileImage];
    
    //Set the images if they were already found
    self.profileImage.image = self.brewery.profilePicture;
    
    //Add buttons
    //Add the call, maps and messageboard buttons
    //float differnce = self.frame.size.height - (mainImage.frame.origin.y + mainImage.frame.size.height) - (self.beerTable.frame.size.height) - self.tempView.navigationController.navigationBar.frame.size.height - self.tempView.tabBarController.tabBar.frame.size.height;
    float thisHeight = mainImage.frame.size.height/4;
    
    //differnce /= 1.25;
    self.callButton = [[UIButton alloc] initWithFrame:CGRectMake(back.frame.size.width/2 - thisHeight/2, mainImage.frame.origin.y + mainImage.frame.size.height, thisHeight, thisHeight)];
    [self.callButton setBackgroundImage:[UIImage imageNamed:@"Phone2.png"] forState:UIControlStateNormal];
    [self.callButton addTarget:self action:@selector(phoneTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addBorder:self.callButton];
    [self makeCircle:self.callButton];
    //self.callButton.center = CGPointMake(mainImage.center.x + mainImage.frame.size.width/2 - self.callButton.frame.size.width/1.5, mainImage.frame.origin.y + self.callButton.frame.size.height);
    self.callButton.backgroundColor = [UIColor colorWithRed:0.380 green:0.490 blue:0.541 alpha:1.00];
    
    [self addSubview:self.callButton];
    
    self.mapsButton = [[UIButton alloc] initWithFrame:self.callButton.frame];
    [self.mapsButton setBackgroundImage:[UIImage imageNamed:@"Map2.png"] forState:UIControlStateNormal];
    //self.mapsButton.center = CGPointMake(self.callButton.center.x, mainImage.frame.size.height/2);
    
    [self.mapsButton addTarget:self action:@selector(openInMaps) forControlEvents:UIControlEventAllTouchEvents];
    [self addSubview:self.mapsButton];
    self.mapsButton.backgroundColor = self.callButton.backgroundColor;
    [self addBorder:self.mapsButton];
    [self makeCircle:self.mapsButton];
    
    self.breweryQuestionsButton = [[UIButton alloc] initWithFrame:self.mapsButton.frame];
    //[self.breweryQuestionsButton setBackgroundImage:[UIImage imageNamed:@"Speech2.png"] forState:UIControlStateNormal];
    //[self.breweryQuestionsButton setBackgroundImage:[UIImage imageNamed:@"favorites-button.png"] forState:UIControlStateNormal];
    [self.breweryQuestionsButton setBackgroundImage:[UIImage imageNamed:@"Info3.png"] forState:UIControlStateNormal];
    [self addSubview:self.breweryQuestionsButton];
    [self addBorder:self.breweryQuestionsButton];
    [self makeCircle:self.breweryQuestionsButton];
    [self.breweryQuestionsButton addTarget:self action:@selector(getBreweryInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    self.breweryQuestionsButton.backgroundColor = self.mapsButton.backgroundColor;
    
    /*
    self.breweryInfoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.breweryQuestionsButton.frame.size.width/1.5, self.breweryQuestionsButton.frame.size.width/1.5)];
    [self.breweryInfoButton setBackgroundImage:[UIImage imageNamed:@"Info.png"] forState:UIControlStateNormal];
    self.breweryInfoButton.backgroundColor = self.callButton.backgroundColor;
    [self makeCircle:self.breweryInfoButton];
    [self.breweryInfoButton addTarget:self action:@selector(getBreweryInfo:) forControlEvents:UIControlEventTouchUpInside];
    [back addSubview:self.breweryInfoButton];
    */
    
    
    /*
    self.mapsButton.center = CGPointMake(mainImage.center.x + mainImage.frame.size.width/2 - self.callButton.frame.size.width/1.5, self.profileImage.center.y);
    self.callButton.center = CGPointMake(self.mapsButton.center.x, self.mapsButton.center.y - self.callButton.frame.size.height*1.25);
    self.breweryQuestionsButton.center = CGPointMake(self.mapsButton.center.x, self.mapsButton.center.y + self.callButton.frame.size.height*1.25);
    self.breweryInfoButton.center = CGPointMake(self.callButton.frame.size.width/1.5 + self.callButton.frame.size.width/2, mainImage.frame.origin.y + mainImage.frame.size.height - self.breweryQuestionsButton.frame.size.height/2 - mainImage.layer.borderWidth);
    */
    
    self.callButton.center = CGPointMake(mainImage.center.x, mainImage.center.y + mainImage.frame.size.height/2 + mainImage.layer.borderWidth);
    self.mapsButton.center = CGPointMake(mainImage.center.x - self.mapsButton.frame.size.width * 1.25, self.callButton.center.y);
    self.breweryQuestionsButton.center = CGPointMake(mainImage.center.x + self.mapsButton.frame.size.width * 1.25, self.mapsButton.center.y);
    self.breweryInfoButton.center = CGPointMake(mainImage.center.x + mainImage.frame.size.width/2 - self.breweryInfoButton.frame.size.width/2 - mainImage.layer.borderWidth, mainImage.frame.origin.y + mainImage.layer.borderWidth + self.breweryInfoButton.frame.size.width/2);
    self.mapsButton.showsTouchWhenHighlighted = YES;
    
    self.callButton.center = CGPointMake(self.frame.size.width/2, back.frame.size.height + back.frame.origin.y);
    self.mapsButton.center = CGPointMake(mainImage.center.x - self.mapsButton.frame.size.width * 1.25, self.callButton.center.y);
    self.breweryQuestionsButton.center = CGPointMake(mainImage.center.x + self.mapsButton.frame.size.width * 1.25, self.mapsButton.center.y);
}

/**
 *  Asks the user if they wish to call the number
 */
-(IBAction)phoneTapped:(id)sender
{
    if (self.brewery.phoneNumber != NULL) {
        //Ask the user if they wish to call phone
        UIAlertView *alertUser = [[UIAlertView alloc] initWithTitle:@"Call" message:[NSString stringWithFormat:@"Would you like to call:\n%@\n\n%@",self.brewery.name, self.brewery.phoneNumber] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Call", nil];
        self.brewery.formattedPhoneNumber = [self.brewery.phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.brewery.formattedPhoneNumber = [self.brewery.formattedPhoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
        self.brewery.formattedPhoneNumber = [self.brewery.formattedPhoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
        self.brewery.formattedPhoneNumber = [self.brewery.formattedPhoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        alertUser.tag = 1;
        [alertUser show];
    }
    else
    {
        //Ask the user if they wish to call phone
        UIAlertView *alertUser = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"No Phone Number Was Found!"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        [alertUser show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            //Cancel
            //[self createCustomAlertNotice:@"Calling Cancelled"];
        }
        else
        {
            // For phone functionality
            //NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", curBusinessData.phoneNumber]];
            NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.brewery.formattedPhoneNumber]];
            
            if([[UIApplication sharedApplication] canOpenURL:telURL])
            {
                [[UIApplication sharedApplication] openURL:telURL];
            }
            else
            {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Notice" message:@"An error occured when placing the call"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
    }
    else
    {
        
    }
}


-(void)makeCircle:(UIView *)temp{
    temp.layer.masksToBounds = YES;
    temp.layer.cornerRadius = temp.frame.size.height/2;
    //temp.layer.borderColor = [UIColor whiteColor].CGColor;
    //temp.layer.borderWidth = temp.frame.size.width/25;
}

-(void)addBorder:(UIView *)temp{
    temp.layer.borderColor = [UIColor whiteColor].CGColor;
    temp.layer.borderWidth = temp.frame.size.width/15;
    /*
    UIView *inte = [[UIView alloc] initWithFrame:temp.frame];
    [back insertSubview:inte belowSubview:temp];
    
    //Add shadow
    inte.layer.shadowColor = [UIColor blackColor].CGColor;
    inte.layer.shadowOffset = CGSizeMake(1, 2);
    inte.layer.shadowOpacity = 1;
    inte.layer.shadowRadius = 3;*/
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


-(void)buildTable{
    /*
     //Create a current beer
     Beer *newBeer = [[Beer alloc] initWithName:@"Dark Cloud" type:2 description:@"Aged to perfection, ready for any dessert time"];
     newBeer.image = [UIImage imageNamed:@"mother-earth-brewing-dark-cloud-dunkel-lager-beer-north-carolina-usa-10571889.jpg"];
     self.beerList = [[NSMutableArray alloc] init];
     
     //Add that same beer in a few times
     for (int i = 0; i < 5; i++) {
     [self.beerList addObject:newBeer];
     }*/
    self.profileImage.image = self.brewery.profilePicture;
    self.coverPhoto.image = self.brewery.coverPhoto;
    
    float xValue = 0, width = self.frame.size.width/2;
    
    //Show the beer list count
    //NSLog(@"Beer List Count: %i", (int)self.brewery.beerList.count);
    int beerUnavailbaleCount = 0;
    int i = 0;
    
    if(self.brewery.beerList.count > 0){
        for (Beer *currentBeer in self.brewery.beerList) {
            
            //Name of the beer
            //NSLog(@"Beer Name: %@, isAvail: %i", currentBeer.beerName, currentBeer.isAvail);
            
            //Create the view
            if (currentBeer.isAvail) {
                BeerView *view = [[BeerView alloc] initWithFrame:CGRectMake(xValue, 0, width, self.beersOnTapScroller.frame.size.height) beer:currentBeer];
                [self.beersOnTapScroller addSubview:view];
                view.mainViewController = self.window.rootViewController;
                xValue += width;
                self.beersOnTapScroller.contentSize = CGSizeMake(xValue, self.beersOnTapScroller.frame.size.height);
                currentBeer.breweryName = self.brewery.name;
                
                //If the beer was liked by me in the past, make it green
                if([likedBeers containsObject:currentBeer.iden]) [view setLiked:YES];
                
                i++;
                
            }
            else beerUnavailbaleCount++;
            
            //NSLog(@"Beers counted: %i\tBeers not avail: %i", i, beerUnavailbaleCount);
        }
    }
    
    if(i==0){
        //Add a label saying that beers have not yet been added
        UILabel *notYetAdded = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.beersOnTapScroller.frame.size.width, self.beersOnTapScroller.frame.size.height)];
        notYetAdded.text = @"No Beers Were Found!\n\nCheck back later to see what comes up!";
        notYetAdded.textColor = [UIColor whiteColor];
        notYetAdded.font = [UIFont fontWithName:@"Courier-Bold" size:24];
        notYetAdded.numberOfLines = 0;
        notYetAdded.textAlignment = NSTextAlignmentCenter;
        [self.beersOnTapScroller addSubview:notYetAdded];
        self.beersOnTapScroller.contentSize = notYetAdded.frame.size;
        notYetAdded.backgroundColor = self.backgroundColor;
    }
    
}


/**
 *  Opens the current location with directions to the business in Maps App
 */
-(void)openInMaps
{
    NSLog(@"Opening in maps");
    NSMutableDictionary *launchOptions = [[NSMutableDictionary alloc] init];
    [launchOptions setObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];
    
    CLLocationCoordinate2D *businessCoordinates = &((CLLocationCoordinate2D){self.brewery.location.coordinate.latitude, self.brewery.location.coordinate.longitude});
    
    MKPlacemark *endLocation = [[MKPlacemark alloc] initWithCoordinate:*businessCoordinates addressDictionary:nil];
    
    MKMapItem *endingItem = [[MKMapItem alloc] initWithPlacemark:endLocation];
    endingItem.name = self.brewery.name;
    endingItem.phoneNumber = self.brewery.phoneNumber;
    
    [endingItem openInMapsWithLaunchOptions:launchOptions];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.loadedBeers){
        if(self.brewery.beerList.count > 0){
            self.noBeersFound = NO;
            return self.brewery.beerList.count;}
        else{
            self.noBeersFound = YES;
            return 0;
        }
    }
    else
        return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{//NSLog(@"Row Hieght (Home Page): %.0f", tableView.frame.size.height/4);
    //return tableView.frame.size.height/2;
    return 152;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.noBeersFound){
        NSLog(@"No Beers Found!");
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
    
    if(self.loadedBeers)
    @try {
        cell.thisBeer = (Beer *)[self.brewery.beerList objectAtIndex:indexPath.row];
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
        
        if (!cell.lineAdded) {
            //NSLog(@"Width: %.2f", self.frame.size.width);
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
            
            if(self.frame.size.width == 375){
                beerRatingLabel.frame = CGRectMake(cell.beernNameLabel.frame.origin.x, beerRatingLabel.frame.origin.y, beerRatingLabel.frame.size.width, beerRatingLabel.frame.size.height);
            }
            else if (self.frame.size.width > 375){
                beerRatingLabel.frame = CGRectMake(cell.beernNameLabel.frame.origin.x*1.5, beerRatingLabel.frame.origin.y, beerRatingLabel.frame.size.width, beerRatingLabel.frame.size.height);
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
        }
        
        if([likedBeers containsObject:cell.thisBeer.iden]) [cell setLiked:YES];
        
        if (cell.thisBeer.image.description.length == 0) {
            cell.beerImage.image = [UIImage imageNamed:@"beer2.png"];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    } @catch (NSException *exception) {
        
    }
    
    //NSLog(@"Beer: %@", [self.brewery.beerList objectAtIndex:indexPath.row]);
    
    return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BeerDetailViewController *temp = [self.tempView.storyboard instantiateViewControllerWithIdentifier:@"beerDetail"];
    temp.thisBrewery = self.brewery;
    temp.thisBeer = (Beer *)[self.brewery.beerList objectAtIndex:indexPath.row];
    temp.title = temp.thisBeer.beerName;
    temp.ratingsEnabled = YES;
    //NSLog(@"Beer Opened: %@", temp.thisBeer.beerName);
    
    //Send an event for dropping Pin
    //Google Analytics
    /*
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIEventLabel value:@"Home Detail"];
    [tracker allowIDFACollection];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Home Page" action:@"Brewery Selected" label:[NSString stringWithFormat:@"%@ was selected by a user!", temp.thisbrewery.name] value:0] build]];*/
    
    [self.tempView.navigationController pushViewController:temp animated:YES];
}

-(NSURL *)BeerQuery{
    
    NSURL *temp;
    NSString *currentQuery = [self compoundFormulaWithSingleOperator:@"OR" andBeers:self.brewery.beerList];
    
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


-(void)getBeers{
    //NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/Beers?filterByFormula(Brewery=\"[%@]\")&api_key=keyBAo5QorTmqZmN8", self.brewery.iden] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //NSLog(@"Request: %@", url.absoluteString);
    //NSLog(@"Adding Beers");
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
                    if([newBeer.style isEqualToString:@"CO2"]) self.brewery.beersOnCO2++;
                    else if([newBeer.style isEqualToString:@"Nitro"]) self.brewery.beersOnNitro++;
                    
                    [self.beers addObject:newBeer];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        UIImage *pic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:newBeer.imageURL]]];
                        
                        // update UI on the main thread
                        dispatch_async(dispatch_get_main_queue(), ^{
                            newBeer.image = pic;
                            //NSLog(@"Beers Count: %i", (int)self.beers.count);
                            self.loadedBeers = YES;
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"beersLoaded" object:self];
                            self.beers = [NSMutableArray arrayWithArray:[self.beers sortedArrayUsingSelector:@selector(compareByName:)]];
                            [self.beerTable performSelectorOnMainThread:@selector(reloadData) withObject:NULL waitUntilDone:NO];
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
    self.brewery.beerList = self.beers;
    [self.beerTable reloadData];
}


@end
