//
//  Home.m
//  Beer Hopper
//
//  Created by Justin Goulet on 1/13/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "Home.h"
//

@interface Home ()

@end

@implementation Home
-(BOOL)prefersStatusBarHidden{return YES;}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(50, 0, self.navigationBar.frame.size.width/10, self.navigationBar.frame.size.height)];
    logo.image = [UIImage imageNamed:@"Beer_Hopper_Banner.png"];
    [logo setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationBar.topItem.titleView = logo;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
