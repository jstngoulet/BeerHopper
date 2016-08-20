//
//  CustomTableView.m
//  Beer Hopper
//
//  Created by Justin Goulet on 4/11/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "CustomTableView.h"

@implementation CustomTableView

#define METERS_PER_MILE 1609.344

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    myData = [[HopperData alloc] init];
    return self;
}

-(void)addRow:(NSString *)title info:(NSString *)description{
    
    //Create the container view
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, self.offset, self.frame.size.width, self.frame.size.height/5)];
    
    //Now, add the title (1/3 the width)
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, container.frame.size.width/3 - 10, container.frame.size.height - 10)];
    titleLabel.numberOfLines = 0;
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.textAlignment = NSTextAlignmentRight;
    //titleLabel.backgroundColor = [UIColor blueColor];
    [titleLabel sizeToFit];
    
    //Add the content
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.size.width + 50, 10, container.frame.size.width - titleLabel.frame.size.width - 50, titleLabel.frame.size.height)];
    descriptionLabel.text = description;
    descriptionLabel.textAlignment = NSTextAlignmentLeft;
    descriptionLabel.font = [UIFont systemFontOfSize:14];
    [descriptionLabel adjustsFontSizeToFitWidth];
    descriptionLabel.numberOfLines = 0;
    [descriptionLabel sizeToFit];
    //descriptionLabel.backgroundColor = [UIColor redColor];
    
    //Set the title label to be the same height as the description
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, descriptionLabel.frame.origin.y, container.frame.size.width/3 - 10, (descriptionLabel.frame.size.height >= titleLabel.frame.size.height) ? descriptionLabel.frame.size.height + 10 : titleLabel.frame.size.height + 10);
    descriptionLabel.frame = CGRectMake(titleLabel.frame.origin.x*4 + titleLabel.frame.size.width, descriptionLabel.frame.origin.y, descriptionLabel.frame.size.width, descriptionLabel.frame.size.height);
    
    [container addSubview:titleLabel];
    [container addSubview:descriptionLabel];
    
    container.frame = CGRectMake(0, self.offset, self.frame.size.width, (descriptionLabel.frame.size.height >= titleLabel.frame.size.height) ? descriptionLabel.frame.size.height + 5 : titleLabel.frame.size.height + 5);
    
    //Adjust the center of the description label if the title is larger
    if ((descriptionLabel.frame.size.height <= titleLabel.frame.size.height)) {
        descriptionLabel.center = CGPointMake(descriptionLabel.center.x, titleLabel.center.y);
    }
    
    self.offset += container.frame.size.height;
    [self addSubview:container];
    [self updateSize];
    
    //return container;
    
}

-(void)addRatingSystemWithScale:(NSRange)range title:(NSString *)titleOfSection helpText:(NSString *)help submissionURl:(NSURL *)sendingPlace{
    
    //Increase the offset a little
    self.offset += 10;
    
    //Add the collapseable view
    CollapseableView *thisView = [[CollapseableView alloc] initWithFrame:CGRectMake(10, self.offset, self.frame.size.width - 20, self.frame.size.height)];
    thisView.title = titleOfSection;
    [self addSubview:thisView];
    
    //Create a container
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, self.offset, self.frame.size.width - 40, self.frame.size.height/5)];
    //container.backgroundColor = [UIColor yellowColor];
    
    
    //Add a label
    //Now, add the title (1/3 the width)
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, container.frame.size.width/3 - 10, container.frame.size.height - 10)];
    titleLabel.numberOfLines = 0;
    //titleLabel.text = titleOfSection;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.textAlignment = NSTextAlignmentRight;
    //titleLabel.backgroundColor = [UIColor blueColor];
    [titleLabel sizeToFit];
    [container addSubview:titleLabel];
    
    //HElp text
    UILabel *helpText = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLabel.frame.origin.y*2 + titleLabel.frame.size.height, self.frame.size.width - 20, self.frame.size.height)];
    helpText.numberOfLines = 0;
    helpText.text = help;
    helpText.textAlignment = NSTextAlignmentCenter;
    helpText.font = [UIFont systemFontOfSize:14];
    [helpText sizeToFit];
    [container addSubview:helpText];
    helpText.frame = CGRectMake(0, 0, container.frame.size.width - 20, helpText.frame.size.height);
    helpText.center = CGPointMake(container.frame.size.width/2, titleLabel.frame.origin.y*2 + titleLabel.frame.size.height + helpText.frame.size.height/2);
    
    //Add the rating slider
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(container.frame.size.width/3 * 2, helpText.frame.origin.y + helpText.frame.size.height, container.frame.size.width/3 * 2, container.frame.size.height/2)];
    slider.center = CGPointMake(container.frame.size.width/2, slider.center.y);
    slider.tintColor = [UIColor colorWithRed:0.380 green:0.490 blue:0.541 alpha:1.00];
    slider.minimumValue = range.location;
    slider.maximumValue = range.length;
    slider.value = 7.5;
    [container addSubview:slider];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventAllTouchEvents];
    
    //Add the min and max values to each side of the slider
    UILabel *minValueLabel = [self addLabelWithTitle:[NSString stringWithFormat:@"%i", (int)slider.minimumValue]];
    [container addSubview:minValueLabel];
    [minValueLabel sizeToFit];
    
    UILabel *maxValueLabel = [self addLabelWithTitle:[NSString stringWithFormat:@"%i", (int)slider.maximumValue]];
    [container addSubview:maxValueLabel];
    [maxValueLabel sizeToFit];
    
    UILabel *currentValue = [self addLabelWithTitle:[NSString stringWithFormat:@"%i", (int)slider.value]];
    [container addSubview:currentValue];
    currentValue.center = CGPointMake(container.frame.size.width/2, slider.frame.origin.y + slider.frame.size.height + currentValue.frame.size.height/2);
    currentValue.font = [UIFont boldSystemFontOfSize:16];
    currentLabel = currentValue;
    
    //Add submission button and addComment button
    submit = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, container.frame.size.width/2, container.frame.size.width/4)];
    submit.primaryTitle.text = @"Submit";
    [container addSubview:submit];
    submit.mainImageView.image = [UIImage imageNamed:@"Submit.png"];
    submit.disabledImage = [UIImage imageNamed:@"Submit_Disabled.png"];
    [self alterButton:submit];
    
    if([self.forWhat isEqualToString:@"Beer"])[submit.primaryButton addTarget:self action:@selector(submitRatingForBeer:) forControlEvents:UIControlEventTouchUpInside];
    else if([self.forWhat isEqualToString:@"Brewery"])[submit.primaryButton addTarget:self action:@selector(submitRatingForBrewery:) forControlEvents:UIControlEventTouchUpInside];

    
    addComment = [[ImageButton alloc] initWithFrame:submit.frame];
    addComment.primaryTitle.text = @"Add Comment";
    [container addSubview:addComment];
    addComment.mainImageView.image = [UIImage imageNamed:@"Add Comment.png"];
    addComment.disabledImage = [UIImage imageNamed:@"Add Comment_Disabled.png"];
    [self alterButton:addComment];
    [addComment.primaryButton addTarget:self action:@selector(addComment) forControlEvents:UIControlEventTouchUpInside];
    
    container.frame = CGRectMake(container.frame.origin.x, container.frame.origin.y, container.frame.size.width, container.frame.size.height + addComment.frame.origin.y + addComment.frame.size.height*2);
    //container.backgroundColor = [UIColor redColor];
    [thisView addContent:container];
    
    
    
    //Adjust all of the centers
    helpText.center = CGPointMake(container.frame.size.width/2, helpText.center.y);
    slider.center = CGPointMake(container.frame.size.width/2, slider.center.y);
    minValueLabel.center = CGPointMake(slider.frame.origin.x - minValueLabel.frame.size.width, slider.center.y);
    maxValueLabel.center = CGPointMake(slider.frame.origin.x + maxValueLabel.frame.size.width + slider.frame.size.width, slider.center.y);
    
    submit.center = CGPointMake(container.frame.size.width/3, currentValue.frame.origin.y + currentValue.frame.size.height + submit.frame.size.height/1.5);
    addComment.center = CGPointMake(container.frame.size.width/3 * 2, submit.center.y);
    container.frame = CGRectMake(container.frame.origin.x, container.frame.origin.y, container.frame.size.width, addComment.frame.origin.y + addComment.frame.size.height);
    
    thisView.maxHeight = submit.frame.size.height + submit.frame.origin.y + thisView.minHeight;
    
    
    self.offset += submit.frame.size.height + submit.frame.origin.y + thisView.minHeight;
    thisURL = sendingPlace;
}

-(void)addMapWithPoints:(NSArray *)arrayOfPoints{
    //Create a map
    MKMapView *currentMap = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 20, (self.frame.size.width - 20)/2)];
    currentMap.showsUserLocation = YES;
    
    //Create the collapseable view
    CollapseableView *mapView = [[CollapseableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 20, self.frame.size.height * 3)];
    mapView.title = @"Location";
    NSLog(@"User location title: %@", currentMap.userLocation.title);
    
    /*
    @try{
    CLLocationCoordinate2D midpoint = CLLocationCoordinate2DMake((currentMap.userLocation.location.coordinate.latitude + self.thisBrewery.location.coordinate.latitude)/2, (currentMap.userLocation.location.coordinate.longitude + self.thisBrewery.location.coordinate.longitude)/2);
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(currentMap.userLocation.location.coordinate, (self.thisBrewery.distance*2), (self.thisBrewery.distance*2));
        
        [currentMap setRegion:viewRegion animated:YES];
    }
    @catch(NSException *e){
        NSLog(@"Exception: %@", e.description);
    }
     */
    MKCoordinateRegion region = MKCoordinateRegionMake(self.thisBrewery.location.coordinate, MKCoordinateSpanMake(.05, .05));
    [currentMap setRegion:region animated:YES];
    
    //For the arawy of points
    for(int i = 0; i < arrayOfPoints.count; i++){
        MKAnnotationView *animateAV = [[MKAnnotationView alloc] init];
    }
    
    [mapView addContent:currentMap];
    [self addSubview:mapView];
    
}

-(void)addComment{
    textInput = [[TextInputView alloc] initWithFrame:self.parentViewController.view.frame];
    textInput.animatesIn = YES; textInput.animationSpeed = .5; textInput.animatesOut = YES;
    textInput.placeholderText = @"Comment"; textInput.title.enabled = NO;
    [textInput show];
    [self.parentViewController.view addSubview:textInput];
   
    //Add ability to send message when submitted
    [textInput.sendBtn addTarget:self action:@selector(submitComment:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)submitComment:(id)sender{
    if([self.forWhat isEqualToString:@"Beer"]){
        [myData submitReviewForBeer:self.thisBeer rating:[currentLabel.text floatValue] ratingMessage:textInput.mainMessage.text];
    }
    else if([self.forWhat isEqualToString:@"Brewery"]){
        [myData submitReviewForBrewery:self.thisBrewery rating:[currentLabel.text floatValue] ratingMessage:textInput.mainMessage.text];
    }
    
}

-(void)alterButton:(ImageButton *)temp{
    temp.bckView.backgroundColor = [UIColor colorWithRed:0.306 green:0.416 blue:0.471 alpha:1.00];
    temp.mainImageView.backgroundColor = [UIColor colorWithRed:0.306 green:0.416 blue:0.471 alpha:1.00];
    temp.mainImageView.layer.masksToBounds = YES;
    temp.mainImageView.layer.cornerRadius = temp.mainImageView.frame.size.height/2;
    temp.bckView.layer.masksToBounds = YES;
    temp.bckView.layer.cornerRadius = temp.bckView.frame.size.height/2;
    temp.enabled = YES;
    temp.showsTouchWhenHighlighted = YES;
}

-(IBAction)submitRatingForBeer:(id)sender{
    NSLog(@"Record of Beer: %@", self.thisBeer.iden);
    [myData submitReviewForBeer:self.thisBeer rating:[currentLabel.text floatValue] ratingMessage:@""];
    [submit setOperable:NO];
    [addComment setOperable:NO];
}

-(IBAction)submitRatingForBrewery:(id)sender{
    [myData submitReviewForBrewery:self.thisBrewery rating:[currentLabel.text floatValue] ratingMessage:@""];
    [submit setOperable:NO];
    [addComment setOperable:NO];
}

-(UILabel *)addLabelWithTitle:(NSString *)title{
    UILabel *temp = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 20)];
    temp.text = title;
    temp.textAlignment = NSTextAlignmentCenter;
    temp.font = [UIFont systemFontOfSize:14];
    return temp;
}

-(void)addView:(UIView *)viewToAdd{
    [self addSubview:viewToAdd];
    viewToAdd.center = CGPointMake(self.frame.size.width/2, self.offset + viewToAdd.frame.size.height/2);
    self.offset += viewToAdd.frame.size.height;
    [self updateSize];
}

-(void)sliderValueChanged:(id)sender{
    
    UISlider *tem = (UISlider *)sender;
    currentLabel.text = [NSString stringWithFormat:@"%.1f", tem.value];
    //NSLog(@"Value: %f", tem.value);
    if(tem.value > 0 && tem.value < 5) tem.tintColor = [UIColor redColor];
    else if(tem.value >= 5 && tem.value < 7.5) tem.tintColor = [UIColor yellowColor];
    else if(tem.value >= 7.5 && tem.value < 10) tem.tintColor = [UIColor greenColor];
    else tem.tintColor = [UIColor colorWithRed:0.380 green:0.490 blue:0.541 alpha:1.00];
    
}

-(void)addSection:(NSString *)text info:(NSString *)description{
    
    self.offset += 10;
    
    /*
    //Add a line to seperate
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(5, self.offset, self.frame.size.width, 2)];
    line.backgroundColor = [UIColor blackColor];
    line.layer.masksToBounds = YES;
    line.layer.cornerRadius = line.frame.size.height/2;
    line.center = CGPointMake(self.frame.size.width/2, line.center.y);
    [self addSubview:line];
    
    self.offset += 5;
    
    //Add an about section with a header and cell instead of other methods
    UILabel *aboutTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, self.offset, self.frame.size.width - 20, 20)];
    aboutTitle.text = text;
    aboutTitle.font = [UIFont boldSystemFontOfSize:16];
    aboutTitle.textColor = [UIColor lightGrayColor];
    [self addSubview:aboutTitle];
    
    self.offset += aboutTitle.frame.size.height + 5;
    
    //Add the description
    UILabel *aboutText = [[UILabel alloc] initWithFrame:CGRectMake(10, self.offset, self.frame.size.width - 20, self.frame.size.height/5)];
    aboutText.numberOfLines = 0;
    aboutText.text = description;
    aboutText.font = [UIFont systemFontOfSize:14];
    [aboutText sizeToFit];
    aboutText.frame = CGRectMake(10, self.offset, self.frame.size.width - 20, aboutText.frame.size.height);
    [self addSubview:aboutText];
    self.offset += aboutText.frame.size.height + 10;
    [self updateSize];*/
    
    //Update looks to new layout
    //Instead of adding a line, let's make the description in a bubble, with white text and add an arrow to the far left.
    //When the arrow is tapped, the section will collapse and ajust all other views
    CollapseableView *thisView = [[CollapseableView alloc] initWithFrame:CGRectMake(10, self.offset, self.frame.size.width - 20, self.frame.size.height)];
    thisView.title = text;
    [self addSubview:thisView];
    
    //Now, add content
    UILabel *about = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 20, self.frame.size.height)];
    about.numberOfLines = 0;
    about.text = description;
    about.font = [UIFont systemFontOfSize:14];
    [about sizeToFit];
    
    about.frame = CGRectMake(10, 0, self.frame.size.width, about.frame.size.height);
    [thisView addContent:about];
    
    
    [self updateSize];
    [thisView updateFrameSize];
    thisView.center = CGPointMake(self.frame.size.width/2, self.offset + thisView.frame.size.height/2);
    self.offset += thisView.frame.size.height + 10;
}

-(void)addButton:(NSString *)title target:(SEL)selector{
    //Adds a button
    //UIButton *temp = [[UIButton alloc] initWithFrame:CGRectMake(10, self.offset, self.frame.size.width - 20, self.tabBarController.tabBar.frame.size.height)];
    UIButton *temp = [[UIButton alloc] initWithFrame:CGRectMake(10, self.offset, self.frame.size.width - 20, 50)];
    temp.backgroundColor = [UIColor colorWithRed:0.306 green:0.416 blue:0.471 alpha:1.00];
    temp.layer.masksToBounds = YES;
    temp.layer.cornerRadius = temp.frame.size.height/2;
    [temp setTitle:title forState:UIControlStateNormal];
    [temp.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [temp addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:temp];
    self.offset += temp.frame.size.height + 10;
    [self updateSize];
}

-(void)updateSize{
    //Only occurs when using methods from this class;
    self.contentSize = CGSizeMake(self.frame.size.width, self.offset);
}

-(void)goToWebsite{
    //Open website in safari
    [[UIApplication sharedApplication] openURL:self.currentSite];
    
}

-(void)adjustFrames{
    orginHeight = self.frame.size.height;
    newY = 0;
    
    [UIView animateWithDuration:.5 animations:^{
    for (UIView *temp in self.subviews) {
        
        if(![temp isKindOfClass:[UIImageView class]]){
            if ([temp isKindOfClass:[CollapseableView class]]) {
                if (newY != 0) {
                    temp.frame = CGRectMake(temp.frame.origin.x, newY, temp.frame.size.width, temp.frame.size.height);
                }
            }
            else{
                temp.frame = CGRectMake(temp.frame.origin.x, newY, temp.frame.size.width, temp.frame.size.height);

            }
            
            newY+= temp.frame.size.height;
        }
        
    }
    self.offset = newY + 25;
    [self updateSize];
    }];
}

//Collaspse all collapseable view
-(void)collapseAll{
    orginHeight = self.frame.size.height;
    newY = -25;
    UIView *prevView;
    
    
    for (UIView *temp in self.subviews) {
        
        //NSLog(@"Class found: %@", [[temp class] description]);
        if(![temp isKindOfClass:[UIImageView class]]){
            if ([temp isKindOfClass:[CollapseableView class]]) {
                CollapseableView *collView = (CollapseableView *)temp;
                //NSLog(@"Found: %@", collView.title);
                
                [collView collapseView];
                
                //Add target to collapseable view to allow them to expand
                [collView.arrow addTarget:self action:@selector(adjustFrames) forControlEvents:UIControlEventTouchUpInside];
                [collView.layer removeAllAnimations];
                
                //temp.backgroundColor = [UIColor redColor];
                newY+= collView.minHeight;
                
                collView.miniView.center = CGPointMake(collView.frame.size.width/2, collView.miniView.center.y);
            }
            else newY += temp.frame.size.height;
            temp.center = CGPointMake(temp.center.x, newY);
            
            if (newY != 0) {
                prevView = temp;
            }
        }
    }
    self.offset = newY + 25;
    [self updateSize];
}



@end
