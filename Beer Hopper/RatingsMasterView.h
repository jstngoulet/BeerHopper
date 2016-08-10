//
//  RatingsMasterView.h
//  Beer Hopper
//
//  Created by Justin Goulet on 6/7/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"
#import "ForumObject.h"
#import "ImageActivityView.h"

@interface RatingsMasterView : UIView

//this class will create a view for all rating views
@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) UIScrollView *mainScroller;
@property (nonatomic) float currentY;
@property (strong, nonatomic) ImageActivityView *activity;

-(id)initWithFrame:(CGRect)frame andPosts:(NSArray *)postsArray;

@end
