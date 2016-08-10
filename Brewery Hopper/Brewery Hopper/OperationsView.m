//
//  OperationsView.m
//  Brewery Hopper
//
//  Created by Justin Goulet on 5/31/16.
//  Copyright © 2016 Justin Goulet. All rights reserved.
//

#import "OperationsView.h"

@implementation OperationsView

-(id)init{
    self = [super init];
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self build];
    return self;
}

-(void)build{
    //Create header label
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, 50)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    //self.titleLabel.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.titleLabel];
    
    self.beerManager = [self addImageButtonWithTitle:@"Beers"];
    [self addSubview:self.beerManager];
    self.beerManager.center = CGPointMake(self.frame.size.width/4, 25 + self.beerManager.frame.size.height/2 + self.titleLabel.frame.size.height);
    
    self.eventManager = [self addImageButtonWithTitle:@"Events"];
    [self addSubview:self.eventManager];
    self.eventManager.center = CGPointMake(self.frame.size.width/4 * 3, self.beerManager.center.y);
    
    self.breweryManager = [self addImageButtonWithTitle:@"Breweries"];
    [self addSubview:self.breweryManager];
    self.breweryManager.center = CGPointMake(self.beerManager.center.x, self.beerManager.center.y + self.breweryManager.frame.size.height);
    
    self.feedBackManager = [self addImageButtonWithTitle:@"Feedback"];
    [self addSubview:self.feedBackManager];
    self.feedBackManager.center = CGPointMake(self.eventManager.center.x, self.breweryManager.center.y);
}

-(ImageButton *)addImageButtonWithTitle:(NSString *)title{
    ImageButton *temp = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.width/2)];
    temp.primaryTitle.text = title;
    return temp;
}

@end
