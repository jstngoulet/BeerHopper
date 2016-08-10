//
//  MiniDetailView.h
//  Beer Hopper
//
//  Created by Justin Goulet on 3/12/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentView.h"
#import "ForumObject.h"
#import "Beer.h"
#import "CustomTableView.h"

@interface MiniDetailView : UIView{
    int numberOfComments;
    float offset;
    NSMutableArray *likedPosts;
}

@property (nonatomic) UIViewController *mainViewController;
@property (nonatomic) UIView *mainView, *backgroundView;
@property (nonatomic) UIImageView *mainImage;
@property (nonatomic) UIImage *primaryImage;
@property (nonatomic) UIScrollView *ratingsTable;
@property (nonatomic) NSString *apiInstanceId, *inputViewType;
@property (nonatomic) Beer *thisBeer;
@property (nonatomic) UIButton *closeButton;
@property (nonatomic, strong) UIActivityIndicatorView *anActivity;

-(void)build;
@end
