//
//  LoginView.m
//  Crony
//
//  Created by Justin Goulet on 2/16/16.
//  Copyright © 2016 Justin Goulet. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

-(id)initWithFrame:(CGRect)frame sendToLabel:(UILabel *)label refreshSelector:(SEL)action{
    self = [super initWithFrame:frame];
    if (self) {
        //Do stuff
        self.backgroundColor = [UIColor whiteColor];
        
        //[self build];
        self.tempLabel = label;
        self.currentAction = action;
    }
    return self;
}

-(void)build{
    
    //Build the UI
    self.backgroundImage = [[UIImageView alloc] initWithFrame:self.frame];
    self.backgroundImage.image = [UIImage imageNamed:@"Crony Image.jpg"];
    [self.backgroundImage setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:self.backgroundImage];
    
    self.userNameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width*.75, 50)];
    self.userNameField.placeholder = @"User Name";
    self.userNameField.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/4);
    [self addSubview:self.userNameField];
    self.userNameField.layer.borderWidth = 1;
    self.userNameField.backgroundColor = [UIColor lightGrayColor];
    self.userNameField.alpha = .75;
    self.userNameField.layer.masksToBounds = YES;
    self.userNameField.layer.cornerRadius = 15;
    self.userNameField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.userNameField.textColor = [UIColor whiteColor];
    self.userNameField.font = [UIFont boldSystemFontOfSize:22];
    
    
    self.passwordField = [[UITextField alloc] initWithFrame:self.userNameField.frame];
    self.passwordField.placeholder = @"Password";
    self.passwordField.secureTextEntry = YES;
    self.passwordField.center = CGPointMake(self.userNameField.center.x, self.userNameField.center.y + self.userNameField.frame.size.height*1.5);
    [self addSubview:self.passwordField];
    self.passwordField.layer.borderWidth = 1;
    self.passwordField.backgroundColor = self.userNameField.backgroundColor;
    self.passwordField.alpha = self.userNameField.alpha;
    self.passwordField.layer.masksToBounds = YES;
    self.passwordField.layer.cornerRadius = self.userNameField.layer.cornerRadius;
    self.passwordField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.passwordField.textColor = [UIColor whiteColor];
    self.passwordField.font = self.userNameField.font;
    
    //Make it CGRectMake(0, 0, self.passwordField.frame.size.width/2.5, self.passwordField.frame.size.height) with login button
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2.5, self.passwordField.frame.size.height)];
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius = self.loginButton.frame.size.height/2;
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.loginButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Gold.png"]]];
    //self.loginButton.center = CGPointMake(self.passwordField.frame.size.width/3 + self.passwordField.frame.origin.x/2, self.passwordField.center.y + self.passwordField.frame.size.height * 1.5);
    self.loginButton.center = CGPointMake(self.frame.size.width/2, self.passwordField.center.y + self.passwordField.frame.size.height * 1.5);
    [self addSubview:self.loginButton];
    [self.titleLabel setFont:self.passwordField.font];
    self.loginButton.tag = 1;
    
    self.createAccountButton = [[UIButton alloc] initWithFrame:self.loginButton.frame];
    self.createAccountButton.layer.masksToBounds = YES;
    self.createAccountButton.layer.cornerRadius = self.loginButton.layer.cornerRadius;
    [self.createAccountButton.titleLabel setFont:self.loginButton.titleLabel.font];
    [self.createAccountButton setBackgroundColor:self.loginButton.backgroundColor];
    self.createAccountButton.center = CGPointMake(self.loginButton.center.x + self.passwordField.frame.size.width/3 * 1.5, self.loginButton.center.y);
    [self.createAccountButton setTitle:@"Join" forState:UIControlStateNormal];
    //[self addSubview:self.createAccountButton];
    self.createAccountButton.tag = 1;
    
    [self.loginButton addTarget:self action:@selector(checkAuthentication) forControlEvents:UIControlEventTouchUpInside];
    [self.createAccountButton addTarget:self action:@selector(createAccount) forControlEvents:UIControlEventTouchUpInside];
    
    self.errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.passwordField.frame.size.width, self.frame.size.height/2)];
    self.errorLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.errorLabel];
    self.errorLabel.font = [UIFont boldSystemFontOfSize:18];
    self.errorLabel.backgroundColor = self.passwordField.backgroundColor;
    self.errorLabel.layer.masksToBounds = YES;
    self.errorLabel.alpha = .75;
    self.errorLabel.textColor = [UIColor redColor];
    [self updateWarningLabel:@"Welcome to Crony!\n\nIf you have an account, just sign in here!\n\nIf you don't, create a user name and password to login now!"];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.userNameField.frame.origin.y)];
    self.titleLabel.text = @"Crony";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"SignPainter" size:72];
    [self.titleLabel adjustsFontSizeToFitWidth];
    self.titleLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Gold.png"]];
    [self addSubview:self.titleLabel];
    
}

/**
 *  Creates an account in our system. upon success, it alos logs the user in.
 */
-(void)createAccount{
    //Add an alert to see if the user wants to create an account with the provided information
    if(self.userNameField.text.length > 0 && self.passwordField.text.length > 0){
        /*
        Alert *createAccountAlert = [[Alert alloc] initWithTitle:@"Create Account?" text:@"We were unable to process your credentials. \n\nWould you like to create an account with this information? \n\nNOTE - None of your previous account information carries over." closeBtnTitle:@"No" customBtnTitle:@"Yes" withAction:@selector(addUser) fromClass:self];
        [createAccountAlert show];*/
    }
    else
        self.errorLabel.text = @"Please input credentials";
}

-(void)addUser{
    CronyCount *createCrony = [[CronyCount alloc] init];
    [createCrony CreateAccountUsingUser:self.userNameField.text password:self.passwordField.text errorLabel:self.errorLabel];
}

-(void)dismiss{
    //[self removeFromSuperview];
    [self.passwordField resignFirstResponder];
    [self.userNameField resignFirstResponder];
    self.userName = self.userNameField.text;
    self.tempLabel.text =  [NSString stringWithFormat:@"Welcome Back, %@!", self.userName];
    [self currentAction];
    self.hidden = YES;
    
}

-(void)updateWarningLabel:(NSString *)newText{
    
    self.errorLabel.text = newText;
    self.errorLabel.numberOfLines = 0;
    [self.errorLabel sizeToFit];
    self.errorLabel.frame = CGRectMake(0, 0, self.passwordField.frame.size.width, self.errorLabel.frame.size.height + 30);
    self.errorLabel.center = CGPointMake(self.frame.size.width/2, self.loginButton.center.y + self.loginButton.frame.size.height + self.errorLabel.frame.size.height/2);
    self.errorLabel.layer.cornerRadius = 15;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"Done Editing");
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
    return YES;
}


-(void)checkAuthentication{
    NSLog(@"I am loggin you in");
    [self updateWarningLabel:@"I am logging you in.."];
    
    NSString *tempQuery = [NSString stringWithFormat:@"http://api.crony.me:3000/api/Cronies/login"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:tempQuery]];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSString *cred = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\"}", self.userNameField.text, self.passwordField.text];
    NSData *requestBodyData = [cred dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    //Get crony info
    CronyCount *myCrony = [[CronyCount alloc] init];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
          //NSLog(@"Request: %@" , searchRequest.URL);
          
          if (!error && httpResponse.statusCode == 200) {
              
              NSDictionary *searchResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
              NSLog(@"Desc: %@", searchResponseJSON.description);
              
              [[NSUserDefaults standardUserDefaults] setObject:searchResponseJSON forKey:@"testKey"];
              //found = YES;
              [self performSelectorOnMainThread:@selector(dismiss) withObject:NULL waitUntilDone:YES];
              [myCrony performSelectorOnMainThread:@selector(getCronyInfo) withObject:NULL waitUntilDone:YES];
              
          }
          else
          {
              NSDictionary *searchResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
              NSLog(@"Error: %@", searchResponseJSON);
              [self performSelectorOnMainThread:@selector(updateWarningLabel:) withObject:searchResponseJSON[@"error"][@"message"] waitUntilDone:NO];
              
              
              //Create account with information
              [self performSelectorOnMainThread:@selector(createAccount) withObject:nil waitUntilDone:YES];
              //[self createAccount];
              //[self performSelectorOnMainThread:@selector(checkAuthentication) withObject:nil waitUntilDone:YES];
          }
      }]
     resume];
}

@end
