//
//  CommentView.h
//  Beer Hopper
//
//  Created by Justin Goulet on 3/5/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumObject.h"

@interface CommentView : UIView <NSURLConnectionDelegate>
{
    NSURLConnection *updateDislike, *updateLike, *removeRequest;
    UILabel *likeCount, *dislikeCount, *messageLabel;
    UIButton *dislikeButton, *likeButton;
    BOOL justDeleted;
    NSDictionary *tempMessageInfo;
}

@property (nonnull, nonatomic) ForumObject *comment;
@property (nonatomic, nonnull) NSMutableData *responseData;

-(void)setLiked:(BOOL)value;
-(void)build;
@end
