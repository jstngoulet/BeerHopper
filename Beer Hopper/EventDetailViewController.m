//
//  EventDetailViewController.m
//  Beer Hopper
//
//  Created by Justin Goulet on 1/21/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "EventDetailViewController.h"
#import "BreweryHomePage.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

-(void)viewDidAppear:(BOOL)animated{
    MyAnalytics *temp = [[MyAnalytics alloc] init];
    [temp viewShown:@"Event Detail"];
    [temp eventAction:@"Tapped on an Event" category:[[self class] description] description:[NSString stringWithFormat:@"The User opened the event: %@", self.thisEvent.eventName] breweryIden:self.thisEvent.thisBrewery.iden beerIden:@"" eventIden:self.thisEvent.iden];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    myData = [[HopperData alloc] init];
    
    //Add background view (White)
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, self.tabBarController.tabBar.frame.size.height/2, self.view.frame.size.width - 20, self.view.frame.size.height - 10 - self.tabBarController.tabBar.frame.size.height*2)];
    self.backgroundView.layer.masksToBounds = YES;
    self.backgroundView.layer.cornerRadius = 15;
    self.backgroundView.center = CGPointMake(self.view.center.x, self.view.center.y);
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundView];
    
    //Add the cover photo
    self.breweryCoverPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height/3)];
    self.breweryCoverPhoto.image = self.thisEvent.thisBrewery.coverPhoto;
    self.breweryCoverPhoto.layer.masksToBounds = YES;
    [self.breweryCoverPhoto setContentMode:UIViewContentModeScaleAspectFill];
    [self.backgroundView addSubview:self.breweryCoverPhoto];
    
    //Add the profile photo
    self.breweryProfilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.backgroundView.frame.size.width/5, self.backgroundView.frame.size.width/5)];
    self.breweryProfilePicture.image = self.thisEvent.thisBrewery.profilePicture;
    //self.breweryProfilePicture.layer.masksToBounds = YES;
    self.breweryProfilePicture.center = CGPointMake(self.breweryProfilePicture.center.x, self.breweryProfilePicture.frame.origin.y + self.breweryCoverPhoto.frame.size.height - self.breweryProfilePicture.frame.size.height * 1.5 + self.navigationController.navigationBar.frame.size.height);
    [self.breweryProfilePicture setContentMode:UIViewContentModeScaleAspectFill];
    //self.breweryProfilePicture.layer.cornerRadius = self.breweryProfilePicture.frame.size.height/2;
    [self.backgroundView addSubview:self.breweryProfilePicture];
    
    if(self.breweryCoverPhoto.image.description.length == 0) self.breweryCoverPhoto.image = [UIImage imageNamed:@"SearchingForBrewery.png"];
    
    //Turn the event dictionary into 2 arrays
    keys = [NSArray arrayWithObjects:@"Address", @"Event Name", @"Event Description", @"Event Date", @"Age Range", @"Cover", @"Host Brewery", @"Contact #", nil];
    
    //Add table
    self.background = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.breweryCoverPhoto.frame.origin.y + self.breweryCoverPhoto.frame.size.height, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height - self.breweryCoverPhoto.frame.size.height)];
    [self.backgroundView addSubview:self.background];
    
    //Now, add the response options.
    currentY += 10;
    
    if(![self responded]){ [self addResponseOptions];currentY += self.breweryCoverPhoto.frame.size.height/2;}
    else {currentY = 0; [self.background addSubview:[self addRow:@"You RSVP'd" info:yourResponse]]; };
    
    
    
    NSString *value;
    
    for (int i = 0; i < keys.count; i++) {
        switch (i) {
            case 0:
                value = [NSString stringWithFormat:@"%@\n%@, %@ %@", self.thisEvent.thisBrewery.address1, self.thisEvent.thisBrewery.city, self.thisEvent.thisBrewery.state, self.thisEvent.thisBrewery.zip];
                break;
                
            case 1:
                value = self.thisEvent.eventName;
                break;
                
            case 2: value = @""; break;
                
            case 3:
                value = self.thisEvent.eventDateString;
                break;
                
            case 4:
                value = (self.thisEvent.maxAge) ? [NSString stringWithFormat:@"%i - %i years", self.thisEvent.minAge, self.thisEvent.maxAge] : [NSString stringWithFormat:@"%i+ years", self.thisEvent.minAge];
                break;
                
            case 5:
                value = [NSString stringWithFormat:@"$%@", self.thisEvent.cost];
                break;
                
            case 6:
                value = [NSString stringWithFormat:@"%@", self.thisEvent.thisBrewery.name];
                break;
                
            case 7:
                value = [NSString stringWithFormat:@"%@", self.thisEvent.thisBrewery.phoneNumber];
                break;
                
            default:
                //NSLog(@"Could not locate: %@", [keys objectAtIndex:i]);
                break;
        }
        
        if(value.length > 0) {
            UIView *temp = [self addRow:[keys objectAtIndex:i] info:value];
            if (i == 6) {
                //Add a gesture recognizer to open the brewery page
                temp.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openBreweryPage)];
                tap.numberOfTapsRequired = 1;
                [temp addGestureRecognizer:tap];
                //NSLog(@"Tap Added");
            }
            [self.background addSubview:temp];
        }
    }
    currentY += 20;
    [self addSection:[keys objectAtIndex:2] info:self.thisEvent.eventdDescription];
    if(self.thisEvent.notes.length > 0)[self addSection:@"Notes" info:self.thisEvent.notes];
    
    
    self.background.contentSize = CGSizeMake(self.background.frame.size.width, currentY + 10);
}

-(void)addResponseOptions{
    
    //we are going to consider 3 buttons: going, not going, and mayybe. The two outside buttons will be one color, the inside, another.
    ImageButton *isGoingButton = [self addButton:@"Going" backgroundColor:self.view.backgroundColor];
    isGoingButton.center = CGPointMake(self.background.frame.size.width/5, currentY + isGoingButton.frame.size.height/2);
    isGoingButton.mainImageView.image = [UIImage imageNamed:@"Happy_Face.png"];
    isGoingButton.disabledImage = [UIImage imageNamed:@"Happy_Face_Disabled.png"];
    [self.background addSubview:isGoingButton];
    [isGoingButton.primaryButton addTarget:self action:@selector(submitYESRSVP:) forControlEvents:UIControlEventTouchUpInside];
    
    ImageButton *maybeGoingButton = [self addButton:@"Maybe" backgroundColor:[UIColor clearColor]];
    maybeGoingButton.center = CGPointMake(self.background.frame.size.width/2, isGoingButton.center.y);
    maybeGoingButton.mainImageView.image = [UIImage imageNamed:@"Maybe_Face.png"];
    maybeGoingButton.disabledImage = [UIImage imageNamed:@"Maybe_Face_Disabled.png"];
    [maybeGoingButton.primaryButton addTarget:self action:@selector(submitMAYBERSVP:) forControlEvents:UIControlEventTouchUpInside];
    [self.background addSubview:maybeGoingButton];
    
    ImageButton *notGoingBtn = [self addButton:@"Not Going" backgroundColor:isGoingButton.backgroundColor];
    notGoingBtn.center = CGPointMake(self.background.frame.size.width/5 * 4, maybeGoingButton.center.y);
    notGoingBtn.mainImageView.image = [UIImage imageNamed:@"Sad_Face.png"];
    notGoingBtn.disabledImage = [UIImage imageNamed:@"Sad_Face_Disabled.png"];
    [notGoingBtn.primaryButton addTarget:self action:@selector(submitNORSVP:) forControlEvents:UIControlEventTouchUpInside];
    [self.background addSubview:notGoingBtn];
    
    responseButtons = [NSArray arrayWithObjects:isGoingButton, maybeGoingButton, notGoingBtn, nil];
}

-(IBAction)submitYESRSVP:(id)sender{
    [myData submitEventInvite:self.thisEvent rsvp:@"Going"];
    [self disableAll];
}
-(IBAction)submitMAYBERSVP:(id)sender{
    [myData submitEventInvite:self.thisEvent rsvp:@"Maybe"];
    [self disableAll];
}
-(IBAction)submitNORSVP:(id)sender{
    [myData submitEventInvite:self.thisEvent rsvp:@"Not Going"];
    [self disableAll];
}

-(void)disableAll{
    for (ImageButton *btn in responseButtons) {
        [btn setOperable:NO];
    }
}

-(ImageButton *)addButton:(NSString *)title backgroundColor:(UIColor *)col{
    ImageButton *temp = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, self.background.frame.size.width/3 - 20, self.breweryCoverPhoto.frame.size.height/2)];
    temp.bckView.backgroundColor = [UIColor colorWithRed:0.306 green:0.416 blue:0.471 alpha:1.00];
    temp.mainImageView.backgroundColor = [UIColor colorWithRed:0.306 green:0.416 blue:0.471 alpha:1.00];
    temp.mainImageView.layer.masksToBounds = YES;
    temp.mainImageView.layer.cornerRadius = temp.mainImageView.frame.size.height/2;
    temp.bckView.layer.masksToBounds = YES;
    temp.bckView.layer.cornerRadius = temp.bckView.frame.size.height/2;
    
    if([temp.backgroundColor isEqual:[UIColor clearColor]]){
        temp.layer.borderWidth = 1;
        [temp setTitleColor:self.view.backgroundColor forState:UIControlStateNormal];
    }
    temp.primaryTitle.text = title;
    
    return temp;
}

-(UIView *)addRow:(NSString *)title info:(NSString *)description{
    
    //Create the container view
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, self.backgroundView.frame.size.width, self.background.frame.size.height/5)];
    
    //Now, add the title (1/3 the width)
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, container.frame.size.width/3 - 10, container.frame.size.height - 10)];
    titleLabel.numberOfLines = 0;
    titleLabel.text = title;
    //titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:14];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.textAlignment = NSTextAlignmentRight;
    //titleLabel.backgroundColor = [UIColor blueColor];
    [titleLabel sizeToFit];
    
    //Add the content
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.size.width + 50, 10, container.frame.size.width - titleLabel.frame.size.width - 50, titleLabel.frame.size.height)];
    descriptionLabel.text = description;
    descriptionLabel.textAlignment = NSTextAlignmentLeft;
    //descriptionLabel.font = [UIFont fontWithName:@"Courier" size:14];
    descriptionLabel.font = [UIFont systemFontOfSize:14];
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
    aboutTitle.font = [UIFont boldSystemFontOfSize:16];
    aboutTitle.textColor = [UIColor lightGrayColor];
    [self.background addSubview:aboutTitle];
    
    currentY += aboutTitle.frame.size.height + 5;
    
    //Add the description
    UILabel *aboutText = [[UILabel alloc] initWithFrame:CGRectMake(10, currentY, self.background.frame.size.width - 20, self.background.frame.size.height/5)];
    aboutText.numberOfLines = 0;
    aboutText.text = description;
    aboutText.font = [UIFont systemFontOfSize:14];
    [aboutText sizeToFit];
    aboutText.frame = CGRectMake(10, currentY, self.background.frame.size.width - 20, aboutText.frame.size.height);
    [self.background addSubview:aboutText];
    currentY += aboutText.frame.size.height + 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)openBreweryPage{
    BreweryHomePage *temp = [self.storyboard instantiateViewControllerWithIdentifier:@"Brewery Home Page"];
    temp.title = self.thisEvent.thisBrewery.name;
    temp.brewery = self.thisEvent.thisBrewery;
    //NSLog(@"Tapped");
    [self.navigationController pushViewController:temp animated:YES];
}

-(BOOL)responded{
    
    //Load in the RSVP array
    NSArray *temp = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"rsvp"]];
    
    for(NSDictionary *tempDict in temp){
        //NSLog(@"temp: %@", tempDict);
        if([tempDict[@"id"] isEqualToString:self.thisEvent.iden]){
            yourResponse = tempDict[@"Response"];
            return YES;
        }
        
    }
    
    return NO;
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
