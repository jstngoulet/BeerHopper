//
//  NothingFoundView.h
//  Beer Hopper
//
//  Created by Justin Goulet on 6/27/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NothingFoundView : UIView

//We will have the primary view, a view that will appear closer (with a shadow), a title, and a description. The circle label will be circular, be the app color and have a white exclamation point in it
@property (nonatomic, strong) UIView *backgroundView, *mainView;
@property (nonatomic, strong) UILabel *titleLabel, *descriptionLabel, *circleLabel;

-(id)initWithTitle:(NSString *)title description:(NSString *)description masterFrame:(CGRect)frame;

@end
