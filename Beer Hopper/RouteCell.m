//
//  RouteCell.m
//  Beer Hopper
//
//  Created by Justin Goulet on 1/16/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "RouteCell.h"
#import "Brewery.h"

@implementation RouteCell

- (void)awakeFromNib {
    // Initialization code
    [self makeCircle:self.numberTimeTakenLabel];
    //[self addShadowToView:self.backgroundView];
}

-(void)setDelagate{
    
    self.routeMap.scrollEnabled = NO;
    self.routeMap.zoomEnabled = NO;
    self.routeMap.delegate = self;
}

-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    
    mapView.showsUserLocation = YES;
}

-(void)addShadowToView:(UIView *)temp{
    temp.layer.shadowOffset = CGSizeMake(1, 1);
    temp.layer.shadowColor = [UIColor grayColor].CGColor;
    temp.layer.shadowRadius = 2.0f;
    temp.layer.shadowOpacity = 1;
    temp.layer.shadowPath = [[UIBezierPath bezierPathWithRect:temp.layer.bounds] CGPath];
}

-(void)makeCircle:(UIView *)temp{
    temp.layer.masksToBounds = YES;
    temp.layer.cornerRadius = temp.frame.size.height/2;
}

-(void)dropPins{
    for (Brewery *temp in self.currentRoute.breweries) {
        //Pin the location
        [self dropPinAt:temp onMap:self.routeMap];
    }
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([[(Brewery *)[self.currentRoute.breweries objectAtIndex:0] location] coordinate], 5000, 5000);
    [self.routeMap setRegion:[self.routeMap regionThatFits:region] animated:NO];
}

/**
 *  Adds a pin to the given map
 */
-(void)dropPinAt:(Brewery *)business onMap:(MKMapView *)currentMap
{
    //Create a location
    CLLocationCoordinate2D businessLocation = CLLocationCoordinate2DMake(business.location.coordinate.latitude, business.location.coordinate.longitude);
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate =  businessLocation;
    point.title = business.name;
    point.subtitle = @"I'm here!!!";
    [self.routeMap addAnnotation:point];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
