//
//  RoutesViewController.m
//  Beer Hopper
//
//  Created by Justin Goulet on 1/16/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "RoutesViewController.h"

@interface RoutesViewController ()

@end

@implementation RoutesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    delagate = [[UIApplication sharedApplication] delegate];
    
    //Get some routes
    RouteObject *firstRoute = [[RouteObject alloc] initWithName:@"Friday Nite Out" lastTraveled:[NSDate dateWithTimeInterval:-36000 sinceDate:[NSDate date]] andBreweries:[NSArray arrayWithObjects:[delagate.breweries objectAtIndex:0], [delagate.breweries objectAtIndex:1], [delagate.breweries objectAtIndex:2], nil]];
    
    RouteObject *secondRoute = [[RouteObject alloc] initWithName:@"Just a Taster" lastTraveled:[NSDate dateWithTimeInterval:-3600 sinceDate:[NSDate date]] andBreweries:[NSArray arrayWithObjects:[delagate.breweries objectAtIndex:1], nil]];
    
    self.myRoutes = [NSArray arrayWithObjects:firstRoute, secondRoute, nil];
    
    //self.routesTable.bounces = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{return self.myRoutes.count;}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{return @"Most Popular:";}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{//NSLog(@"Row Hieght (Routes): %.0f", tableView.frame.size.height/1.25);return self.routesTable.frame.size.height/1.25;
    //return 414;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return tableView.frame.size.height/2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"routeCell";
    [tableView registerNib:[UINib nibWithNibName:@"RouteCell" bundle:nil] forCellReuseIdentifier:identifier];
    
    // Get the cell's root view and set the table's
    // rowHeight to the root cell's height.
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RouteCell"
                                                 owner:self
                                               options:nil];
    RouteCell *cell = (RouteCell *)nib[0];
    
    //Save the current route for easy access
    RouteObject *temp = (RouteObject *)[self.myRoutes objectAtIndex:indexPath.row];
    cell.currentRoute = temp;
    [cell addShadowToView:cell.mainView];
    
    @try {
        //Determine the amount of breweries in the route
        //int numberOfBreweries = (int)temp.breweries.count;
        int iterator = 1;
        //NSLog(@"Number of breweries: %i", numberOfBreweries);
        for (Brewery *brewTemp in temp.breweries) {
            //NSLog(@"Brewery %i: %@", iterator, brewTemp.name);
            switch (iterator) {
                case 0:
                    //No Breweries, delete this route
                    break;
                    
                case 1:
                    cell.beweryProfilePic1.image = brewTemp.profilePicture;
                    break;
                    
                case 2:
                    cell.beweryProfilePic2.image = brewTemp.profilePicture;
                    break;
                    
                case 3:
                    cell.beweryProfilePic3.image = brewTemp.profilePicture;
                    break;
                    
                case 4:
                    cell.beweryProfilePic4.image = brewTemp.profilePicture;
                    break;
                    
                default:
                    //If more, show a different view for the fourth one
                    cell.beweryProfilePic4.backgroundColor = [UIColor blueColor];
                    break;
            }
            iterator++;
        }
        
        cell.nameOfRoute.text = temp.routeName;
        //cell.routeMap.delegate = self;
        cell.lastTourLabel.text = [self formatDate:temp.dateLastTraveled];
        cell.numberTimeTakenLabel.text = [NSString stringWithFormat:@"%i", arc4random() %15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setDelagate];
        [cell dropPins];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
    //NSLog(@"Current Text: %@ /end text", currentCell.businessTitle.text);
    return cell;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self.routesTable reloadData];
    
    
    //Google analytics
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Routes"];
    [tracker allowIDFACollection];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
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
    
    if (finalTime.length > 0) {
        return finalTime;
    }
    else
        return @"";
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
