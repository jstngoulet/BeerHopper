//
//  EventsViewController.m
//  Beer Hopper
//
//  Created by Justin Goulet on 1/16/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "EventsViewController.h"
#import "AppDelegate.h"
#import "MyAnalytics.h"

@interface EventsViewController ()

@end

@implementation EventsViewController

-(void)viewDidAppear:(BOOL)animated{
    /*
    AppDelegate *temp = [[UIApplication sharedApplication] delegate];
    self.hopper = temp.myHopperData;
    
    //Start animating image view
    
    //Do background request
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [self.hopper getEvents];
        
        // update UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"Refreshing Table");
            
            [self.eventsTable reloadData];
            
            NSLog(@"Events Count: %i", (int)self.events.count);
            
        });
        
    });
    */
    
    if(self.events.count == 0)[self refreshEvents:NULL];
    [self.eventsTable reloadData];
    
    
    MyAnalytics *temp = [[MyAnalytics alloc] init];
    [temp viewShown:@"Events"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Let's add some events
    AppDelegate *delagate = [[UIApplication sharedApplication] delegate];
    self.events = [[NSMutableArray alloc] init];
    //[[[delagate myHopperData] events] removeAllObjects];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    for (Brewery *temp in delagate.breweries) {
        //Add all the events to the event array
        for (Event *eve in temp.events) {
            if(![temp.events containsObject:eve]){
            [self.events addObject:eve];
            }
            //fNSLog(@"Event: %@", eve.eventName);
            //NSLog(@"Host Brewery: %@", temp.name);
        }
    }
    [self.eventsTable reloadData];
    self.eventsTable.delegate = self;
    self.eventsTable.dataSource = self;
    self.eventsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if(self.events.count == 0)[self refreshEvents:NULL];
    
    //Add the frame for the liked beers image
    float tabbarHeight = self.navigationController.navigationBar.frame.size.height + self.tabBarController.tabBar.frame.size.height;
    noBeersLikedImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, tabbarHeight, self.view.frame.size.width, self.view.frame.size.height - tabbarHeight)];
    noBeersLikedImage.image = [UIImage imageNamed:@"NoEventsFound.png"];
    [self.view addSubview:noBeersLikedImage];
    noBeersLikedImage.contentMode = UIViewContentModeScaleAspectFit;
    noBeersLikedImage.hidden = YES;
    noBeersLikedImage.backgroundColor = self.view.backgroundColor;
    noBeersLikedImage.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + tabbarHeight/4);
    
    self.eventsTable.allowsSelection = YES;
    self.eventsTable.backgroundColor = self.view.backgroundColor;
    //self.eventsTable.bounces = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)refreshEvents:(id)sender{
    NSLog(@"Getting Events");
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[del myHopperData] getEvents];
    self.events = [NSMutableArray arrayWithArray:[[[del myHopperData] events] sortedArrayUsingSelector:@selector(sortByEventDate:)]];
    [self.eventsTable reloadData];
    
    MyAnalytics *temp = [[MyAnalytics alloc] init];
    [temp eventAction:@"Refreshed Events" category:[[self class] description] description:[NSString stringWithFormat:@"The User refreshed the events they were shown. This is because they only saw %i events", (int)self.events.count] breweryIden:@"" beerIden:@"" eventIden:@""];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.events.count > 0){
        self.noBeersFound = NO;
        noBeersLikedImage.hidden = YES;
        return self.events.count;
    }
    else{
        self.noBeersFound = YES;
        noBeersLikedImage.hidden = NO;
        return 1;
    }
}

/*
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{return @"Less than 10 mi.";}*/

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{//NSLog(@"Row Hieght (Events): %.0f", tableView.frame.size.height/2.5);return self.eventsTable.frame.size.height/2.5;
    //return 207;
    //NSLog(@"Width: %f, Height: %f", tableView.frame.size.width, tableView.frame.size.height);
    if(self.view.frame.size.width >= 375) return tableView.frame.size.width/3.25;
    else if (self.view.frame.size.width==320 && tableView.frame.size.height != 330) return tableView.frame.size.height/4.25;
    else if (self.view.frame.size.width==320 && tableView.frame.size.height == 330) return tableView.frame.size.height/3.25;
    else return tableView.frame.size.height/5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(!self.noBeersFound){
    static NSString *identifier = @"eventCell";
    [tableView registerNib:[UINib nibWithNibName:@"EventCell" bundle:nil] forCellReuseIdentifier:identifier];
    
    // Get the cell's root view and set the table's
    // rowHeight to the root cell's height.
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventCell"
                                                 owner:self
                                               options:nil];
    EventCellClass *cell = (EventCellClass *)nib[0];
    @try {
        cell.thisEvent = (Event *)[self.events objectAtIndex:indexPath.row];
        cell.eventTitle.text = [NSString stringWithFormat:@"%@", [(Event *)[self.events objectAtIndex:indexPath.row] eventName]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.thisBrewery = [(Event *)[self.events objectAtIndex:indexPath.row] thisBrewery];
        cell.profilePic.image = cell.thisBrewery.profilePicture;
        cell.coverPic.image = cell.thisBrewery.coverPhoto;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMMM d, YYYY"];
        cell.dateLabel.text = [formatter stringFromDate:[(Event *)[self.events objectAtIndex:indexPath.row] eventDate]];
        
        [formatter setDateFormat:@"h:mm a"];
        cell.timeLabel.text = [formatter stringFromDate:[(Event *)[self.events objectAtIndex:indexPath.row] eventDate]];
        cell.costLabel.text = [NSString stringWithFormat:@"$%@", cell.thisEvent.cost];
        cell.ageLabel.text = (cell.thisEvent.maxAge) ? [NSString stringWithFormat:@"%i", cell.thisEvent.minAge] : [NSString stringWithFormat:@"%i+", cell.thisEvent.minAge];
        cell.ageLabel.frame = CGRectMake(cell.ageLabel.frame.origin.x, cell.timeImage.frame.origin.y, cell.ageLabel.frame.size.width, cell.costLabel.frame.size.height);
        
        //Get the cover and profile pictures
        if ([cell.thisBrewery.profilePicture isEqual:NULL] || [cell.thisBrewery.coverPhoto isEqual:[UIImage imageNamed:@"SearchingForBrewery.png"]]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                UIImage *pro = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:cell.thisBrewery.picURL]]];
                UIImage *cover = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:cell.thisBrewery.coverPicURL]]];
                
                // update UI on the main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.profilePic.image = pro;
                    cell.coverPic.image = cover;
                    cell.thisBrewery.coverPhoto = cover;
                    cell.thisBrewery.profilePicture = pro;
                });
                
            });
        }
        else {
            cell.profilePic.image = cell.thisBrewery.profilePicture;
            cell.coverPic.image = cell.thisBrewery.coverPhoto;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
    //NSLog(@"Current Text: %@ /end text", currentCell.businessTitle.text);
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
            cell.label.text = @"No Events Found!";
        }@catch(NSException *e){
            NSLog(@"Exception: %@", e.description);
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.mainView.backgroundColor = cell.backgroundColor;
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EventDetailViewController *temp = [self.storyboard instantiateViewControllerWithIdentifier:@"Events Detail"];
    temp.title = [(Event *)[self.events objectAtIndex:indexPath.row] eventName];
    temp.thisEvent.thisBrewery = [(Event *)[self.events objectAtIndex:indexPath.row] thisBrewery];
    temp.thisEvent = (Event *)[self.events objectAtIndex:indexPath.row];
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
