//
//  CollapseableView.m
//  Beer Hopper
//
//  Created by Justin Goulet on 8/19/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "CollapseableView.h"

@implementation CollapseableView

- (void)addContent:(UIView *)view{
    
    UIView *mainBubble = [[UIView alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width - 20, 40)];
    //mainBubble.layer.masksToBounds = YES;
    mainBubble.backgroundColor = [UIColor whiteColor];
    mainBubble.layer.cornerRadius = mainBubble.frame.size.height/2;
    [self addSubview:mainBubble];
    
    //Add the shadow
    //UIView *shadowView = [[UIView alloc] initWithFrame:mainBubble.frame];
    [self addShadowToView:mainBubble];
    //[self insertSubview:shadowView belowSubview:mainBubble];
    
    //Add the arrow to the previous view
    self.arrow = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, mainBubble.frame.size.height/2, mainBubble.frame.size.height/2)];
    [self.arrow setBackgroundImage: [UIImage imageNamed:@"Arrow2.png"] forState:UIControlStateNormal];
    [mainBubble addSubview:self.arrow];
    self.arrow.center = CGPointMake(self.arrow.center.x, mainBubble.frame.size.height/2);
    
    //Add the action so when the button is tapped, something happens
    [self.arrow addTarget:self action:@selector(collapseView) forControlEvents:UIControlEventTouchUpInside];
    
    //Now, add the title text
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(self.arrow.frame.origin.x*2 + self.arrow.frame.size.width, 0, mainBubble.frame.size.width - (self.arrow.frame.origin.x*3 + self.arrow.frame.size.width), mainBubble.frame.size.height)];
    header.text = self.title;
    [mainBubble addSubview:header];
    
        //self.offset += aboutText.frame.size.height + 10;
    
    //Adjust the self height
    //self.frame = CGRectMake(0, 0, self.frame.size.width, aboutText.frame.origin.y + aboutText.frame.size.height);
    
    //Add subview
    [self addSubview:view];
    view.frame = CGRectMake(0, 0, mainBubble.frame.size.width - 10, view.frame.size.height);
    view.center = CGPointMake(self.frame.size.width/2, mainBubble.frame.origin.y * 2 + mainBubble.frame.size.height + view.frame.size.height/2);
    //view.layer.masksToBounds = YES;
    
    self.frame = CGRectMake(10, self.frame.origin.y, self.frame.size.width, view.frame.origin.y + view.frame.size.height + 5);
    
    self.minHeight = mainBubble.frame.origin.y*2 + mainBubble.frame.size.height;
    self.maxHeight = self.frame.size.height;
    self.miniView = view;
    //self.miniView.layer.masksToBounds = YES;
    isOpen = YES;
    originalHeight = self.miniView.frame;
    
    self.tag = -5;
    
    
}

-(void)updateFrameSize{
    NSLog(@"Fixing");
}

-(void)addShadowToView:(UIView *)v{
    // border radius
    [v.layer setCornerRadius:v.frame.size.height/2];
    
    // border
    [v.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [v.layer setBorderWidth:1.5f];
    
    // drop shadow
    [v.layer setShadowColor:[UIColor blackColor].CGColor];
    [v.layer setShadowOpacity:0.8];
    [v.layer setShadowRadius:3.0];
    [v.layer setShadowOffset:CGSizeMake(0, 2.0)];
}

-(void)collapseView{
    //Sets the view to be the min view size
    NSLog(@"isOpen: %i", isOpen);
    float anim = .5f;
    
    if(isOpen){
        //If the view is open, close it
        [UIView animateWithDuration:anim animations:^{
            self.miniView.frame = CGRectMake(self.miniView.frame.origin.x, self.miniView.frame.origin.y, self.miniView.frame.size.width, 0);
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.minHeight);
            self.layer.masksToBounds = YES;
            
            //Make the arror point to the right
            self.arrow.transform = CGAffineTransformMakeRotation(0);
        }];
    }
    else{
        //If the view is closed, open it
        [UIView animateWithDuration:anim animations:^{
            self.miniView.frame = originalHeight;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.maxHeight);
            self.layer.masksToBounds = NO;
            //self.miniView.backgroundColor = [UIColor redColor];
            
            self.arrow.transform = CGAffineTransformMakeRotation(M_PI/2);
        }];
    }
    
    isOpen = !isOpen;
}



@end
