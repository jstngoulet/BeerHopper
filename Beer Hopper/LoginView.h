//
//  LoginView.h
//  Crony
//
//  Created by Justin Goulet on 2/16/16.
//  Copyright © 2016 Justin Goulet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CronyCount.h"
//#import "Alert.h"

@interface LoginView : UIView <UITextFieldDelegate>
{
}
@property (nonatomic) UITextField *userNameField, *passwordField;
@property (nonatomic) UIImageView *backgroundImage;
@property (nonatomic) UIButton *loginButton, *createAccountButton;
@property (nonatomic) UILabel *errorLabel, *titleLabel, *tempLabel;
@property (nonatomic) NSString *userName;
@property (nonatomic) SEL currentAction;

-(void)dismiss;
-(void)build;
-(id)initWithFrame:(CGRect)frame sendToLabel:(UILabel *)label refreshSelector:(SEL)action;

@end
