//
//  CollapseableView.h
//  Beer Hopper
//
//  Created by Justin Goulet on 8/19/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollapseableView : UIView

{ BOOL isOpen; CGRect originalHeight; }

@property (strong, nonatomic) NSString *title, *des;
@property (nonatomic) float maxHeight, minHeight;
@property (strong, nonatomic) UIView *miniView;
@property (strong, nonatomic) UIButton *arrow;

- (void)addContent:(UIView *)view;
-(void)updateFrameSize;
-(void)collapseView;

@end
