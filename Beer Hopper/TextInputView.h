//
//  TextInputView.h
//  Beer Hopper
//
//  Created by Justin Goulet on 6/7/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextInputView : UIView <UITextFieldDelegate, UITextViewDelegate>


//Going to have a back view for a shadow, a main view to be rounded, a view for a title (if applicable) and a view for a message. Also, it will have a send button, a black background that will hide the rest of the view and a line seperating the title and message views
@property (strong, nonatomic) UITextField *title;
@property (strong, nonatomic) UITextView *mainMessage;
@property (strong, nonatomic) UIViewController *parentViewController;
@property (strong, nonatomic) UIView *bckView, *mainView, *blackBackgroundView;
@property (strong, nonatomic) UIButton *sendBtn, *closeBtn;
@property (strong, nonatomic) UILabel *line;
@property (strong, nonatomic) NSString *placeholderText;

@property (nonatomic) BOOL animatesIn, animatesOut;
@property (nonatomic) float animationSpeed;

-(void)show;
-(void)hide;



@end
