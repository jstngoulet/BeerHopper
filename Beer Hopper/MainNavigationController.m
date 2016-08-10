//
//  MainNavigationController.m
//  Beer Hopper
//
//  Created by Justin Goulet on 1/13/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "MainNavigationController.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController

-(BOOL)prefersStatusBarHidden{return YES;}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add this if you only want to change Selected Image color
    // and/or selected image text
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:1.000 green:0.573 blue:0.361 alpha:1.00]];
    [self setSelectedIndex:2];
    
    // Add this code to change StateNormal text Color,
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [UIColor whiteColor]}
                                           forState:UIControlStateNormal];
    
    // then if StateSelected should be different, you should add this code
    /*[UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [UIColor purpleColor]}
                                           forState:UIControlStateSelected];*/
    int i = 0;
    for (UITabBarItem *item in self.tabBar.items) {
        //NSLog(@"Title: %@", item.title);
        switch (i) {
            case 0:
                item.image = [[UIImage imageNamed:@"Star"]
                                      imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                item.selectedImage = [[UIImage imageNamed:@"Star (Filled)"]
                              imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                break;
                
            case 1:
                item.image = [[UIImage imageNamed:@"Routes"]
                                      imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                item.selectedImage = [[UIImage imageNamed:@"Routes (Filled)"]
                              imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                item.title = @"Liked";
                break;
                
            case 2:
                item.image = [[UIImage imageNamed:@"Home2Empty"]
                                      imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                item.selectedImage = [[UIImage imageNamed:@"Home2"]
                              imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                break;
                
            case 3:
                item.image = [[UIImage imageNamed:@"Forums"]
                                      imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                item.selectedImage = [[UIImage imageNamed:@"Forums (Filled)"]
                              imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                break;
                
            case 4:
                item.image = [[UIImage imageNamed:@"Star"]
                              imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                item.selectedImage = [[UIImage imageNamed:@"Star (Filled)"]
                                      imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                /*
                item.image = [[UIImage imageNamed:@"New"]
                                      imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                item.selectedImage = [[UIImage imageNamed:@"New (Filled)"]
                              imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                 */
                break;
                
            default:
                break;
        }
        i++;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goHome{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
