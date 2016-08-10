//
//  Routes.m
//  Beer Hopper
//
//  Created by Justin Goulet on 1/13/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "Routes.h"

@implementation Routes
-(BOOL)prefersStatusBarHidden{return YES;}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(50, 0, self.navigationBar.frame.size.width/10, self.navigationBar.frame.size.height)];
    logo.image = [UIImage imageNamed:@"Beer_Hopper_Banner.png"];
    [logo setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationBar.topItem.titleView = logo;
}


@end
