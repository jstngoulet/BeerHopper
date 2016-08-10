//
//  BeerTableViewCell.h
//  Beer Hopper
//
//  Created by Justin Goulet on 5/24/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Beer.h"
#import "BeerView.h"
#import "MyAnalytics.h"

@interface BeerTableViewCell : UITableViewCell <NSURLConnectionDelegate> {
    NSURLConnection *voteForBeer, *downVoteBeer;
}
@property (weak, nonatomic) IBOutlet UILabel *beernNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *abvLabel;
@property (weak, nonatomic) IBOutlet UILabel *ibuLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (strong, nonatomic) Beer *thisBeer;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *servingTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *beerRatingLabel;
@property (weak, nonatomic) IBOutlet UIButton *abvTitle;
@property (weak, nonatomic) IBOutlet UIButton *ibuTitle;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIView *parentView;
@property (weak, nonatomic) IBOutlet UIImageView *beerImage;
@property (weak, nonatomic) IBOutlet UILabel *servingStyle;
@property (weak, nonatomic) IBOutlet UILabel *isAvailableLabel;
@property (weak, nonatomic) IBOutlet UIButton *co2Title;
@property (weak, nonatomic) IBOutlet UIButton *isAvailTitle;
@property (weak, nonatomic) IBOutlet UILabel *beerTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *beerTypeTitle;
@property (nonatomic) BOOL lineAdded;

//NSURL Stuff
@property (nonatomic, strong) NSMutableData *responseData;

-(void)setLiked:(BOOL)value;
@end
