//
//  EventsViewController.h
//  Beer Hopper
//
//  Created by Justin Goulet on 1/16/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "EventCellClass.h"
#import "EventDetailViewController.h"
#import "HopperData.h"
#import "NothingFoundTableViewCell.h"

@interface EventsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UIImageView *noBeersLikedImage;
}
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UITableView *eventsTable;
@property (nonatomic) NSMutableArray *events;
@property (nonatomic) NSArray *editedEvents;
@property (strong, nonatomic) HopperData *hopper;

@property (nonatomic) BOOL noBeersFound;
-(IBAction)refreshEvents:(id)sender;

@end
