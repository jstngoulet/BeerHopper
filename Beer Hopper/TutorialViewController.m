//
//  TutorialViewController.m
//  Beer Hopper
//
//  Created by Justin Goulet on 6/22/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

-(BOOL)prefersStatusBarHidden{return YES;}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prefersStatusBarHidden];
    // Do any additional setup after loading the view.
    
    //Create the main tutorial
    MainTutorial *tut = [[MainTutorial alloc] initWithFrame:self.view.frame];
    tut.mainColor = [UIColor colorWithRed:0.306 green:0.416 blue:0.471 alpha:1.00];
    tut.headerImage = [UIImage imageNamed:@"Beer_Hopper_Banner.png"];
    [self.view addSubview:tut];
    [tut build];
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
