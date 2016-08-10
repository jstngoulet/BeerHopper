//
//  BeerTableViewCell.m
//  Beer Hopper
//
//  Created by Justin Goulet on 5/24/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "BeerTableViewCell.h"

@implementation BeerTableViewCell


#define GREEN [UIColor colorWithRed:0.482 green:0.765 blue:0.306 alpha:1.00]
#define GRAY [UIColor colorWithRed:0.380 green:0.490 blue:0.541 alpha:1.00]

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //Make the rating label round
    [self makeRound:self.beerRatingLabel];
    [self makeRound:self.servingTypeImage];
    [self makeRound:self.abvTitle];
    [self makeRound:self.ibuTitle];
    [self makeRound:self.likeBtn];
    [self makeRound:self.infoBtn];
    [self makeRound:self.isAvailTitle];
    [self makeRound:self.co2Title];
    [self makeRound:self.beerTypeTitle];
    
    self.parentView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.parentView.layer.shadowOffset = CGSizeMake(1, 2);
    self.parentView.layer.shadowOpacity = 1;
    self.parentView.layer.shadowRadius = 3;
    
    [self.likeBtn addTarget:self action:@selector(upVoteBeer:) forControlEvents:UIControlEventTouchUpInside];
    [self.infoBtn addTarget:self action:@selector(openBeerInfo) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)makeRound:(UIView *)temp{
    
    temp.layer.masksToBounds = YES;
    temp.layer.cornerRadius = temp.frame.size.height/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

-(void)openBeerInfo{
    NSLog(@"Beer Info tapped");
    MiniDetailView *detail = [[MiniDetailView alloc] initWithFrame:self.window.rootViewController.view.frame];
    detail.mainViewController = self.window.rootViewController;
    detail.primaryImage = self.thisBeer.image;
    detail.inputViewType = @"BeerDetailView";
    
    if (detail.primaryImage.description == 0) {
        detail.primaryImage = [UIImage imageNamed:@"SearchingForBrewery.png"];
    }
    
    [self.window.rootViewController.view addSubview:detail];
    detail.thisBeer = self.thisBeer;
    [detail build];
}

-(IBAction)upVoteBeer:(id)sender{
    //Adds an instace to upvote in DB
    NSLog(@"Upvote Beer Tapped");
    UIButton *buttonTapped = (UIButton * )sender;
    self.likeBtn.enabled = NO;
    
    if(![buttonTapped.backgroundColor isEqual:GREEN]){
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/VoteForBeer?api_key=keyBAo5QorTmqZmN8"]]];
        
        //NSDictionary *credentials = [NSDictionary dictionaryWithObjectsAndKeys:@"email", @"jstngoulet@me.com", @"password", @"password", nil];
        NSString *cred = [NSString stringWithFormat:@"{\"fields\":{\"BeerVoted\":[\"%@\"], \"UserName\":[\"%@\"]}}",  self.thisBeer.iden, [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"][@"id"]];
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
        
        
        //buttonTapped.backgroundColor = GREEN;
        
        
        // Create url connection and fire request
        voteForBeer = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else{
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/VoteForBeer/%@?api_key=keyBAo5QorTmqZmN8", [self responseFromLikingBeerWithID:self.thisBeer.iden]]]];
        
        
        // Specify that it will be a POST request
        request.HTTPMethod = @"DELETE";
        
        // This is how we set header fields
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        //buttonTapped.backgroundColor = GRAY;
        
        // Create url connection and fire request
        downVoteBeer = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        
        NSLog(@"Deleting %@", [self responseFromLikingBeerWithID:self.thisBeer.iden]);
    }
    
}

-(NSString *)responseFromLikingBeerWithID:(NSString *)beerID{
    
    //Load in the current array
    NSMutableArray *likedBeerResponses = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"likedBeerResponses"]];
    
    int count = 0;
    
    //Return the value for key if the beer id is the same
    for(NSDictionary *responses in likedBeerResponses){
        //NSLog(@"Responses: %@", responses);
        if([responses[@"BeerID"] isEqualToString:beerID]){
            return responses[@"ResponseID"];
            //count++;
        }
    }
    NSLog(@"Objects found: %i", count);
    return @"No Contained";
}

-(void)saveLikedBeerResponse:(NSString *)responseID{
    
    //Load in current Dictionary
    NSMutableArray *likedBeerResponses = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"likedBeerResponses"]];
    
    NSDictionary *tep = @{@"BeerID" : self.thisBeer.iden, @"ResponseID": responseID};
    
    //Add a new object
    if(![likedBeerResponses containsObject:tep]) [likedBeerResponses addObject:tep];
    else NSLog(@"Already Liked");
    
    //Save the new array
    [[NSUserDefaults standardUserDefaults] setObject:likedBeerResponses forKey:@"likedBeerResponses"];
    
}

-(void)removeLikedBeerResponse:(NSString *)responseID{
    //Load in current Dictionary
    NSMutableArray *likedBeerResponses = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"likedBeerResponses"]];
    
    NSDictionary *tep = @{@"BeerID" : self.thisBeer.iden, @"ResponseID": responseID};
    
    //remove object
    if([likedBeerResponses containsObject:tep]) [likedBeerResponses removeObject:tep];
    else NSLog(@"Not Liked yet");
    
    //Save the new array
    [[NSUserDefaults standardUserDefaults] setObject:likedBeerResponses forKey:@"likedBeerResponses"];
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
    
    //NSLog(@"Response: %@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    
    if (!localError) {
        
        self.likeBtn.enabled = YES;
        
        if (connection == voteForBeer) {
            //NSLog(@"Connection-Vote4Beer: %@", readJSON);
            if (![readJSON[@"code"] isEqualToString:@"temporarily_unavailable"])
            {
                NSLog(@"Success");
                self.thisBeer.votes = [[readJSON[@"fields"][@"TotalLikes"]  objectAtIndex:0]intValue];
                self.likeCountLabel.text = [NSString stringWithFormat:@"%i", self.thisBeer.votes];
                
                //Add the id to the array
                [self likeBeer];
                
                //Disable the "like Button"
                //self.likeButton.enabled = NO;
                [self setLiked:YES];
                
                NSLog(@"READJSON: %@", readJSON);
                
                //Send an event for liking a beer
                //Google Analytics
                id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                [tracker set:kGAIEventLabel value:@"Beer Liked!"];
                [tracker allowIDFACollection];
                [tracker send:[[GAIDictionaryBuilder createEventWithCategory:self.thisBeer.beerName action:@"Liked Beer" label:[NSString stringWithFormat:@"%@ was liked!", self.thisBeer.beerName] value:0] build]];
                
                [self saveLikedBeerResponse:readJSON[@"fields"][@"Unique_ID"]];
                
                //Set to the numvber of likes
                self.likeCountLabel.text = [NSString stringWithFormat:@"%@", [readJSON[@"fields"][@"TotalLikes"] objectAtIndex:0]];
                self.thisBeer.votes = [self.likeCountLabel.text intValue];
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
                [tracker send:[[GAIDictionaryBuilder createEventWithCategory:self.thisBeer.beerName action:@"Disiked Beer" label:[NSString stringWithFormat:@"%@ was disliked!", self.thisBeer.beerName] value:0] build]];
                
                //Set to the numvber of likes
                self.thisBeer.votes = [self.likeCountLabel.text intValue]-1;
                self.likeCountLabel.text = [NSString stringWithFormat:@"%i",  self.thisBeer.votes];
                
                [self removeLikedBeerResponse:[self responseFromLikingBeerWithID:self.thisBeer.iden]];
            }
            else{
                NSLog(@"Error Disliking beer: %@", self.thisBeer.beerName);
                NSLog(@"%@", readJSON);
                if(readJSON[@"error"]){
                    self.likeCountLabel.text = @"Err";
                }
            }
            
        }
        
        
        //NSLog(@"JSON: %@", readJSON);
    }
    else
        NSLog(@"Error: %@", localError);
    
    //NSLog(@"Final Array: %@", readJSON);
    
}

/**
 *  Likes a beer then saves the id in an array.
 */
-(void)likeBeer{
    NSMutableArray *likedBeers = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"likedBeers"]];
    [likedBeers addObject:self.thisBeer.iden];
    [[NSUserDefaults standardUserDefaults] setObject:[likedBeers copy] forKey:@"likedBeers"];
}

/**
 *  Removes the beer id from teh like array
 */
-(void)dislikeBeer{
    NSMutableArray *likedBeers = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"likedBeers"]];
    [likedBeers removeObject:self.thisBeer.iden];
    [[NSUserDefaults standardUserDefaults] setObject:[likedBeers copy] forKey:@"likedBeers"];
}

-(void)setLiked:(BOOL)value{
    self.likeBtn.backgroundColor = (value) ? GREEN : GRAY;
}


@end
