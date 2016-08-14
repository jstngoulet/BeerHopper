//
//  MainTutorial.m
//  Beer Hopper
//
//  Created by Justin Goulet on 6/22/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "MainTutorial.h"

@implementation MainTutorial

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    analytics = [[MyAnalytics alloc] init];
    return self;
}

-(void)build{
    
    pageNumber = 1;
    
    //Add each individual view
    SingleTutorialPage *welcome = [self newPageWithType:kViewTypeHeader title:@"" text:@"" buttonText:@"Start"];
    [self addSubview:welcome];
    //welcome.backgroundColor = [UIColor whiteColor];
    
    [analytics viewShown:@"Introduction"];
}

-(void)showLocationRequest{
    
    //NSLog(@"Adding Center");
    SingleTutorialPage *askForLocationServices = [[SingleTutorialPage alloc] initWithFrame:current.frame type:kViewTypeContent];
    askForLocationServices.primaryImage = self.headerImage;
    [self addSubview:askForLocationServices];
    [askForLocationServices build];
    current = askForLocationServices;
    askForLocationServices.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

-(void)animateViewOut:(UIView *)first animateViewIn:(UIView *)second{
    
}

-(void)next{
    
   
    
    pageNumber++;
    NSLog(@"Next tapped: %i", pageNumber);
    SingleTutorialPage *welcome;
    if(pageNumber == 2){
        welcome = [self newPageWithType:kViewTypeContent title:@"Location Services" text:@"We use location services to determine what breweries are near you! The eligible breweries are then sorted by their distance from you.\n\nWithout location services, you will be defaulted to a location on the \n“Hop Highway” in California.\n\nAll location information is anonymous!" buttonText:@"Enable Services"];
        [welcome.nextButton.primaryButton addTarget:self action:@selector(requestLocation) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(pageNumber == 3){
        welcome = [self newPageWithType:kViewTypeContent title:@"Notifications" text:@"We don’t wish to annoy you!\n\nNotifications will be provided\nAT MOST\ntwice a week. This way, you get updates on what is going on near you and you are not bothered by our service." buttonText:@"Notification Settings"];
        [welcome.nextButton.primaryButton addTarget:self action:@selector(requestNotifications) forControlEvents:UIControlEventTouchUpInside];
        
        //Increase the page coun to skip the email step
        pageNumber++;
    }
    else if (pageNumber == 4){
        welcome = [self newPageWithType:kViewTypeTextField title:@"Account Email" text:@"Please input your email to create an account.\n\nWe will never send any unwanted emails! If you recieve any that appear to come from Beer Hopper, please contact us immediately!" buttonText:@"Create"];
        welcome.isAddingEmail = YES;
        welcome.isAddingAlias = NO;
        currentTextField = welcome.mainText;
    }
    else if(pageNumber == 5){
        //SAve the previous tesxt to save as email
        //userEmail = currentTextField.text;
        
        welcome = [self newPageWithType:kViewTypeTextField title:@"Create Alias" text:@"What name do you want to go by in the\nBeer Hopper Community?\n\nPlease create an appropriate name.\nPlease note that if the alias is deemed unappropriate, your alias will be randomly changed for you." buttonText:@"It's Good"];
        welcome.isAddingAlias = YES;
        welcome.isAddingEmail = NO;
        currentTextField = welcome.mainText;
        [welcome.nextButton.primaryButton addTarget:self action:@selector(addUser) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(pageNumber == 6){
        welcome = [self newPageWithType:kViewTypeHeader title:@"" text:@"" buttonText:@"Start Hopping!"];
        [welcome.nextButton.primaryButton addTarget:self action:@selector(disissView) forControlEvents:UIControlEventTouchUpInside];
    }
    welcome.backgroundColor = [UIColor whiteColor];
    [self addSubview:welcome];
    
    [analytics eventAction:@"Selected Next Button" category:@"Introduction" description:welcome.title breweryIden:@"" beerIden:@"" eventIden:@""];
}

-(SingleTutorialPage *)newPageWithType:(NSString *)type title:(NSString *)title text:(NSString *)text buttonText:(NSString *)btnText{
    SingleTutorialPage *temp = [[SingleTutorialPage alloc] initWithFrame:self.frame type:type];
    temp.primaryImage = self.headerImage;
    temp.mainBackgroundColor = self.mainColor;
    
    if(type == kViewTypeContent || type == kViewTypeTextField){
        temp.title = title;
        temp.mainDescription = text;
    }
    [temp build];
    temp.nextButton.primaryTitle.text = btnText;
    
    [temp.nextButton.primaryButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    temp.nextButton.mainImageView.image = [UIImage imageNamed:@"arrow.png"];
    temp.nextButton.mainImageView.contentMode = UIViewContentModeScaleToFill;
    current = temp;
    return temp;
}

-(void)requestLocation{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [self->locationManager requestAlwaysAuthorization];
}

-(void)addUser{
    HopperData *tempData = [(AppDelegate *)[[UIApplication sharedApplication] delegate]myHopperData];
    if(tempData.description.length == 0){
        tempData = [[HopperData alloc] init];
    }
    userEmail = currentTextField.text;
    
    //Now, create a custom email using the alias. We must remove all special characters and replace spaces with a '.'
    // Create character set with specified characters
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet characterSetWithCharactersInString:@",./;'[]!@#$%^&*()-"];
    
    // Build array of components using specified characters as separtors
    NSArray *arrayOfComponents = [userEmail componentsSeparatedByCharactersInSet:characterSet];
    
    // Create string from the array components
    NSString *newEmail = [arrayOfComponents componentsJoinedByString:@""];
    newEmail = [newEmail stringByReplacingOccurrencesOfString:@" " withString:@"."];
    newEmail = [newEmail stringByAppendingString:@"@BeerHopper.com"];
    
    
    [tempData submitNewUserWithEmail:newEmail alias:currentTextField.text];
}

-(void)requestNotifications{
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
}


-(void)disissView{
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] dismissViewControllerAnimated:NO completion:nil];
}
@end
