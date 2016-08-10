//
//  BeerView.m
//  Beer Hopper
//
//  Created by Justin Goulet on 1/16/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "BeerView.h"

@implementation BeerView

#define GREEN [UIColor colorWithRed:0.482 green:0.765 blue:0.306 alpha:1.00]
#define GRAY [UIColor colorWithRed:0.380 green:0.490 blue:0.541 alpha:1.00]

-(id)initWithFrame:(CGRect)frame beer:(Beer *)thisBeer{
    self = [super initWithFrame:frame];
    self.currentBeer = thisBeer;
    //self.backgroundColor = [UIColor colorWithRed:0.961 green:0.937 blue:0.843 alpha:1.00];
    //self.layer.borderWidth = 1.f;
    //self.layer.borderColor = [UIColor blackColor].CGColor;
    //self.backgroundColor = [UIColor whiteColor];
    [self build];
    
    
    return self;
}

-(void)build{
    
    //Add the label
    self.beerTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width - 10, self.frame.size.width/5)];
    self.beerTitle.text = self.currentBeer.beerName;
    //self.beerTitle.backgroundColor = [
    self.beerTitle.textColor = [UIColor whiteColor];
    self.beerTitle.shadowColor = [UIColor blackColor];
    self.beerTitle.shadowOffset = CGSizeMake(1, 1);
    //self.beerTitle.numberOfLines = 0;
    self.beerTitle.font = [UIFont fontWithName:@"Copperplate-Bold" size:16];
    //self.beerTitle.backgroundColor = [UIColor darkGrayColor];
    //self.beerTitle.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.beerTitle];
    
    //Buidl the view. we are going to start by adding the imageView
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-5, self.beerTitle.frame.size.height*.85, self.frame.size.width + 10, self.frame.size.height - self.beerTitle.frame.size.height)];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.backgroundColor = [UIColor colorWithRed:0.961 green:0.937 blue:0.843 alpha:1.00];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.imageView.layer.masksToBounds = YES;
    [self insertSubview:self.imageView atIndex:2];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        beer = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.currentBeer.imageURL]]];
        
        // update UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            //If there is not an image, use ours
            if (beer.description.length == 0) {
                beer = [UIImage imageNamed:@"BeerGlassImage.png"];
                self.imageView.backgroundColor = [UIColor whiteColor];
            }
            
            self.imageView.image = beer;
            self.currentBeer.image = beer;
            
           
        });
        
    });
    
    //Add Gradient to the label
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, self.frame.size.width, self.beerTitle.layer.frame.size.height * .85);
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    [self.layer insertSublayer:gradient atIndex:0];
    
    //Add the message board button
    self.commentBoardButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.beerTitle.frame.size.height*1.5, self.beerTitle.frame.size.height*1.5)];
    [self.commentBoardButton setBackgroundImage:[UIImage imageNamed:@"ChatBubble.png"] forState:UIControlStateNormal];
    self.commentBoardButton.backgroundColor = [UIColor colorWithRed:1.000 green:0.886 blue:0.353 alpha:1.00];
    [self addSubview:self.commentBoardButton];
    self.commentBoardButton.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/3 *2.25);
    [self makeViewRound:self.commentBoardButton];
    [self addWhiteLayer:self.commentBoardButton];
    
    //Add the info button
    self.infoButton = [[UIButton alloc] init];
    self.infoButton.frame = CGRectMake(0, 0, self.beerTitle.frame.size.height, self.beerTitle.frame.size.height);
    [self.infoButton setBackgroundImage:[UIImage imageNamed:@"Info.png"] forState:UIControlStateNormal];
    self.infoButton.backgroundColor = [UIColor darkGrayColor];
    self.infoButton.center = CGPointMake(self.commentBoardButton.center.x - self.infoButton.frame.size.width, self.commentBoardButton.center.y + self.infoButton.frame.size.height/2);
    [self makeViewRound:self.infoButton];
    [self addWhiteLayer:self.infoButton];
    [self.infoButton addTarget:self action:@selector(openBeerInfo) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.infoButton];
    
    //Add the like button
    self.likeButton = [[UIButton alloc] initWithFrame:self.infoButton.frame];
    [self.likeButton setBackgroundImage:[UIImage imageNamed:@"ThumbsUp.png"] forState:UIControlStateNormal];
    self.likeButton.backgroundColor = self.infoButton.backgroundColor;
    [self addSubview:self.likeButton];
    self.likeButton.center = CGPointMake(self.commentBoardButton.center.x + self.likeButton.frame.size.width, self.infoButton.center.y);
    [self makeViewRound:self.likeButton];
    [self.likeButton addTarget:self action:@selector(upVoteBeer:) forControlEvents:UIControlEventTouchUpInside];
    [self addWhiteLayer:self.likeButton];
    
    //When the user taps the "comments" button, they are taken to the ratings of that beer
    [self.commentBoardButton addTarget:self action:@selector(openRatings) forControlEvents:UIControlEventTouchUpInside];
    
    self.backgroundColor = GRAY;
    
}

-(void)openRatings{
    //NSLog(@"Beer tapped");
    MiniDetailView *detail = [[MiniDetailView alloc] initWithFrame:self.window.rootViewController.view.frame];
    detail.mainViewController = self.window.rootViewController;
    detail.primaryImage = self.imageView.image;
    detail.inputViewType = @"RatingsView";
    
    if (self.imageView.image.description.length == 0) {
        detail.primaryImage = [UIImage imageNamed:@"SearchingForBrewery.png"];
    }
    
    [self.window.rootViewController.view addSubview:detail];
    detail.thisBeer = self.currentBeer;
    [detail build];
    
    
    MyAnalytics *temp = [[MyAnalytics alloc] init];
    [temp eventAction:@"Opened Beer -Mini- Information Detail" category:[[self class] description] description:@"The User opened the details of a beer image from the main brewery page" breweryIden:@"" beerIden:self.currentBeer.iden eventIden:@""];
    
}

-(void)openBeerInfo{
    NSLog(@"Beer Info tapped");
    MiniDetailView *detail = [[MiniDetailView alloc] initWithFrame:self.window.rootViewController.view.frame];
    detail.mainViewController = self.window.rootViewController;
    detail.primaryImage = self.imageView.image;
    detail.inputViewType = @"BeerDetailView";
    
    if (self.imageView.image.description.length == 0) {
        detail.primaryImage = [UIImage imageNamed:@"SearchingForBrewery.png"];
    }
    
    [self.window.rootViewController.view addSubview:detail];
    detail.thisBeer = self.currentBeer;
    [detail build];
    
    
    MyAnalytics *temp = [[MyAnalytics alloc] init];
    [temp eventAction:@"Opened Beer -Mini- Information Detail" category:[[self class] description] description:@"The User opened the details of a beer image from the main brewery page" breweryIden:@"" beerIden:self.currentBeer.iden eventIden:@""];
}

-(IBAction)upVoteBeer:(id)sender{
    //Adds an instace to upvote in DB
    NSLog(@"Upvote Beer Tapped");
    //UIButton *buttonTapped = (UIButton * )sender;
    /*
    if(![buttonTapped.backgroundColor isEqual:GREEN]){
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/VoteForBeer?api_key=keyBAo5QorTmqZmN8"]]];
        
        //NSDictionary *credentials = [NSDictionary dictionaryWithObjectsAndKeys:@"email", @"jstngoulet@me.com", @"password", @"password", nil];
        NSString *cred = [NSString stringWithFormat:@"{\"fields\":{\"BeerVoted\":[\"%@\"], \"UserName\":\"%@\"}}",  self.currentBeer.iden, [[UIDevice currentDevice] name]];
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
        
        
        buttonTapped.backgroundColor = GREEN;
        [self setLiked:YES];
        
        
        // Create url connection and fire request
        voteForBeer = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else{
        NSLog(@"Deleting");
        
        NSLog(@"Deleting %@", [self responseFromLikingBeerWithID:self.currentBeer.iden]);
        
     
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/VoteForBeer/%@?api_key=keyBAo5QorTmqZmN8", self.currentBeer.iden]]];
        
        [self setLiked:NO];
        
        // Specify that it will be a POST request
        request.HTTPMethod = @"DELETE";
        
        // This is how we set header fields
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        buttonTapped.backgroundColor = GRAY;
        
        // Create url connection and fire request
        downVoteBeer = [[NSURLConnection alloc] initWithRequest:request delegate:self];
     
    }
*/
}

-(void)makeViewRound:(UIView *)view{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = view.frame.size.height/2;
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
    //NSError *localError;
    //NSDictionary *readJSON = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&localError];
    
    //NSLog(@"Response: %@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    NSLog(@"Using Old Method");
    /*if (!localError) {
        if (connection == voteForBeer) {
            //NSLog(@"Connection-Vote4Beer: %@", readJSON);
            if (![readJSON[@"code"] isEqualToString:@"temporarily_unavailable"])
            {
                NSLog(@"Success");
                self.currentBeer.votes = [[readJSON[@"fields"][@"TotalLikes"]  objectAtIndex:0]intValue];
                
                //Add the id to the array
                [self likeBeer];
                
                //Disable the "like Button"
                //self.likeButton.enabled = NO;
                [self setLiked:YES];
                
                //Send an event for liking a beer
                //Google Analytics
                id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                [tracker set:kGAIEventLabel value:@"Beer Liked!"];
                [tracker allowIDFACollection];
                [tracker send:[[GAIDictionaryBuilder createEventWithCategory:self.currentBeer.beerName action:@"Liked Beer" label:[NSString stringWithFormat:@"%@ was liked!", self.currentBeer.beerName] value:0] build]];
                
                //Save the response ID
                [self saveLikedBeerResponse:readJSON[@"id"]];
            }
        }
        else if(connection == downVoteBeer){
            
            if (readJSON[@"deleted"]) {
                //remove from the array
                [self dislikeBeer];
                
                //Change the color
                [self setLiked:NO];
                
                //Send an event for liking a beer
                //Google Analytics
                id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                [tracker set:kGAIEventLabel value:@"Beer Disliked!"];
                [tracker allowIDFACollection];
                [tracker send:[[GAIDictionaryBuilder createEventWithCategory:self.currentBeer.beerName action:@"Disiked Beer" label:[NSString stringWithFormat:@"%@ was disliked!", self.currentBeer.beerName] value:0] build]];
            }
            else{
                NSLog(@"Error Disliking beer: %@", self.currentBeer.beerName);
            }
            
        }
        
        //NSLog(@"JSON: %@", readJSON);
    }
    else
        NSLog(@"Error: %@", localError);*/
    
    //NSLog(@"Final Array: %@", readJSON);
    
}

/**
 *  Likes a beer then saves the id in an array.
 */
-(void)likeBeer{
    NSMutableArray *likedBeers = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"likedBeers"]];
    [likedBeers addObject:self.currentBeer.iden];
    [[NSUserDefaults standardUserDefaults] setObject:[likedBeers copy] forKey:@"likedBeers"];
}

-(NSString *)responseFromLikingBeerWithID:(NSString *)beerID{
    
    //Load in the current array
    NSMutableArray *likedBeerResponses = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"likedBeerResponses"]];
    
    //Return the value for key if the beer id is the same
    for(NSDictionary *responses in likedBeerResponses){
        if([responses[@"BeerID"] isEqualToString:beerID]){
            return responses[@"ResponseID"];
        }
    }
    return @"Not Contained";
}

-(void)saveLikedBeerResponse:(NSString *)responseID{
    
    //Load in current Dictionary
    NSMutableArray *likedBeerResponses = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"likedBeerResponses"]];
    
    NSDictionary *tep = @{@"BeerID" : self.currentBeer.iden, @"ResponseID": responseID};
    
    //Add a new object
    if(![likedBeerResponses containsObject:tep]) [likedBeerResponses addObject:tep];
    else NSLog(@"Already Liked");
    
    //Save the new array
    [[NSUserDefaults standardUserDefaults] setObject:likedBeerResponses forKey:@"likedBeerResponses"];
    
}

-(void)removeLikedBeerResponse:(NSString *)responseID{
    //Load in current Dictionary
    NSMutableArray *likedBeerResponses = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"likedBeerResponses"]];
    
    NSDictionary *tep = @{@"BeerID" : self.currentBeer.iden, @"ResponseID": responseID};
    
    //remove object
    if([likedBeerResponses containsObject:tep]) [likedBeerResponses removeObject:tep];
    else NSLog(@"Not Liked yet");
    
    //Save the new array
    [[NSUserDefaults standardUserDefaults] setObject:likedBeerResponses forKey:@"likedBeerResponses"];
}

/**
 *  Removes the beer id from teh like array
 */
-(void)dislikeBeer{
    NSMutableArray *likedBeers = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"likedBeers"]];
    [likedBeers removeObject:self.currentBeer.iden];
    [[NSUserDefaults standardUserDefaults] setObject:[likedBeers copy] forKey:@"likedBeers"];
}

-(void)setLiked:(BOOL)value{
    NSLog(@"Beer Liked: %i", value);
    self.likeButton.backgroundColor = (value) ? GREEN : GRAY;
}

-(void)addWhiteLayer:(UIView *)view{
    view.layer.borderWidth = 3.f;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
}

@end
