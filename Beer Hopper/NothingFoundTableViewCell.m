//
//  NothingFoundTableViewCell.m
//  Beer Hopper
//
//  Created by Justin Goulet on 5/31/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "NothingFoundTableViewCell.h"

@implementation NothingFoundTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

-(void)addShadow{
    CALayer *layer = self.mainView.layer;
    layer.shadowOffset = CGSizeZero;
    layer.shadowColor = [[UIColor blackColor] CGColor];
    //changed for the fancy shadow
    layer.shadowRadius = 1.0f;
    layer.shadowOpacity = 0.60f;
    //call our new fancy shadow method
    layer.shadowPath = [self fancyShadowForRect:self.mainView.layer.frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGPathRef)fancyShadowForRect:(CGRect)rect
{
    CGSize size = rect.size;
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    //right
    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(size.width, 0.0f)];
    [path addLineToPoint:CGPointMake(size.width, size.height + 15.0f)];
    
    //curved bottom
    [path addCurveToPoint:CGPointMake(0.0, size.height + 15.0f)
            controlPoint1:CGPointMake(size.width - 15.0f, size.height)
            controlPoint2:CGPointMake(15.0f, size.height)];
    
    [path closePath];
    
    return path.CGPath;
}

@end
