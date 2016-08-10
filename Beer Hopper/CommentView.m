//
//  CommentView.m
//  Beer Hopper
//
//  Created by Justin Goulet on 3/5/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "CommentView.h"

@implementation CommentView

#define mainColor [UIColor colorWithRed:0.306 green:0.416 blue:0.471 alpha:1.00]

-(id)initWithFrame:(CGRect)frame{
    
    //Becuase the size changes anyway, we are just using the size as a relative point
    self = [super initWithFrame:frame];
    
    return self;
}

-(void)build{
    
    //Add the title
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, self.frame.size.width - 30, 50)];
    messageLabel.numberOfLines = 0;
    messageLabel.text = self.comment.messageBody;
    messageLabel.font = [UIFont systemFontOfSize:16];
    [messageLabel sizeToFit];
    //messageLabel.backgroundColor = [UIColor redColor];
    messageLabel.frame = CGRectMake(15, 20, self.frame.size.width-30, messageLabel.frame.size.height);
    messageLabel.center = CGPointMake(self.frame.size.width/2, messageLabel.center.y);
    messageLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:messageLabel];
    
    //Add a like button
    likeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [likeButton setBackgroundImage:[UIImage imageNamed:@"ThumbsUp.png"] forState:UIControlStateNormal];
    likeButton.backgroundColor = mainColor;
    likeButton.layer.masksToBounds = YES;
    likeButton.layer.cornerRadius = likeButton.frame.size.height/2;
    //likeButton.center = CGPointMake(self.frame.size.width/3, (messageLabel.frame.size.height + 5) + likeButton.frame.size.height/1.5);
    likeButton.center = CGPointMake(likeButton.frame.size.width, (messageLabel.frame.size.height + messageLabel.frame.origin.y) + likeButton.frame.size.height/1.5);
    [self addSubview:likeButton];
    likeButton.showsTouchWhenHighlighted = YES;
    [likeButton addTarget:self action:@selector(likePost) forControlEvents:UIControlEventTouchUpInside];
    
    //Add the count for the likes
    likeCount = [[UILabel alloc] initWithFrame:CGRectMake(likeButton.frame.origin.x + likeButton.frame.size.width*2, 0, 15, likeButton.frame.size.height)];
    likeCount.numberOfLines = 1;
    likeCount.font = [UIFont systemFontOfSize:15];
    likeCount.text = [NSString stringWithFormat:@"%i", self.comment.numberOfLikes];
    [likeCount sizeToFit];
    likeCount.center = CGPointMake(likeButton.center.x + likeButton.frame.size.width/1.5 + likeCount.frame.size.width/2, likeButton.center.y);
    [self addSubview:likeCount];
    //likeCount.backgroundColor = [UIColor blueColor];
    
    //Add a dislike button
    dislikeButton = [[UIButton alloc] initWithFrame:likeButton.frame];
    [dislikeButton setImage:[UIImage imageNamed:@"ThumbsUp.png"] forState:UIControlStateNormal];
    dislikeButton.backgroundColor = mainColor;
    dislikeButton.transform = CGAffineTransformMakeRotation(3.14);
    dislikeButton.layer.masksToBounds = YES;
    dislikeButton.layer.cornerRadius = likeButton.frame.size.height/2;
    //dislikeButton.center = CGPointMake(self.frame.size.width/3 * 2, likeButton.center.y);
    dislikeButton.center = CGPointMake(likeButton.center.x, (likeButton.center.y) + likeButton.frame.size.height*1.5);
    [self addSubview:dislikeButton];
    [dislikeButton addTarget:self action:@selector(dislikePost) forControlEvents:UIControlEventTouchUpInside];
    dislikeButton.showsTouchWhenHighlighted = YES;
    
    //Add the count for the dislikes
    dislikeCount = [[UILabel alloc] initWithFrame:likeCount.frame];
    dislikeCount.numberOfLines = 1;
    dislikeCount.font = likeCount.font;
    dislikeCount.text = [NSString stringWithFormat:@"%i", self.comment.numberOfDislikes];
    [dislikeCount sizeToFit];
    dislikeCount.center = CGPointMake(likeButton.center.x + likeButton.frame.size.width/1.5 + dislikeCount.frame.size.width/2, dislikeButton.center.y);
    [self addSubview:dislikeCount];
    //dislikeCount.backgroundColor = [UIColor blueColor];
    
    //Add a date label
    UILabel*datePostedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height/2)];
    datePostedLabel.text = [self formatDate:self.comment.messageDate];
    //datePostedLabel.text = @"Date it was posted";
    [datePostedLabel sizeToFit];
    [self addSubview:datePostedLabel];
    datePostedLabel.font = [UIFont boldSystemFontOfSize:12];
    
    
    //Adjust the centers to match new format
    //The format is: dislikecountamount - dislike button; likebutton - likecount
    //note that this is all on the same row
    //Keep the y value the same as the like buton
    [self adjustCenters];
    
    //Adjust frame size to hold everything
    //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, dislikeButton.center.y + (dislikeButton.frame.size.height*.85));
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, dislikeButton.center.y + (dislikeButton.frame.size.height));
    //datePostedLabel.center = CGPointMake(self.frame.size.width - datePostedLabel.frame.size.width/2 - 15, self.frame.size.height - datePostedLabel.frame.size.height);
    datePostedLabel.textAlignment = NSTextAlignmentCenter;
    //datePostedLabel.center = CGPointMake(self.frame.size.width/2, datePostedLabel.frame.size.height/2);
    datePostedLabel.center = CGPointMake(self.frame.size.width - datePostedLabel.frame.size.width/2 - 10, self.frame.size.height - datePostedLabel.frame.size.height/1.5);
    
    //Add a user label (if applicable)
    if(self.comment.user){
        UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(dislikeButton.frame.origin.x, 0, self.frame.size.width, datePostedLabel.frame.size.height)];
        userLabel.text = [NSString stringWithFormat:@"By: %@", self.comment.user];
        userLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:userLabel];
    }
    
    //NSLog(@"Comment Id: %@\nTitle: %@", self.comment.iden, self.comment.titleOfPost);
    
    //Add a line to the very bottom to differentitate between views
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 2, self.frame.size.width, 2)];
    line.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:line];
    
    
    if(self.comment.iden == NULL){
        dislikeButton.enabled = NO;
        likeButton.enabled = NO;
    }
}

-(void)adjustCenters{
    
    /*
    dislikeButton.center = CGPointMake(self.frame.size.width/2 - likeButton.frame.size.width, likeButton.center.y);
    dislikeCount.center = CGPointMake(dislikeButton.center.x - likeButton.frame.size.width - dislikeCount.frame.size.width/2, likeCount.center.y);
    likeButton.center = CGPointMake(self.frame.size.width/2 + dislikeButton.frame.size.width, likeCount.center.y);
    likeCount.center = CGPointMake(likeButton.center.x + dislikeButton.frame.size.width + likeCount.frame.size.width/2, dislikeButton.center.y);*/
    
    dislikeButton.center = CGPointMake(dislikeButton.frame.size.width/2 + messageLabel.frame.origin.x, likeButton.center.y);
    dislikeCount.center = CGPointMake(dislikeButton.center.x + dislikeButton.frame.size.width/2 + dislikeCount.frame.size.width/2 + 5, dislikeButton.center.y);
    likeButton.center = CGPointMake(messageLabel.center.x/1.5, dislikeCount.center.y);
    likeCount.center = CGPointMake(likeButton.center.x + likeButton.frame.size.width/2 + likeCount.frame.size.width/2 + 5, likeButton.center.y);
}

-(NSString *)formatDate:(NSDate *)dateToFormat
{
    //The date is in he following format:
    /*
     *  YYYY-MM-DDTHH-MM-SS000Z
     *
     *  Starting with the year (YYYY-MM-DD) then work into the time(HH:MM:SS).
     *  We will then add the timesince at the end (30 seconds ago...)
     *
     */
    //NSString *formattedDate = [[NSString alloc] init];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    //The Z at the end of your string represents Zulu which is UTC
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    //NSDate* newTime = [dateFormatter dateFromString:dateToFormat.description];
    NSDate *newTime = dateToFormat;
    //NSLog(@"original time: %@", newTime);
    
    //Add the following line to display the time in the local time zone
    //[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    //[dateFormatter setDateFormat:@"EEEE'\t|\t' MMM d, yyyy '\t|\t' h:mm a"];
    //[dateFormatter setDateFormat:@"h:mm a '\t\t|\t' EEEE '\t|\t' MMM d, yyy"];
    NSString* finalTime = [dateFormatter stringFromDate:dateToFormat];
    
    float secondsSincePost = [[NSDate date] timeIntervalSinceDate:newTime];
    
    int number = 0;
    
    //If years
    if (secondsSincePost > 31557600) {
        number = 31557600;
        finalTime = @"Too Long Ago...";
    }
    //If months
    else if (secondsSincePost > 2629800){
        number = (int)(secondsSincePost/2629800);
        finalTime = [NSString stringWithFormat:@"%i month", number];
    }
    //If weeks
    else if (secondsSincePost > 604800){
        number = (int)(secondsSincePost/604800);
        finalTime = [NSString stringWithFormat:@"%i week", number];
    }
    //If days
    else if (secondsSincePost > 86400){
        number = (int)(secondsSincePost/86400);
        finalTime = [NSString stringWithFormat:@"%i day", number];
    }
    //If hours
    else if (secondsSincePost > 3600){
        number = (int)(secondsSincePost/3600);
        finalTime = [NSString stringWithFormat:@"%i hour", number];
    }
    //If Mins
    else if (secondsSincePost > 60){
        number = (int)(secondsSincePost/60);
        finalTime = [NSString stringWithFormat:@"%i minute", number];
    }
    //If secs
    else if (secondsSincePost > 0){
        number = (int)(secondsSincePost);
        finalTime = [NSString stringWithFormat:@"%i second", number];
    }
    else{finalTime = @"";}
    
    if (number == 1) {
        finalTime = [finalTime stringByAppendingString:@" ago"];
    }
    else if ((number == 0 || number > 1) && number < 31557600){
        finalTime = [finalTime stringByAppendingString:@"s ago"];
    }
    else if (finalTime.length > 0){
        
    }
    else if (number < 31557600){
        finalTime = [finalTime stringByAppendingString:@"s ago"];
    }
    
    
    //NSLog(@"%@", finalTime);
    
    if (finalTime.length > 0 && ![finalTime isEqualToString:@"s ago"]) {
        return finalTime;
    }
    else
        return @"";
}

-(void)doOpposite{
    //If we are doing something with this result, do it now
    //Remove it from the system
    NSString *tableName = ([[tempMessageInfo valueForKey:@"likedMessage"]boolValue]) ? @"LikeMessage" : @"DislikeMessage";
    [self deleteMessage:[tempMessageInfo valueForKey:@"messageResultID"] fromTable:tableName];
    
    //remove for the dict
    NSMutableArray *checkedMessages = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"commentedPosts"]];
    [checkedMessages removeObject:tempMessageInfo];
    [[NSUserDefaults standardUserDefaults] setObject:checkedMessages forKey:@"commentedPosts"];
    
    //Now do the opposite
    //Get out of endless loop here
    if(([[tempMessageInfo valueForKey:@"likedMessage"]boolValue])) [self dislikePost];
    else [self likePost];
}

-(void)likePost{
    if ([self messageWasAlreadyVotedOn_doReverse]) {
        //Do something
        //NSLog(@"Already voted for this message");
        [self doOpposite];
    }
    else{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/LikeMessage?api_key=keyBAo5QorTmqZmN8"]]];
        
        //NSDictionary *credentials = [NSDictionary dictionaryWithObjectsAndKeys:@"email", @"jstngoulet@me.com", @"password", @"password", nil];
        NSString *cred = [NSString stringWithFormat:@"{\"fields\":{\"UserName\":[\"%@\"], \"MessageLiked\":[\"%@\"]}}", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"][@"id"],  self.comment.iden];
        
        // Specify that it will be a POST request
        request.HTTPMethod = @"POST";
        
        // This is how we set header fields
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        // Convert your data and set your request's HTTPBody property
        NSString *stringData = cred.description;
        NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPBody = requestBodyData;
        
        // Create url connection and fire request
        updateLike = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

-(void)dislikePost{
    //NSLog(@"Dislike Tapped");
    if([self messageWasAlreadyVotedOn_doReverse]){
        //Do something
        NSLog(@"Already voted for this message");
        [self doOpposite];
    }
    else{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/DislikeMessage?api_key=keyBAo5QorTmqZmN8"]]];
    
    //NSDictionary *credentials = [NSDictionary dictionaryWithObjectsAndKeys:@"email", @"jstngoulet@me.com", @"password", @"password", nil];
    NSString *cred = [NSString stringWithFormat:@"{\"fields\":{\"UserName\":[\"%@\"], \"MessageDisliked\":[\"%@\"]}}",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"][@"id"], self.comment.iden];
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
    updateDislike = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

-(BOOL)messageWasAlreadyVotedOn_doReverse{
    //Check to see if a vote on this message already exists
    NSMutableArray *checkedMessages = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"commentedPosts"]];
    for (NSDictionary *temp in checkedMessages) {
        //NSLog(@"posts: %@", temp);
        if ([[temp valueForKey:@"messageCommentedOn"] isEqualToString:self.comment.iden]) {
            NSLog(@"Messgae Found! votes: %i",  (int)[[temp valueForKey:@"likedMessage"]boolValue]);
            tempMessageInfo = temp;
            //If the message is found, we need to
            return YES;
        }
    }
    return NO;
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
        if (connection == updateLike) {
            //NSLog(@"Connection-Like: %@", readJSON);
            //[self likePostSaved];
            [self votedWithID:readJSON[@"id"] likedMessage:YES];
        }
        else if (connection == updateDislike){
            //NSLog(@"Connection-Dislike: %@", readJSON);
            // [self dislikePostSaved];
            [self votedWithID:readJSON[@"id"] likedMessage:NO];
        }
        else if (connection == removeRequest){
           //NSLog(@"Removed Data: %@", readJSON);
        }
        
        if (![readJSON[@"code"] isEqualToString:@"temporarily_unavailable"]) {
            self.comment.numberOfLikes = [[readJSON[@"fields"][@"TotalLikes"] objectAtIndex:0]intValue];
            self.comment.numberOfDislikes = [[readJSON[@"fields"][@"TotalDislikes"] objectAtIndex:0]intValue];
            
            likeCount.text = [NSString stringWithFormat:@"%i", [[readJSON[@"fields"][@"TotalLikes"] objectAtIndex:0]intValue]];
            [likeCount sizeToFit];
            likeCount.center = CGPointMake(likeButton.center.x + likeButton.frame.size.width/1.5 + likeCount.frame.size.width/2, likeButton.center.y);
            
            dislikeCount.text = [NSString stringWithFormat:@"%i", [[readJSON[@"fields"][@"TotalDislikes"] objectAtIndex:0]intValue]];
            [dislikeCount sizeToFit];
            dislikeCount.center = CGPointMake(likeButton.center.x + likeButton.frame.size.width/1.5 + dislikeCount.frame.size.width/2, dislikeButton.center.y);
            [self adjustCenters];
        }
        
        
        
        NSLog(@"JSON: %@", readJSON);
    }
    else
        NSLog(@"Error: %@", localError);
    
   //NSLog(@"Final Array: %@", readJSON);
    
}

-(void)votedWithID:(NSString *)iden likedMessage:(BOOL)value{
    //Save the message id into its own array
    [self messageLiked:value];
    
    //We need to first create the dictionary in which we are checking. And the array
    NSMutableArray *checkedMessages = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"commentedPosts"]];
    
    [checkedMessages addObject:@{@"messageCommentedOn" : self.comment.iden,
                                 @"messageResultID" : iden,
                                 @"likedMessage": [NSString stringWithFormat:@"%i", (int)value]}];
    [[NSUserDefaults standardUserDefaults] setObject:[checkedMessages copy] forKey:@"commentedPosts"]; //[checkedMessages copy]
    
    [self setLiked:value];
}

//Saves the message id into an array based on if it was liked or not
-(void)messageLiked:(BOOL)value{
    NSString *location = (value) ? @"likedMessages" : @"dislikedMessages";
    NSMutableArray *messages = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:location]];
    [messages addObject:self.comment.iden];
    [[NSUserDefaults standardUserDefaults] setObject:messages forKey:location];
}


-(void)setLiked:(BOOL)value{
    likeButton.enabled = !value;
    dislikeButton.enabled = value;
}

-(void)deleteMessage:(NSString *)messageID fromTable:(NSString *)tableName{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/%@/%@?api_key=keyBAo5QorTmqZmN8", tableName, messageID]]];
    
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"DELETE";
    
    // This is how we set header fields
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"Deleting from table: %@", tableName);
    
    
    // Create url connection and fire request
    removeRequest = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

@end
