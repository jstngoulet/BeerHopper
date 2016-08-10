//
//  InfoTableView.m
//  Brewery Hopper
//
//  Created by Justin Goulet on 5/31/16.
//  Copyright © 2016 Justin Goulet. All rights reserved.
//

#import "InfoTableView.h"
#import <MapKit/MapKit.h>

@implementation InfoTableView

//This is for a generic tableview. we will use this class for all four types of tables: events, beers, breweries and forums
-(id)init{
    self = [super init];
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    //Get current location;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    //[self->locationManager requestAlwaysAuthorization];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //Create header label
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, 50)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    //self.titleLabel.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.titleLabel];
    
    //Create action button
    self.actionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width*.75, self.frame.size.height/12.5)];
    self.actionButton.backgroundColor = [UIColor colorWithRed:0.380 green:0.490 blue:0.541 alpha:1.00];
    self.actionButton.layer.masksToBounds = YES;
    self.actionButton.layer.cornerRadius = 10;
    self.actionButton.center = CGPointMake(self.frame.size.width/2, self.frame.size.height - self.actionButton.frame.size.height *1.25);
    [self addSubview:self.actionButton];
    
    //Create blank frame to go behind the action button
    UILabel *temp = [[UILabel alloc] initWithFrame:self.actionButton.frame];
    [self insertSubview:temp belowSubview:self.actionButton];
    [self addShadowToView:temp];
    
    //Create main table
    self.mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, self.frame.size.width, self.frame.size.height - 70 - (self.frame.size.height - self.actionButton.frame.origin.y) - self.actionButton.frame.size.height/2)];
    self.mainTable.backgroundColor = [UIColor clearColor];
    [self addSubview:self.mainTable];
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTable.dataSource = self;
    self.mainTable.delegate = self;
    
    self.activity = [[ImageActivityView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width*.5, self.frame.size.width*.5)];
    self.activity.tintColor = [UIColor colorWithRed:0.306 green:0.416 blue:0.471 alpha:1.00];
    self.activity.waitingImage = [UIImage imageNamed:@"BeerHopperLogo.png"];
    self.activity.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addSubview:self.activity];
    [self.activity startAnimating];
    
    return self;
}

-(void)addShadowToView:(UIView *)temp{
    temp.layer.shadowOffset = CGSizeMake(2, 2);
    temp.layer.shadowColor = [UIColor grayColor].CGColor;
    temp.layer.shadowRadius = 10.0f;
    temp.layer.shadowOpacity = 1;
    temp.layer.shadowPath = [[UIBezierPath bezierPathWithRect:temp.layer.bounds] CGPath];
}

/**
 *  Table view delagtes
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"Info Count: %i", (int)self.currentInfo.count);
    return self.currentInfo.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{//NSLog(@"Row Hieght (Home Detail): %.0f", tableView.frame.size.height/4);return tableView.frame.size.height/4;
    if ([self.currentType isEqualToString:@"Brewery"]) {
        return tableView.frame.size.height/3;
    }
    else if ([self.currentType isEqualToString:@"Event"]){
        return tableView.frame.size.height/5.25;
        //return 357;
    }
    else{
        //NSLog(@"Content Type: '%@'", self.currentType);
        return tableView.frame.size.height/10;
    }
}

/**
 *  Build the cell (Note that the business labels should be replaced with feedback)
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.currentInfo.count > 0){
        [self.activity stopAnimating];
    }
    
    if ([self.currentType isEqualToString:@"Brewery"]) {
        //NSLog(@"Showing Brewery");
        static NSString *identifier = @"FavoriteBreweryCell";
        [tableView registerNib:[UINib nibWithNibName:@"FavoriteBreweryCell" bundle:nil] forCellReuseIdentifier:identifier];
        
        // Get the cell's root view and set the table's
        // rowHeight to the root cell's height.
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FavoriteBreweryCell"
                                                     owner:self
                                                   options:nil];
        BreweryView *cell = (BreweryView *)nib[0];
        @try {
            cell.thisBrewery = (Brewery *)[self.currentInfo objectAtIndex:indexPath.row];
            cell.breweryName.text = cell.thisBrewery.name;
            cell.backgroundColor = [UIColor clearColor];
            //Only do next sectionsif not yet completed
            if (cell.thisBrewery.profilePicture.description.length == 0){
                
                cell.coverPhoto.image = [UIImage imageNamed:@"SearchingForBrewery.png"];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    
                    UIImage *pro = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:cell.thisBrewery.picURL]]];
                    UIImage *cov = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:cell.thisBrewery.coverPicURL]]];
                    
                    //[(Brewery *)[_breweries objectAtIndex:indexPath.row] setCoverPhoto:cover];
                    //cell.loaded = YES;
                    
                    // update UI on the main thread
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.profilePicture.image = pro;
                        cell.coverPhoto.image = cov;
                        cell.thisBrewery.coverPhoto = cov;
                        cell.thisBrewery.profilePicture = pro;
                        //cell.loaded = YES;
                    });
                    
                });
            }
            else{
                cell.coverPhoto.image = cell.thisBrewery.coverPhoto;
                cell.profilePicture.image = cell.thisBrewery.profilePicture;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: %@", exception);
        }
        
        //NSLog(@"Current Text: %@ /end text", currentCell.businessTitle.text);
        return cell;    }
    else if ([self.currentType isEqualToString:@"Event"]){
        static NSString *identifier = @"eventCell";
        [tableView registerNib:[UINib nibWithNibName:@"EventCell" bundle:nil] forCellReuseIdentifier:identifier];
        
        // Get the cell's root view and set the table's
        // rowHeight to the root cell's height.
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventCell"
                                                     owner:self
                                                   options:nil];
        EventCellClass *cell = (EventCellClass *)nib[0];
        @try {
            cell.thisEvent = (Event *)[self.currentInfo objectAtIndex:indexPath.row];
            cell.eventTitle.text = [NSString stringWithFormat:@"%@", [(Event *)[self.currentInfo objectAtIndex:indexPath.row] eventName]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.thisBrewery = [(Event *)[self.currentInfo objectAtIndex:indexPath.row] thisBrewery];
            cell.profilePic.image = cell.thisBrewery.profilePicture;
            cell.coverPic.image = cell.thisBrewery.coverPhoto;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMMM d, YYYY"];
            cell.dateLabel.text = [formatter stringFromDate:[(Event *)[self.currentInfo objectAtIndex:indexPath.row] eventDate]];
            
            [formatter setDateFormat:@"h:mm a"];
            cell.timeLabel.text = [formatter stringFromDate:[(Event *)[self.currentInfo objectAtIndex:indexPath.row] eventDate]];
            cell.costLabel.text = [NSString stringWithFormat:@"$%@", cell.thisEvent.cost];
            cell.ageLabel.text = (cell.thisEvent.maxAge) ? [NSString stringWithFormat:@"%i", cell.thisEvent.minAge] : [NSString stringWithFormat:@"%i+", cell.thisEvent.minAge];
            
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
        NSLog(@"Content Type: '%@'", self.currentType);
    }
}

@end
