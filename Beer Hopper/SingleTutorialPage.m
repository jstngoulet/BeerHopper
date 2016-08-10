//
//  SingleTutorialPage.m
//  Beer Hopper
//
//  Created by Justin Goulet on 6/22/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "SingleTutorialPage.h"

@implementation SingleTutorialPage

-(id)initWithFrame:(CGRect)frame type:(NSString *)kViewType{
    
    self = [super initWithFrame:frame];
    
    if (kViewType == kViewTypeHeader) {
        self.imageHeight = self.frame.size.height/4 * 2.5;
    }
    if (kViewType == kViewTypeContent || kViewType == kViewTypeTextField){
        self.imageHeight = self.frame.size.height/4;
    }
    
    self.viewType = kViewType;
    
    return self;
    
}

-(void)build{
    //NSLog(@"Building View");
    //Build the frame, starting with the image
    UIImageView *mainImageFrame = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.imageHeight)];
    mainImageFrame.backgroundColor = self.mainBackgroundColor;
    mainImageFrame.image = self.primaryImage;
    mainImageFrame.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:mainImageFrame];
    
    self.nextButton = [[ImageButton alloc] initWithFrame:CGRectMake(0, mainImageFrame.frame.size.height, self.frame.size.width, self.frame.size.height/5)];
    self.nextButton.primaryTitle.text = @"Start";
    [self alterButton:self.nextButton];
    [self addSubview:self.nextButton];
    self.nextButton.center = CGPointMake(self.nextButton.center.x, self.frame.size.height - self.nextButton.frame.size.height);
    
    //Now, add the title and text, if the content type is "Content"
    if (self.viewType == kViewTypeContent | self.viewType == kViewTypeTextField) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, self.imageHeight + 10, self.frame.size.width - 50, self.imageHeight/5)];
        titleLabel.text = self.title;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:titleLabel];
        
        if(self.viewType == kViewTypeContent){
            UILabel *mainDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleLabel.frame.size.width, self.frame.size.height - mainImageFrame.frame.size.height - titleLabel.frame.size.height - 10 - self.nextButton.frame.size.height - (self.frame.size.height - self.nextButton.frame.size.height))];
            [self addSubview:mainDescriptionLabel];
            mainDescriptionLabel.center = CGPointMake(self.frame.size.width/2, (titleLabel.frame.origin.y + titleLabel.frame.size.height + self.nextButton.frame.origin.y) / 2);
            mainDescriptionLabel.text = self.mainDescription;
            mainDescriptionLabel.textAlignment = NSTextAlignmentCenter;
            mainDescriptionLabel.numberOfLines = 0;
            mainDescriptionLabel.font = [UIFont systemFontOfSize:24];
            mainDescriptionLabel.adjustsFontSizeToFitWidth = YES;
        }
        else if(self.viewType == kViewTypeTextField){
            self.mainText = [[UITextField alloc] initWithFrame:titleLabel.frame];
            self.mainText.delegate = self;
            [self addSubview:self.mainText];
            self.mainText.center = CGPointMake(self.frame.size.width/2, titleLabel.frame.size.height + titleLabel.frame.origin.y + 30);
            self.mainText.backgroundColor = self.mainBackgroundColor;
            [self.mainText becomeFirstResponder];
            self.mainText.textColor = [UIColor whiteColor];
            self.mainText.textAlignment = NSTextAlignmentCenter;
            
            if(self.isAddingEmail){
                self.mainText.placeholder = @"Email";
                self.mainText.keyboardType = UIKeyboardTypeEmailAddress;
            }
            if (self.isAddingAlias) {
                self.mainText.placeholder = @"Alias";
                self.mainText.keyboardType = UIKeyboardTypeNamePhonePad;
            }
            
            //Add the description underneath it
            UILabel *mainDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, self.mainText.frame.origin.y + self.mainText.frame.size.height + 10, self.mainText.frame.size.width, self.mainText.frame.size.height * 3)];
            mainDescriptionLabel.text = self.mainDescription;
            mainDescriptionLabel.textAlignment = NSTextAlignmentCenter;
            mainDescriptionLabel.numberOfLines = 0;
            mainDescriptionLabel.font = [UIFont systemFontOfSize:24];
            mainDescriptionLabel.adjustsFontSizeToFitWidth = YES;
            [self addSubview:mainDescriptionLabel];
        }
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length == 0) {
        //Disable the current butons
        self.nextButton.primaryButton.enabled = NO;
    }
    else{
        self.nextButton.primaryButton.enabled = YES;
    }
}

-(void)alterButton:(ImageButton *)temp{
    temp.bckView.backgroundColor = [UIColor colorWithRed:0.306 green:0.416 blue:0.471 alpha:1.00];
    temp.mainImageView.backgroundColor = [UIColor colorWithRed:0.306 green:0.416 blue:0.471 alpha:1.00];
    temp.mainImageView.layer.masksToBounds = YES;
    temp.mainImageView.layer.cornerRadius = temp.mainImageView.frame.size.height/2;
    temp.bckView.layer.masksToBounds = YES;
    temp.bckView.layer.cornerRadius = temp.bckView.frame.size.height/2;
    temp.bckView.backgroundColor = temp.mainImageView.backgroundColor;;
    temp.enabled = YES;
    temp.primaryButton.showsTouchWhenHighlighted = YES;
    
    //Show the shadow
    
}



@end
