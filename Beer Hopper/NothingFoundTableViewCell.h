//
//  NothingFoundTableViewCell.h
//  Beer Hopper
//
//  Created by Justin Goulet on 5/31/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NothingFoundTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *label;

-(void)addShadow;
@end
