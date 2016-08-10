//
//  RatingView.h
//  Beer Hopper
//
//  Created by Justin Goulet on 6/7/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumObject.h"

@interface RatingView : UIView

@property (strong, nonatomic) UILabel *dataLabel, *ratingLabel, *messageLabel, *aliasLabel;
@property (strong, nonatomic) UIView *mainView;
@property (strong, nonatomic) ForumObject *thisPost;

-(id)initWithFrame:(CGRect)frame Post:(ForumObject *)post;
@end
