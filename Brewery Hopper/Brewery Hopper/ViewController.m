//
//  ViewController.m
//  Brewery Hopper
//
//  Created by Justin Goulet on 5/31/16.
//  Copyright © 2016 Justin Goulet. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //If first time opening the application
    //Show the two primary buttons (Claim existing and create new);
    self.claim = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, self.mainSubview.frame.size.width/3.5, self.mainSubview.frame.size.width/3.5)];
    self.claim.primaryTitle.text = @"Claim Existing";
    [self.claim addTarget:self action:@selector(advance:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainSubview addSubview:self.claim];
    
    self.create = [[ImageButton alloc] initWithFrame:self.claim.frame];
    self.create.primaryTitle.text = @"Create New";
    [self.create addTarget:self action:@selector(advance:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainSubview addSubview:self.create];
    
    //Adjust the centers
    self.claim.center = CGPointMake(self.mainSubview.frame.size.width/4, self.mainSubview.frame.size.height/2);
    self.create.center = CGPointMake(self.mainSubview.frame.size.width/4 * 3, self.claim.center.y);
    
}

-(IBAction)advance:(id)sender{
    ImageButton *temp = (ImageButton *)sender;
    
    if ([temp.primaryTitle.text isEqualToString:@"Claim Existing"]) {
        NSLog(@"Advancing to Claim Existing");
    }
    else if ([temp.primaryTitle.text isEqualToString:@"Create New"]){
        NSLog(@"Advancing to Create New");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
