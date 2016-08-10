//
//  ForumObject.h
//  Beer Hopper
//
//  Created by Justin Goulet on 1/17/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ForumObject : NSObject

@property (nonatomic)UIColor *colorOfLabel;
@property (nonatomic) UIImage *postImage;
@property (nonatomic) int numberOfLikes, numberOfDislikes, numberOfComments;
@property (nonatomic) double rating;
@property (nonatomic) NSString *titleOfPost, *messageType, *messageBody, *user, *iden, *dateString;
@property (nonatomic) NSDate *messageDate;
@property (nonatomic) NSArray *comments;

-(id)initWithTitle:(NSString *)title message:(NSString *)messageContent imageAddress:(NSString *)imgURL rating:(double)thisRating dateOfPost:(NSDate *)date messageType:(NSString *)type likes:(int)numLikes dislikes:(int)numDislikes user:(NSString *)userName;
-(NSComparisonResult)sortByDate:(ForumObject *)other;
@end
