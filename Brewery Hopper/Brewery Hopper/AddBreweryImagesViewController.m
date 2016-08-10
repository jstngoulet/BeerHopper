//
//  AddBreweryImagesViewController.m
//  Brewery Hopper
//
//  Created by Justin Goulet on 5/31/16.
//  Copyright © 2016 Justin Goulet. All rights reserved.
//

#import "AddBreweryImagesViewController.h"

@interface AddBreweryImagesViewController ()

@end

@implementation AddBreweryImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Add the two buttons
    self.coverImageSelect = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, self.mainView.frame.size.width/3, self.mainView.frame.size.width/3)];
    self.coverImageSelect.primaryTitle.text = @"Choose Cover Image";
    [self.mainView addSubview:self.coverImageSelect];
    
    self.profileImageSelect = [[ImageButton alloc] initWithFrame:self.coverImageSelect.frame];
    self.profileImageSelect.primaryTitle.text = @"Choose Brewery Logo";
    [self.mainView addSubview:self.profileImageSelect];
    
    //Change centers
    self.coverImageSelect.center = CGPointMake(self.mainView.frame.size.width/4, self.mainView.frame.size.height/2);
    self.profileImageSelect.center = CGPointMake(self.mainView.frame.size.width/4 * 3, self.coverImageSelect.center.y);
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
