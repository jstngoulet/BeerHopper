//
//  ForumDetailViewViewController.h
//  Beer Hopper
//
//  Created by Justin Goulet on 3/5/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumObject.h"
#import "CommentView.h"
#import "ImageActivityView.h"
#import "TextInputView.h"
#import "HopperData.h"

@interface ForumDetailViewController : UIViewController{
    UILabel *mainMessage;
    UIScrollView *messageScroller, *commentsTable; //Note that these smaller views are not clickable, but user can still like them
    float offset;
    int countOfComments;
    NSMutableArray *likedPosts;
    ImageActivityView *activity;
    TextInputView *textInput;
}

//We have the main message and maybe a picture (show in a scroll view in case)
@property (nonatomic, nonnull) UIImage *postImage;
@property (nonatomic, nonnull) UIView *toolbar;
@property (nonatomic, nonnull) UIButton *submitComment;

//Current Forum Object
@property (nonatomic, nonnull) ForumObject *mainPost;
@end
