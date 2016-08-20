//
//  CustomTableView.h
//  Beer Hopper
//
//  Created by Justin Goulet on 4/11/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageButton.h"
#import "HopperData.h"
#import "TextInputView.h"
#import "CollapseableView.h"
#import <MapKit/MapKit.h>

@interface CustomTableView : UIScrollView
{
    UILabel *currentLabel;
    HopperData *myData;
    TextInputView *textInput;
    NSURL *thisURL;
    ImageButton *addComment, *submit;
    float orginHeight, newY;
}
@property (nonatomic) float offset;
@property (nonatomic, strong) NSURL *currentSite;
@property (nonatomic, strong) Beer *thisBeer;
@property (strong, nonatomic) UIViewController *parentViewController;
@property (nonatomic, strong) Brewery *thisBrewery;
@property (nonatomic, strong) NSString *forWhat;

-(void)addRow:(NSString *)title info:(NSString *)description;
-(void)addSection:(NSString *)text info:(NSString *)description;
-(void)addButton:(NSString *)title target:(SEL)selector;
-(void)addRatingSystemWithScale:(NSRange)range title:(NSString *)titleOfSection helpText:(NSString *)help submissionURl:(NSURL *)sendingPlace;
-(void)addMapWithPoints:(NSArray *)arrayOfPoints;
-(void)addView:(UIView *)viewToAdd;
-(void)updateSize;
-(void)collapseAll;

@end
