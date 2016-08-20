//
//  RatingsMasterView.m
//  Beer Hopper
//
//  Created by Justin Goulet on 6/7/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "RatingsMasterView.h"

@implementation RatingsMasterView

-(id)initWithFrame:(CGRect)frame andPosts:(NSArray *)postsArray{
    self = [super initWithFrame:frame];
    self.mainScroller = [[UIScrollView alloc] initWithFrame:frame];
    [self addSubview:self.mainScroller];
    //self.backgroundColor = [UIColor colorWithRed:0.906 green:0.922 blue:0.933 alpha:1.00];
    self.mainScroller.center = CGPointMake(self.mainScroller.frame.size.width/2, self.mainScroller.frame.size.height/2);
    self.posts = [NSMutableArray arrayWithArray:postsArray];
    [self build];
    return self;
}

-(void)build{
    //self.currentY = 10;
    for (ForumObject *temp in self.posts) {
        RatingView *tempView = [[RatingView alloc] initWithFrame:CGRectMake(-10, self.currentY, self.frame.size.width, self.frame.size.width/2) Post:temp];
        tempView.frame = CGRectMake(-10, self.currentY, self.frame.size.width, tempView.mainView.frame.size.height + 20);
        tempView.center = CGPointMake(self.frame.size.width/2 - 10, tempView.center.y);
        [self.mainScroller addSubview:tempView];
        self.currentY += tempView.frame.size.height;
    }
    self.mainScroller.contentSize = CGSizeMake(self.mainScroller.frame.size.width, self.currentY + 10);
}


@end
