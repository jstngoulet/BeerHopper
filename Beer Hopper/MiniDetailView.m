//
//  MiniDetailView.m
//  Beer Hopper
//
//  Created by Justin Goulet on 3/12/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "MiniDetailView.h"

@implementation MiniDetailView

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    //Add a background frame with a black alha to block everything behind main view
    self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.backgroundView.backgroundColor = [UIColor blackColor];
    self.backgroundView.alpha = .75;
    [self addSubview:self.backgroundView];
    
    //[self build];
    return self;
    
}

-(void)build{
    
    //Init array
    likedPosts = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"commentedPosts"]];
    
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width*.75, self.frame.size.height*.75)];
    self.mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.mainView];
    self.mainView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    //Add image
    self.mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.mainView.frame.size.width, self.mainView.frame.size.height/4)];
    self.mainImage.image = self.primaryImage;
    [self.mainView addSubview:self.mainImage];
    self.mainImage.layer.masksToBounds = YES;
    [self.mainImage setContentMode:UIViewContentModeScaleAspectFit];
    
    
    //Add the main table
    self.ratingsTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.mainImage.frame.size.height, self.mainView.frame.size.width, self.mainView.frame.size.height - self.mainImage.frame.size.height - self.mainView.frame.size.height/10)];
    [self.mainView addSubview:self.ratingsTable];
    
    //Add an activity indicator
    self.anActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.anActivity.backgroundColor = [UIColor darkGrayColor];
    self.anActivity.center = CGPointMake(self.mainView.frame.size.width/2, self.mainView.frame.size.height/2);
    self.anActivity.layer.masksToBounds = YES;
    self.anActivity.layer.cornerRadius = self.anActivity.frame.size.height/2;
    
    
    if([self.inputViewType isEqualToString:@"RatingsView"]){
        //ADd every rating
        if (self.thisBeer.reviews.count > 0) {
            
            [self.mainView addSubview:self.anActivity];
            [self.anActivity startAnimating];
            
            for (NSString *beerId in self.thisBeer.reviews) {
                
                self.apiInstanceId = beerId;
                //NSLog(@"Runing query for comment");
                
                //Build the comments table
                NSURL*url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/Beers/%@?api_key=keyBAo5QorTmqZmN8", self.apiInstanceId]];
                NSURLRequest *res = [NSURLRequest requestWithURL:url];
                NSOperationQueue*que=[NSOperationQueue new];
                
                [NSURLConnection sendAsynchronousRequest:res queue:que completionHandler:^(NSURLResponse*rep,NSData*data,NSError*err){
                    if ([data length]> 0 && err == nil) {
                        //NSString* rel=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        
                        NSDictionary* json = [NSJSONSerialization
                                              JSONObjectWithData:data
                                              options:kNilOptions
                                              error:&err];
                        
                        
                        //Using the json, parse the comments with the data I need
                        //NSLog(@"Array: %@", json);
                        
                        [self performSelectorOnMainThread:@selector(buildViewForComment:) withObject:json waitUntilDone:YES];
                        
                    }
                    else{
                        NSLog(@"Error: %@", [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:kNilOptions
                                             error:&err]);
                    }
                }];
            }
            
            
        }
        else{
            //No reviews yet
            //Add a blank view
            UILabel *temp = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.mainView.frame.size.width, self.mainView.frame.size.height/10)];
            temp.numberOfLines = 0;
            temp.text = @"No reviews Yet!\nTap below to create one now!";
            [temp sizeToFit];
            temp.center = CGPointMake(self.mainView.frame.size.width/2, temp.frame.size.height/2 + 10);
            temp.textAlignment = NSTextAlignmentCenter;
            [self.ratingsTable addSubview:temp];
        }
    }
    else if ([self.inputViewType isEqualToString:@"BeerDetailView"]){
        //This will show the beer info in a table similar to the brewery info page
        CustomTableView *newTable = [[CustomTableView alloc] initWithFrame:CGRectMake(0, self.mainImage.frame.size.height, self.mainView.frame.size.width, self.mainView.frame.size.height - self.mainImage.frame.size.height - self.mainView.frame.size.height/10)];
        [self.mainView addSubview:newTable];
        //NSLog(@"Beer info: %@", self.thisBeer.beerDescription);
        
        //Add a large number for positive ratings here
        UILabel *votesCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, newTable.frame.size.width/2, newTable.frame.size.height/4)];
        votesCountLabel.textAlignment = NSTextAlignmentCenter;
        votesCountLabel.text = [NSString stringWithFormat:@"+%i", self.thisBeer.votes];
        [votesCountLabel setFont:[UIFont fontWithName:@"Courier" size:72]];
        votesCountLabel.adjustsFontSizeToFitWidth = YES;
        [votesCountLabel sizeToFit];
        [newTable addSubview:votesCountLabel];
        votesCountLabel.center = CGPointMake(newTable.frame.size.width/2, votesCountLabel.frame.size.height/2 + 20);
        
        //Now, adjust the offset for the new label
        newTable.offset += votesCountLabel.frame.size.height + 20;
        
        //Add the sections
        
        //Add info
        if(self.thisBeer.beerName.length > 0) [newTable addRow:@"Name:" info:self.thisBeer.beerName];
        if(self.thisBeer.breweryName.length > 0) [newTable addRow:@"Brewery" info:self.thisBeer.breweryName];
        if(self.thisBeer.servingGlass > 0) [newTable addRow:@"Served As" info:[NSString stringWithFormat:@"%@", self.thisBeer.servingGlass]];
        if(self.thisBeer.ABV > 0) [newTable addRow:@"ABV" info:[NSString stringWithFormat:@"%.2f", self.thisBeer.ABV]];
        if(self.thisBeer.IBU > 0) [newTable addRow:@"IBU" info:[NSString stringWithFormat:@"%.2f", self.thisBeer.IBU]];
        if(self.thisBeer.hopsUsed.count > 0)[newTable addSection:@"Hops Used" info:self.thisBeer.hopsUsed.description];
        if(self.thisBeer.beerDescription.length > 0) [newTable addSection:@"Description:" info:self.thisBeer.beerDescription];
        if(self.thisBeer.fromTheBrewer.length > 0)[newTable addSection:@"From The Brewer:" info:self.thisBeer.fromTheBrewer];
    }
    else{
        //Not yet defined
        NSLog(@"View is not yet defined");
    }
    
    //Add a close button
    self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.mainView.frame.size.height - self.mainView.frame.size.height/10, self.mainView.frame.size.width, self.mainView.frame.size.height/10)];
    self.closeButton.backgroundColor = [UIColor redColor];
    [self.closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [self.mainView addSubview:self.closeButton];
    [self.closeButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)dismissView{
    [self removeFromSuperview];
}

-(void)buildViewForComment:(NSDictionary *)post{
    
    if (self.anActivity.isAnimating) {
        [self.anActivity stopAnimating];
    }
    
    //SLog(@"Post: %@", post);
    
    CommentView *newView = [[CommentView alloc] initWithFrame:CGRectMake(0, offset, self.mainView.frame.size.width, self.ratingsTable.frame.size.height/5)];
    ForumObject *thisPost = [[ForumObject alloc] init];
    
    //NSLog(@"This Post = %@", post);
    thisPost.messageBody = post[@"fields"][@"Message"];
    thisPost.numberOfDislikes = [post[@"fields"][@"Dislikes"]intValue];
    thisPost.numberOfLikes = [post[@"fields"][@"Likes"]intValue];
    thisPost.messageType = post[@"fields"][@"Type"];
    thisPost.iden = post[@"id"];
    thisPost.user = [post[@"fields"][@"UserName"] objectAtIndex:0];
    //NSLog(@"User: %@", thisPost.user);
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    //The Z at the end of your string represents Zulu which is UTC
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    thisPost.messageDate = [dateFormatter dateFromString:post[@"createdTime"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM d, YYYY"];
    thisPost.dateString = [formatter stringFromDate:thisPost.messageDate];
    
    newView.comment = thisPost;
    [newView build];
    
    
    //Check the values of previously voted posts
    for (NSDictionary *temp in likedPosts) {
        //NSLog(@"posts: %@", temp);
        if ([[temp valueForKey:@"messageCommentedOn"] isEqualToString:thisPost.iden]) {
            //NSLog(@"Messgae Found!");
            [newView setLiked:[[temp valueForKey:@"likedMessage"]boolValue]];
            break;
        }
    }
    
    [self.ratingsTable addSubview:newView];
    offset += newView.frame.size.height;
    self.ratingsTable.contentSize = CGSizeMake(self.ratingsTable.frame.size.width, offset);
    
    numberOfComments++;
}

@end
