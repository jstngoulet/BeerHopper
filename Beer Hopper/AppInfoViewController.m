//
//  AppInfoViewController.m
//  Beer Hopper
//
//  Created by Justin Goulet on 6/27/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "AppInfoViewController.h"

@interface AppInfoViewController ()

@end

@implementation AppInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
    myData = [[HopperData alloc] init];
    self.title = @"App Info";
    
    //Add background view (White)
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, self.tabBarController.tabBar.frame.size.height/2, self.view.frame.size.width - 20, self.view.frame.size.height - 10 - self.tabBarController.tabBar.frame.size.height*2)];
    self.backgroundView.layer.masksToBounds = YES;
    self.backgroundView.layer.cornerRadius = 15;
    self.backgroundView.center = CGPointMake(self.view.center.x, self.view.center.y);
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundView];
    
    //Add the cover photo
    self.breweryCoverPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height/3)];
    self.breweryCoverPhoto.image = [UIImage imageNamed: @"BeerHopperLogo.png"];
    self.breweryCoverPhoto.layer.masksToBounds = YES;
    [self.breweryCoverPhoto setContentMode:UIViewContentModeScaleAspectFit];
    [self.backgroundView addSubview:self.breweryCoverPhoto];
    
    table = [[CustomTableView alloc] initWithFrame:CGRectMake(10, self.breweryCoverPhoto.frame.origin.y + self.breweryCoverPhoto.frame.size.height, self.backgroundView.frame.size.width - 20, self.backgroundView.frame.size.height - (self.breweryCoverPhoto.frame.origin.y + self.breweryCoverPhoto.frame.size.height) - 10)];
    [self.backgroundView addSubview:table];
    //table.backgroundColor = [UIColor redColor];
    
    NSDictionary *bundleDictionary = [[NSBundle mainBundle] infoDictionary];
    //NSLog(@"Main Dictionary: %@", bundleDictionary);
    
    [table addRow:@"Version" info:bundleDictionary[@"CFBundleShortVersionString"]];
    [table addRow:@"Build" info:bundleDictionary[@"CFBundleVersion"]];
    [table addSection:@"About Us:" info:@"Beer Hopper was inspired by a fellow who no only loves visiting all of the local microbrews, but also enjoys brewing in his garage with his step-father.\n\nFrom large breweries to small, we want a place for everyone. Don't own a place yet, but are looking for feedback on your ideas? Advertise your brewery here for many other beer-lovers to review! People just like you can rate your brews based on many aspects. Their comments can help you grow into something your dreams would have never brought you.\n\nTo see your brewery here, contact the developer using the forum or email directly at \nJTizzApps@icloud.com\n\nBrew on, my friends."];
    [table addSection:@"FAQs" info:@"Location Services:\n• If you are not finding any local breweries, be sure that you have location services enabled. Location Services can be found by opening the settings app, Select \"Beer Hopper\" from the list, tapping \"Location Services\" and select \"Always\". We do not share your location with ANYONE. we just use it to determine which breweries are close to you.\n\nStill not working?\n• We are adding more breweries every day! Check back to see what is coming next! Starting with the San Diego area, we will be expanding as soon as other breweries contact us. We want every brewery to be represented in our easy to use application, but we cannot do this without your help!\n\nHave a brewery you wish to add?\n• We are always trying to add breweries to our application so the world can easily locate new places to hang out and enjoy a local brew. Contact the sole developer at JTizzApps@icloud.com for more information.\n\nWant to report a bug in the application?\n• Post in the \"Feedback\" discussion board to submit your comments! We value every persons opinion and want to tailor the experience towards our users!\n\nHow do \"Events\" work?\n• Events appear only for the breweries that are located around you. You can rsvp to an event, read details, and even see the brewery that is hosting it by tapping on their name in the description.\n\nHow do I add favorites?\n• You can add a favorite brewery, that will be viewable even when you are not in distance, by tapping the star on the main brewery page.\n\nHow can I rate a brewery?\n• Breweries want you to experience the brewery before they get reviewed, so that the honest reviews really come out. Each brewery can set the amount of times you must visist before you leave a review with them. As you visit more, you can do more to help them out!\n\n"];
    
    [table addSection:@"Beer Hopper Stats:" info:@""];
    
    //Now, add the DB Stats from the view
    NSString *query = @"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/DBStats?view=Stats";
    
    NSURL*url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&api_key=keyBAo5QorTmqZmN8", query]];
    NSURLRequest *res = [NSURLRequest requestWithURL:url];
    NSOperationQueue*que=[NSOperationQueue new];
    
    [NSURLConnection sendAsynchronousRequest:res queue:que completionHandler:^(NSURLResponse*rep,NSData*data,NSError*err){
        if ([data length]> 0 && err == nil) {
            //NSString* rel=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSDictionary* json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:&err];
            //NSLog(@"%@",json[@"records"]);
            
            for (NSDictionary *tempRecords in json[@"records"]) {
                //NSLog(@"Record: %@", tempRecords[@"fields"]);
                
                for (NSArray *temp in tempRecords[@"fields"]) {
                    //NSLog(@"Temp: %@", tempRecords[@"fields"][temp]);
                    if([temp.description isEqualToString:@"Beers"] || [temp.description isEqualToString:@"Events"] || [temp.description isEqualToString:@"Breweries"]){
                    [self performSelectorOnMainThread:@selector(addRowWrapper:) withObject:[NSString stringWithFormat:@"%@|%@", temp, tempRecords[@"fields"][temp]] waitUntilDone:NO];
                       }
                }
                break;
            }
            
        }else{
            NSLog(@"Data is Null");
        }
        
    }
     ];

    
}

-(void)addRowWrapper:(NSString *)temp{
    //Should just have a value and a key
    //      value||key
    
    NSArray *myWords = [temp componentsSeparatedByCharactersInSet:
                        [NSCharacterSet characterSetWithCharactersInString:@"|"]
                        ];
    NSLog(@"%@", myWords);
    
    [table addRow:[myWords objectAtIndex:0] info:[myWords objectAtIndex:1]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
