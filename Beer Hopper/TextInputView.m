//
//  TextInputView.m
//  Beer Hopper
//
//  Created by Justin Goulet on 6/7/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "TextInputView.h"

@implementation TextInputView

//Inits with rootviewcontroller Frame
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    [self build];
    
    return self;
}

-(void)build{
    
    //Add back black view
    self.blackBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.blackBackgroundView.backgroundColor = [UIColor blackColor];
    self.blackBackgroundView.alpha = 0;
    [self addSubview:self.blackBackgroundView];
    
    //Add main view (this one is rounded)
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width*.75, self.frame.size.height/3)];
    self.mainView.backgroundColor = [UIColor whiteColor];
    self.mainView.layer.masksToBounds = YES;
    self.mainView.layer.cornerRadius = 10;
    [self addSubview:self.mainView];
    self.mainView.center = CGPointMake(self.frame.size.width/2, self.mainView.frame.size.height);
    
    //Add bck view (this one is for the shadow)
    self.bckView = [[UIView alloc] initWithFrame:self.mainView.frame];
    [self insertSubview:self.bckView atIndex:1];
    
    //Add in the cancel and send buttons
    self.closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, self.mainView.frame.size.width/8.5, self.mainView.frame.size.width/8.5)];
    self.closeBtn.layer.masksToBounds = YES;
    self.closeBtn.layer.cornerRadius = self.closeBtn.frame.size.height/2;
    self.closeBtn.backgroundColor = [UIColor colorWithRed:0.306 green:0.416 blue:0.471 alpha:1.00];
    [self.mainView addSubview:self.closeBtn];
    //[self.closeBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn setTitle:@"X" forState:UIControlStateNormal];
    self.closeBtn.showsTouchWhenHighlighted = YES;
    
    self.sendBtn = [[UIButton alloc] initWithFrame:self.closeBtn.frame];
    self.sendBtn.layer.masksToBounds = YES;
    self.sendBtn.layer.cornerRadius = self.closeBtn.frame.size.height/2;
    self.sendBtn.backgroundColor = [UIColor colorWithRed:0.306 green:0.416 blue:0.471 alpha:1.00];
    [self.mainView addSubview:self.sendBtn];
    [self.sendBtn setBackgroundImage:[UIImage imageNamed:@"Submit_WithBorder.png"] forState:UIControlStateNormal];
    [self.sendBtn setBackgroundImage:[UIImage imageNamed:@"Submit_WithBorder_Disabled.png"] forState:UIControlStateDisabled];
    self.sendBtn.center = CGPointMake(self.mainView.frame.size.width - 10 - self.sendBtn.frame.size.width/2, self.sendBtn.center.y);
    [self.sendBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    self.sendBtn.showsTouchWhenHighlighted = YES;
    
    self.title = [[UITextField alloc] initWithFrame:CGRectMake(self.closeBtn.frame.origin.x * 2 + self.closeBtn.frame.size.width, self.sendBtn.frame.origin.y, self.mainView.frame.size.width - (self.closeBtn.frame.origin.x * 2 + self.closeBtn.frame.size.width)*2, self.sendBtn.frame.size.height)];
    [self.mainView addSubview:self.title];
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.delegate = self;
    
    self.mainMessage = [[UITextView alloc] initWithFrame:CGRectMake(10, self.title.frame.origin.y*2 + self.title.frame.size.height, self.mainView.frame.size.width - 20, self.mainView.frame.size.height - (self.title.frame.origin.y*2 + self.title.frame.size.height) - 10)];
    //self.mainMessage.backgroundColor = [UIColor redColor];
    [self.mainView addSubview:self.mainMessage];
    self.mainMessage.delegate = self;
    self.mainMessage.keyboardType = UIKeyboardTypeTwitter | UIKeyboardAppearanceDark;
    self.mainMessage.font = [UIFont systemFontOfSize:14];
    
    self.mainView.center = CGPointMake(self.center.x + self.frame.size.width*2, self.mainView.center.y);
}

-(void)show{
    if(self.animatesIn){
        [UIView animateWithDuration:self.animationSpeed animations:^{
            self.mainView.center = CGPointMake(self.mainView.center.x - self.frame.size.width*2, self.mainView.center.y);
            self.blackBackgroundView.alpha = .3;
            [self.mainView bringSubviewToFront:self.closeBtn];
        }];
    }
    else{
        self.mainView.center = CGPointMake(self.mainView.center.x - self.frame.size.width*2, self.mainView.center.y);
    }
    
    self.title.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholderText attributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont boldSystemFontOfSize:16]}];
    if(self.title.enabled) [self.title becomeFirstResponder];
    else [self.mainMessage becomeFirstResponder];
}

-(void)hide{
    //NSLog(@"Hiding");
    if(self.animatesOut){
        [UIView animateWithDuration:self.animationSpeed animations:^{
            self.mainView.center = CGPointMake( - self.frame.size.width*2, self.mainView.center.y);
            self.blackBackgroundView.alpha = 0;
        }completion:^(BOOL fin){if(fin)self.hidden = YES;}];
    }
    else{
        self.mainView.center = CGPointMake(self.mainView.center.x - self.frame.size.width*2, self.mainView.center.y);
        self.blackBackgroundView.alpha = 0;
        self.hidden = YES;
    }
    [self.title resignFirstResponder];
    [self.mainMessage resignFirstResponder];
}


//Delegate stuff
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [textView becomeFirstResponder];
}

@end
