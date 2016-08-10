//
//  ImageButton.h
//  Brewery Hopper
//
//  Created by Justin Goulet on 5/31/16.
//  Copyright © 2016 Justin Goulet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageButton : UIButton

@property (strong, nonatomic) UIImageView *mainImageView;
@property (strong, nonatomic) UIImage *primaryImage, *disabledImage;
@property (strong, nonatomic) UILabel *primaryTitle;
@property (strong, nonatomic) UIView *bckView;
@property (strong, nonatomic) UIButton *primaryButton;

-(void)setOperable:(BOOL)value;
@end
