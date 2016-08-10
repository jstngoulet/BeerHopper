//
//  NothingFoundView.m
//  Beer Hopper
//
//  Created by Justin Goulet on 6/27/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "NothingFoundView.h"

@implementation NothingFoundView

-(id)initWithTitle:(NSString *)title description:(NSString *)description masterFrame:(CGRect)frame;{
    self = [super initWithFrame:CGRectMake(10, 10, frame.size.width - 20, frame.size.height - 20)];
    
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 20)];
    self.mainView.backgroundColor = [UIColor blueColor];
    [self addSubview:self.mainView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.mainView.frame.size.width - 20, self.mainView.frame.size.height/3)];
    self.titleLabel.text = title;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:self.titleLabel];
    [self.titleLabel setBackgroundColor:[UIColor orangeColor]];
    
    self.descriptionLabel = [[UILabel alloc] initWithFrame:self.titleLabel.frame];
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.font = [UIFont systemFontOfSize:14];
    self.descriptionLabel.text = description;
    [self.descriptionLabel sizeToFit];
    self.descriptionLabel.frame = CGRectMake(10, self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, self.descriptionLabel.frame.size.height);
    [self addSubview:self.descriptionLabel];
    self.descriptionLabel.backgroundColor = [UIColor purpleColor];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.descriptionLabel.frame.size.height + self.descriptionLabel.frame.origin. y + 10);
    self.backgroundColor = [UIColor redColor];
    
    
    return self;
}

@end
