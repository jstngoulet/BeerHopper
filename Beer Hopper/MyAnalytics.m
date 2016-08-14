//
//  MyAnalytics.m
//  Beer Hopper
//
//  Created by Justin Goulet on 7/5/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "MyAnalytics.h"

@implementation MyAnalytics

//Show view
-(void)viewShown:(NSString *)viewName{
    
    //Google analytics
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:viewName];
    [tracker allowIDFACollection];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    //My analtics
    self.userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"][@"id"];
    self.thisCategory = @"View Shown";
    self.thisAction = viewName;
    
    self.thisDescription = @"";
    self.thisBreweryIden = @"";
    self.thisBeerIden = @"";
    self.thisEventIden = @"";
    //self.userID = @"";
    
    //If I want to turn on my own requests
    [self submitRequest];
}

-(void)eventAction:(NSString *)action category:(NSString *)category description:(NSString *)label breweryIden:(NSString *)breweryIden beerIden:(NSString *)beerIden eventIden:(NSString *)eventIden{
    self.thisAction = action;
    self.thisCategory = category;
    self.thisDescription = label;
    self.thisBreweryIden = breweryIden;
    self.thisBeerIden = beerIden;
    self.thisEventIden = eventIden;
    self.userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"][@"id"];
    
    masterArray = [NSArray arrayWithObjects:self.thisBreweryIden, self.thisBeerIden, self.thisEventIden, self.userID, nil];
    
    //submit the request
    [self submitRequest];
}

-(NSString *)lineOfRequestWithName:(NSString *)name iden:(NSString *)iden{
    return [NSString stringWithFormat:@"\"%@\":[\"%@\"]", name, iden];
}

-(NSString *)lineOfRequestWithName:(NSString *)name desc:(NSString *)iden{
    return [NSString stringWithFormat:@"\"%@\":\"%@\"", name, iden];
}

-(void)submitRequest{
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIEventLabel value:self.thisCategory];
    [tracker allowIDFACollection];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:self.thisCategory action:self.thisAction label:self.thisDescription value:0] build]];
    
    //Check to see if any of the values are null. We should build the string request as we go
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.airtable.com/v0/app1lDaL7cCCFmKrJ/Analytics?api_key=keyBAo5QorTmqZmN8"]]];
    
    //Build the request
    NSString *dataToSend = @"{\"fields\":{";
    if(self.thisAction.length > 0) dataToSend = [dataToSend stringByAppendingString:[NSString stringWithFormat:@"%@, ", [self lineOfRequestWithName:@"Action" desc:self.thisAction]]];
    if(self.thisCategory.length > 0) dataToSend = [dataToSend stringByAppendingString:[NSString stringWithFormat:@"%@, ", [self lineOfRequestWithName:@"Category" desc:self.thisCategory]]];
    if(self.thisDescription.length > 0) dataToSend = [dataToSend stringByAppendingString:[NSString stringWithFormat:@"%@, ", [self lineOfRequestWithName:@"Label" desc:self.thisDescription]]];
    if(self.thisBreweryIden.length > 0) dataToSend = [dataToSend stringByAppendingString:[NSString stringWithFormat:@"%@, ", [self lineOfRequestWithName:@"Brewery" iden:self.thisBreweryIden]]];
    if(self.thisBeerIden.length > 0) dataToSend = [dataToSend stringByAppendingString:[NSString stringWithFormat:@"%@, ", [self lineOfRequestWithName:@"Beer" iden:self.thisBeerIden]]];
    if(self.thisEventIden.length > 0) dataToSend = [dataToSend stringByAppendingString:[NSString stringWithFormat:@"%@, ", [self lineOfRequestWithName:@"Event" iden:self.thisEventIden]]];
    if(self.userID.length > 0) dataToSend = [dataToSend stringByAppendingString:[NSString stringWithFormat:@"%@", [self lineOfRequestWithName:@"User" iden:self.userID]]];
    
    //Finalize it
    dataToSend = [dataToSend stringByAppendingString:@"}}"];
    
    NSLog(@"Credentials: %@", dataToSend);
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSString *stringData = dataToSend;
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    // Create url connection and fire request
    tempConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
}

//Delagate stuff
#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
    //NSLog(@"Data: %@", self.responseData);
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}
- (void) connection:(NSURLConnection *) connection didFailWithError:(NSError *)error {
    NSLog(@"Failed with error: %@", error.localizedDescription);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSError *localError;
    NSDictionary *readJSON = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&localError];
    
    NSLog(@"Response: %@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    
    if (!localError) {
        NSLog(@"Post Successful!");
    }
    
    NSLog(@"JSON Returned: %@", readJSON);
}

@end
