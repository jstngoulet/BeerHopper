//
//  ForumDetailViewViewController.m
//  Beer Hopper
//
//  Created by Justin Goulet on 3/5/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "ForumDetailViewController.h"

@interface ForumDetailViewController ()

@end

@implementation ForumDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Keep
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    //Set the title of the view
    self.title = self.mainPost.titleOfPost;
    
    // Do any additional setup after loading the view.
    //Create the scrollview that is half of the size of the view
    messageScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2.5)];
    [self.view addSubview:messageScroller];
    
    //Add the main message label
    mainMessage = [[UILabel alloc] initWithFrame:messageScroller.frame];
    mainMessage.numberOfLines = 0;
    mainMessage.text = self.mainPost.messageBody;
    mainMessage.font = [UIFont fontWithName:@"Mizo Broadway" size:16];
    [mainMessage sizeToFit];
    mainMessage.frame = CGRectMake(10, 5, self.view.frame.size.width - 20, mainMessage.frame.size.height + 35);
    [messageScroller addSubview:mainMessage];
    mainMessage.lineBreakMode = NSLineBreakByWordWrapping;
    messageScroller.contentSize = CGSizeMake(messageScroller.frame.size.width, mainMessage.frame.size.height + mainMessage.frame.origin.y);
    
    self.toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, messageScroller.frame.size.height, self.view.frame.size.width, self.tabBarController.tabBar.frame.size.height)];
    self.toolbar.backgroundColor = [UIColor colorWithRed:0.380 green:0.490 blue:0.541 alpha:1.00];
    [self.view addSubview:self.toolbar];
    
    //Add the comments scroller
    commentsTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, messageScroller.frame.size.height + self.toolbar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-messageScroller.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.toolbar.frame.size.height)];
    //commentsTable.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:commentsTable];
    
    //Add the submit comment button to the toolbar
    self.submitComment = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.toolbar.frame.size.height/1.5, self.toolbar.frame.size.height/1.5)];
    self.submitComment.backgroundColor = [UIColor clearColor];
    self.submitComment.layer.borderColor = [UIColor whiteColor].CGColor;
    self.submitComment.layer.masksToBounds = YES; self.submitComment.layer.cornerRadius = self.submitComment.frame.size.height/2;
    self.submitComment.layer.borderWidth = 1.5;
    [self.submitComment addTarget:self action:@selector(addComment:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.submitComment setBackgroundImage:[UIImage imageNamed:@"Submit_WithBorder.png"] forState:UIControlStateNormal];
    [self.submitComment setBackgroundImage:[UIImage imageNamed:@"Submit_WithBorder_Disabled.png"] forState:UIControlStateDisabled];
    [self.toolbar addSubview:self.submitComment];
    self.submitComment.center = CGPointMake(self.toolbar.frame.size.width/2, self.toolbar.frame.size.height/2);
    
    activity = [[ImageActivityView alloc] init];
    [self.view addSubview:activity];
    activity.tintColor = [UIColor colorWithRed:0.380 green:0.490 blue:0.541 alpha:1.00];
    [activity useImage:[UIImage imageNamed:@"BeerHopperLogo.png"]];
    [activity startAnimating];
    
    
    //Comments
    if([self.mainPost.comments count] > 0){
        //        /NSLog(@"Comments: %@", self.mainPost.comments[0]);
        likedPosts = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"commentedPosts"]];
        
        //Build the comments table
        //for (NSString *temp in self.mainPost.comments) {
            //NSURL*url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/%@/%@?api_key=keyBAo5QorTmqZmN8", @"messages", temp]];
            
            NSURL *url = [self BeerQuery];
            
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
                    
                    for(NSDictionary *response in json[@"records"]){
                        [self performSelectorOnMainThread:@selector(buildViewForComment:) withObject:response waitUntilDone:YES];
                    }
                    
                }
                else{
                    [self performSelectorOnMainThread:@selector(stopAnimating) withObject:NULL waitUntilDone:YES];
                }
            }];
        //}
    }
    else{ [self stopAnimating];
        
        NSLog(@"Building empty comment block");
        [self buildViewForComment:@{@"fields":@{@"Message":@"No Comments Found!"}}];
    }
    
    
}


-(NSURL *)BeerQuery{
    
    NSURL *temp;
    NSString *currentQuery = [self compoundFormulaWithSingleOperator:@"OR" andBeers:self.mainPost.comments];
    
    /*
     NSLog(@"Beer List");
     for (NSString *temp in self.brewery.beerList) {
     NSLog(@"Beer: %@", temp);
     }*/
    
    temp = [NSURL URLWithString:[[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/%@?filterByFormula=%@&api_key=keyBAo5QorTmqZmN8", @"messages", currentQuery] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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


-(IBAction)addComment:(id)sender{
    //UIButton *tempButton = (UIButton *)sender;
    //tempButton.enabled = !tempButton.enabled;
    //tempButton.layer.borderColor = [UIColor redColor].CGColor;
    
    //Add comment view
    textInput = [[TextInputView alloc] initWithFrame:self.parentViewController.view.frame];
    textInput.animatesIn = YES; textInput.animationSpeed = .5; textInput.animatesOut = YES;
    textInput.placeholderText = @"Comment"; textInput.title.enabled = NO;
    [textInput show];
    [self.parentViewController.view addSubview:textInput];
    
    //Add ability to send message when submitted
    [textInput.sendBtn addTarget:self action:@selector(submitText) forControlEvents:UIControlEventTouchUpInside];

}

-(void)submitText{
    HopperData *temp = [[HopperData alloc] init];
    [temp submitNewComment:textInput.mainMessage.text Topic:self.mainPost];
    
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    //The Z at the end of your string represents Zulu which is UTC
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    //Build a view for the comment using a custom built dictionary to match the response
    [self buildViewForComment:@{@"createdTime":[NSDate date].description, @"fields":@{@"Dislikes":@0, @"Message":textInput.mainMessage.text, @"Topics":[NSArray arrayWithObject:self.mainPost.iden], @"TotalRating":@0}}];
}

-(void)buildViewForComment:(NSDictionary *)post{
    
    CommentView *newView = [[CommentView alloc] initWithFrame:CGRectMake(0, offset, self.view.frame.size.width, commentsTable.frame.size.height/5)];
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
    
    if(thisPost.dateString.length == 0) thisPost.dateString = @"Moments Ago";
    
    newView.comment = thisPost;
    [newView build];
    [commentsTable addSubview:newView];
    offset += newView.frame.size.height;
    commentsTable.contentSize = CGSizeMake(commentsTable.frame.size.width, offset);
    
    //Check the values of previously voted posts
    for (NSDictionary *temp in likedPosts) {
        //NSLog(@"posts: %@", temp);
        if ([[temp valueForKey:@"messageCommentedOn"] isEqualToString:thisPost.iden]) {
            //NSLog(@"Messgae Found!");
            [newView setLiked:[[temp valueForKey:@"likedMessage"]boolValue]];
            break;
        }
    }
    
    if (countOfComments % 2 == 0) {
        newView.backgroundColor = [UIColor whiteColor];
    }
        countOfComments++;
        [self stopAnimating];
    
    //Stop animating after the first view is shown
}

-(void)stopAnimating{
    [activity stopAnimating];
    [activity removeFromSuperview];
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
