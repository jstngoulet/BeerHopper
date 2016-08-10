//
//  ForumsMain.h
//  Beer Hopper
//
//  Created by Justin Goulet on 1/14/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumsCellClass.h"
#import "ForumObject.h"
#import "AppDelegate.h"
#import "HopperData.h"
#import "ForumDetailViewController.h"
#import "TextInputView.h"
#import "NothingFoundTableViewCell.h"

@interface ForumsMain : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    TextInputView *textInput;
    AppDelegate *del;
    UIImageView *noBeersLikedImage;
}
@property (nonatomic) NSArray *sampleData;
@property (nonatomic) HopperData *postsData;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addTopic;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshData;

@property (nonatomic) BOOL noBeersFound;

@end
