//
//  BeerView.h
//  Beer Hopper
//
//  Created by Justin Goulet on 1/16/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Beer.h"
#import "MiniDetailView.h"
#import "MyAnalytics.h"

@interface BeerView : UIView <NSURLConnectionDelegate>
{
    NSURLConnection *voteForBeer, *downVoteBeer;
    UIImage *beer;
}
@property (strong, nonatomic) Beer *currentBeer;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *beerTitle;
@property (strong, nonatomic) UIButton *infoButton, *commentBoardButton, *likeButton;
@property (strong) UIViewController *mainViewController;
@property (nonatomic, strong) NSMutableData *responseData;


-(id)initWithFrame:(CGRect)frame beer:(Beer *)thisBeer;
-(void)setLiked:(BOOL)value;
-(IBAction)upVoteBeer:(id)sender;

@end
