//
//  ForumsCellClass.h
//  Beer Hopper
//
//  Created by Justin Goulet on 1/17/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumObject.h"

@interface ForumsCellClass : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UIImageView *commentBubble;
@property (weak, nonatomic) IBOutlet UIImageView *likeBubble;
@property (weak, nonatomic) IBOutlet UILabel *numberOfCommentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLikesLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (nonatomic, strong) ForumObject *currentObject;
@property (weak, nonatomic) IBOutlet UIImageView *dislikeBubble;
@property (weak, nonatomic) IBOutlet UILabel *dislikeCountLabel;

-(void)makeViewRound:(UIView *)view;
@end
