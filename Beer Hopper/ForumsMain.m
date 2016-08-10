//
//  ForumsMain.m
//  Beer Hopper
//
//  Created by Justin Goulet on 1/14/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "ForumsMain.h"
#import "MyAnalytics.h"

@interface ForumsMain ()

@end

@implementation ForumsMain

-(void)viewDidAppear:(BOOL)animated{
    del = [[UIApplication sharedApplication]delegate];
    self.postsData = del.myHopperData;
    
    
    [self getData];

    MyAnalytics *temp = [[MyAnalytics alloc] init];
    [temp viewShown:@"Forums Main"];
    
    //Add the frame for the liked beers image
    float tabbarHeight = self.navigationController.navigationBar.frame.size.height + self.tabBarController.tabBar.frame.size.height;
    noBeersLikedImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, tabbarHeight, self.view.frame.size.width, self.view.frame.size.height - tabbarHeight)];
    noBeersLikedImage.image = [UIImage imageNamed:@"NoPostsFound.png"];
    [self.view addSubview:noBeersLikedImage];
    noBeersLikedImage.contentMode = UIViewContentModeScaleAspectFit;
    noBeersLikedImage.hidden = YES;
    noBeersLikedImage.backgroundColor = self.view.backgroundColor;
    noBeersLikedImage.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + tabbarHeight/4);
}

-(IBAction)getData{
    
    del = [[UIApplication sharedApplication]delegate];
    self.sampleData = [NSArray array];
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [del getMessages];
        
        // update UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.sampleData = [NSArray arrayWithArray:del.myHopperData.forumPosts];
            self.postsData = del.myHopperData;
            [self.mainTable performSelectorOnMainThread:@selector(reloadData) withObject:NULL waitUntilDone:YES];
            
            
        });
        
    });
}

-(IBAction)newTopicCreate:(id)sender{
    
    textInput = [[TextInputView alloc] initWithFrame:self.parentViewController.view.frame];
    textInput.animatesIn = YES; textInput.animationSpeed = .5; textInput.animatesOut = YES;
    textInput.placeholderText = @"Title";
    [textInput show];
    [self.parentViewController.view addSubview:textInput];
    
    //Add ability to send message when submitted
    [textInput.sendBtn addTarget:self action:@selector(submitText) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)submitText{
    ForumObject *createdObject = [[ForumObject alloc] initWithTitle:textInput.title.text message:textInput.mainMessage.text imageAddress:@"" rating:0 dateOfPost:[NSDate date] messageType:@"Forum Post" likes:0 dislikes:0 user:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"][@"id"]];
    [self.postsData submitNewTopic:createdObject event:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Add some sample posts
    /*
     ForumObject *question1 = [[ForumObject alloc] init];
     question1.titleOfPost = @"IPA Hops";
     question1.numberOfComments = 5;
     question1.numberOfLikes = 24;
     
     ForumObject *question2 = [[ForumObject alloc] init];
     question2.titleOfPost = @"Time To Boil";
     question2.numberOfComments = 15;
     question2.numberOfLikes = 22;
     
     ForumObject *question3 = [[ForumObject alloc] init];
     question3.titleOfPost = @"Best Place to Buy Hops";
     question3.numberOfComments = 1;
     question3.numberOfLikes = 0;
     
     ForumObject *question4 = [[ForumObject alloc] init];
     question4.titleOfPost = @"Time to Ferment";
     question4.numberOfComments = 52;
     question4.numberOfLikes = 2;
     
     ForumObject *question5 = [[ForumObject alloc] init];
     question5.titleOfPost = @"Pale Ale Recepies";
     question5.numberOfComments = 5;
     question5.numberOfLikes = 24;
     
     _sampleData = [NSArray arrayWithObjects:question1, question2, question3, question4, question5, nil];*/
    
    del = [[UIApplication sharedApplication]delegate];
    self.sampleData = [NSArray arrayWithArray:del.myHopperData.forumPosts];
    self.postsData = del.myHopperData;
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    //Get from teh database
    [self getData];
    
    
}

-(void)addShadowToView:(UIView *)temp{
    temp.layer.shadowOffset = CGSizeMake(1, 1);
    temp.layer.shadowColor = [UIColor grayColor].CGColor;
    temp.layer.shadowRadius = 2.0f;
    temp.layer.shadowOpacity = 1;
    temp.layer.shadowPath = [[UIBezierPath bezierPathWithRect:temp.layer.bounds] CGPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"View Height: %f", tableView.frame.size.height/4);
    return 125;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.sampleData.count > 0) {
        self.noBeersFound = NO;
        noBeersLikedImage.hidden = YES;
        return _sampleData.count;
    }
    else{
        self.noBeersFound = YES;
        noBeersLikedImage.hidden = NO;
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(!self.noBeersFound){
    static NSString *identifier = @"forumCell";
    [tableView registerNib:[UINib nibWithNibName:@"ForumsCellClass" bundle:nil] forCellReuseIdentifier:identifier];
    
    // Get the cell's root view and set the table's
    // rowHeight to the root cell's height.
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ForumsCellClass"
                                                 owner:self
                                               options:nil];
    ForumsCellClass *cell = (ForumsCellClass *)nib[0];
    ForumObject *tempObject = (ForumObject *)[self.sampleData objectAtIndex:indexPath.row];
    
    @try {
        //NSLog(@"CEll width: %.f", cell.frame.size.width);
        cell.titleLabel.text = tempObject.titleOfPost;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dateLabel.text = tempObject.dateString;
        cell.userLabel.text = tempObject.user;
        //cell.dislikeCountLabel.text = [NSString stringWithFormat:@"%i", tempObject.numberOfDislikes];
        cell.currentObject = tempObject;
        [self addShadowToView:cell.colorView];
        
        cell.numberOfCommentsLabel.text = [NSString stringWithFormat:@"%i", tempObject.numberOfComments];
        cell.numberOfLikesLabel.text = [NSString stringWithFormat:@"%i", tempObject.numberOfLikes];
        cell.dislikeCountLabel.text = [NSString stringWithFormat:@"%i", tempObject.numberOfDislikes];

    }
    @catch (NSException *exception) {
        NSLog(@"Exception Found: %@", exception);
    }
    return cell;
    }
    else{
        //NSLog(@"Nothing Found");
        static NSString *identifier = @"NothingFound";
        [tableView registerNib:[UINib nibWithNibName:@"NothingFoundTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
        
        // Get the cell's root view and set the table's
        // rowHeight to the root cell's height.
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NothingFoundTableViewCell"
                                                     owner:self
                                                   options:nil];
        NothingFoundTableViewCell *cell = (NothingFoundTableViewCell *)nib[0];
        @try {
            cell.label.text = @"No Posts Found!";
        }@catch(NSException *e){
            NSLog(@"Exception: %@", e.description);
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.mainView.backgroundColor = cell.backgroundColor;
        return cell;
    }

}



//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{return @"Topics";}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self getData];
    [self.mainTable reloadData];
    
    /*
     for(ForumObject *temp in self.postsData.forumPosts){
     NSLog(@"Message: %@", temp.titleOfPost);
     }*/
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ForumDetailViewController *temp = [self.storyboard instantiateViewControllerWithIdentifier:@"forumDetail"];
    temp.title = [(ForumObject *)[self.sampleData objectAtIndex:indexPath.row] titleOfPost];
    temp.mainPost = (ForumObject *)[self.sampleData objectAtIndex:indexPath.row];
    //NSLog(@"Event Tapped: %@", temp.thisEvent.eventName);
    
    [self.navigationController pushViewController:temp animated:YES];
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
