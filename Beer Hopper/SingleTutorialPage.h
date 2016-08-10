//
//  SingleTutorialPage.h
//  Beer Hopper
//
//  Created by Justin Goulet on 6/22/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ImageButton.h"

@interface SingleTutorialPage : UIView <UITextFieldDelegate>{
    
    
}

@property (nonatomic, strong) UIImage *primaryImage;
@property (nonatomic) NSString *title, *mainDescription, *viewType;
@property (nonatomic, strong) ImageButton *nextButton;
@property (nonatomic, strong) UIColor *mainBackgroundColor;
@property (nonatomic, strong) UIViewController *parentViewController;
@property (nonatomic) float imageHeight;
@property (nonatomic, strong) UITextField *mainText;
@property (nonatomic) BOOL isAddingEmail, isAddingAlias;

-(id)initWithFrame:(CGRect)frame type:(NSString *)kViewType;
-(void)build;

@end
