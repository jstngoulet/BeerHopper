//
//  CronyCount.m
//  Crony
//
//  Created by Justin Goulet on 9/25/15.
//  Copyright © 2015 Justin Goulet. All rights reserved.
//

#import "CronyCount.h"

@implementation CronyCount

-(id)initWithLocation:(CLLocation *)currentLocation placeID:(NSString *)currentPlaceID
{
    currentDeviceLocation = currentLocation;
    _placeID = currentPlaceID;
    
    //Gather User info
    userInfo = [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"testKey"]];
    
    @try {
        //Login
        //[self loginToOurServer];
        
        //Get crony info
        //If the crony info is null, get the updated information
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"currentCrony"] != NULL) {
            [self getCronyInfo];
        }
        
        //For testing, try to get the count by business id
        //NSLog(@"Crony Count Test: %i", [self getBusinessCronyCount:NULL]);
    }
    @catch (NSException *exception) {
        NSLog(@"ERR: %@", exception.description);
    }
    //NSLog(@"Model: %@", model.description);
    return self;
}


/**
 *  Logout of server using access token
 */
-(void)logout
{
    userInfo = [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"testKey"]];
    NSString *locationQuery = [NSString stringWithFormat:@"http://api.crony.me:3000/api/Cronies/logout?access_token=%@", userInfo[@"id"]];
    NSString *encodedUrl = [locationQuery stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSURL *urlRequest = [[NSURL alloc] initWithString:encodedUrl];
    NSData *dataURL;
    if (![urlRequest isEqual:NULL]) {
        dataURL = [NSData dataWithContentsOfURL:urlRequest];
    }
    
    //NSLog(@"DATA: %@", dataURL);
    
    // to receive the returned value (as a string)
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    //NSLog(@"String result: %@", strResult);
    
    NSError *localError;
    NSDictionary *readJsonArray;
    
    //Load data without issue so far
    if((dataURL != NULL || ![strResult isEqual:NULL]) && strResult.length > 0)
    {
        readJsonArray = [NSJSONSerialization JSONObjectWithData:dataURL options:0 error:&localError];
        NSLog(@"Logout Success: %@", readJsonArray);
    }
    if (localError){
        [self reportErrorWitTitle:@"Could not Logout user" content:[NSString stringWithFormat:@"While trying to logout, the below user used information that led to a false query. Please check below with the error\n\n%@\n\nError: %@", userInfo, localError.localizedDescription]];
    }
    
    //Clear local Data
    [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"testKey"];
}

/**
 *  Works
 */
-(void)getCronyInfo{
    // Create the request.
    NSLog(@"Getting Crony Info");
    
    userInfo = [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"testKey"]];
    NSString *locationQuery = [NSString stringWithFormat:@"http://api.crony.me:3000/api/Cronies/%@?access_token=%@", userInfo[@"userId"], userInfo[@"id"]];
    NSLog(@"URL: %@", locationQuery);
    NSString *encodedUrl = [locationQuery stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSURL *urlRequest = [[NSURL alloc] initWithString:encodedUrl];
    NSData *dataURL;
    if (![urlRequest isEqual:NULL]) {
        dataURL = [NSData dataWithContentsOfURL:urlRequest];
    }
    
    //NSLog(@"DATA: %@", dataURL);
    
    // to receive the returned value (as a string)
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    //NSLog(@"String result: %@", strResult);
    
    NSError *localError;
    NSDictionary *readJsonArray;
    
    //Load data without issue so far
    if((dataURL != NULL || ![strResult isEqual:NULL]) && strResult.length > 0)
    {
        readJsonArray = [NSJSONSerialization JSONObjectWithData:dataURL options:0 error:&localError];
        //NSLog(@"Crony: %@", readJsonArray);
        [[NSUserDefaults standardUserDefaults] setObject:readJsonArray forKey:@"currentCrony"];
        
        NSLog(@"Crony Data: %@", readJsonArray);
    }
    //Could not pul any data
    else
    {
        NSLog(@"Crony Data: %@", dataURL);
    }
}


-(int)getCronyCount
{
    return numberOfCronies;
    
}

/**
 *  Works
 */
-(void)submitCronyCount:(CLLocation *)currentLocation
{
    currentDeviceLocation = currentLocation;
    //NSError *localError;
    //Gather User info
    userInfo = [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"testKey"]];
    
    //First get crony count, then update by 1
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.crony.me:3000/api/Cronies/%@?access_token=%@", userInfo[@"userId"], userInfo[@"id"]]]];
    
    //Get the crony dict
    //NSDictionary *cronyDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentCrony"];
    //NSLog(@"cronyDict: %@", cronyDict);
    
    //NSDictionary *credentials = [NSDictionary dictionaryWithObjectsAndKeys:@"email", @"jstngoulet@me.com", @"password", @"password", nil];
    NSString *cred = [NSString stringWithFormat:@"{\"last_location\":{ \"lat\":\"%f\",\"lng\":\"%f\"}, \"lastUpdated\":\"%@\"}", currentDeviceLocation.coordinate.latitude, currentDeviceLocation.coordinate.longitude, [NSDate date].description];
    
    //NSLog(@"Dict: %@", [NSJSONSerialization JSONObjectWithData:[cred dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&localError]);
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"PUT";
    
    // This is how we set header fields
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSString *stringData = cred.description;
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    // Create url connection and fire request
    getCronyInfo = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

/**
 *  Login Works
 */
-(void)loginToOurServerUsingUser:(NSString *)userEamil password:(NSString *)pwd errorLabel:(UILabel *)lbl presentViewControllerWhenComplete:(UIViewController *)view
{
    //Save the temp vars
    temp = lbl;
    newController = view;
    
    //Logs the user in to the server using the known information
    // Create the request.
    //Gather User info
    userInfo = [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"testKey"]];
    NSLog(@"Loggin in");
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.crony.me:3000/api/Cronies/login?access_token=%@", userInfo[@"id"]]]];
    
    //NSDictionary *credentials = [NSDictionary dictionaryWithObjectsAndKeys:@"email", @"jstngoulet@me.com", @"password", @"password", nil];
    NSString *cred = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\"}", userEamil, pwd];
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSString *stringData = cred.description;
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    // Create url connection and fire request
    loginConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //NSLog(@"Results from signin: %@", conn.description);
}

/**
 *  Login Works
 */
-(void)CreateAccountUsingUser:(NSString *)userEamil password:(NSString *)pwd errorLabel:(UILabel *)lbl;
{
    //Save the temp vars
    temp = lbl;
    pawd = pwd;
    username = userEamil;
    
    //Logs the user in to the server using the known information
    // Create the request.
    //Gather User info
    //userInfo = [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"testKey"]];
    NSLog(@"Creating Account");
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.crony.me:3000/api/Cronies"]]];
    
    //Create a user email from the user name;
    NSString *emailToBeCreated = [[userEamil componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                                  componentsJoinedByString:@""];
    emailToBeCreated = [emailToBeCreated stringByAppendingString:@"@Crony.Me"];
    
    //NSDictionary *credentials = [NSDictionary dictionaryWithObjectsAndKeys:@"email", @"jstngoulet@me.com", @"password", @"password", nil];
    NSString *cred = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\", \"email\": \"%@\"}", userEamil, pwd, emailToBeCreated];
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSString *stringData = cred.description;
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    // Create url connection and fire request
    createConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //NSLog(@"Results from signin: %@", conn.description);
    
    //Login using new creadentials
    //[self loginToOurServerUsingUser:userEamil password:pwd errorLabel:lbl presentViewControllerWhenComplete:nil];
}

-(int)getBusinessCronyCount:(CLLocation *)location
{
    //Step to figure out the crony location
    //  1) Login to the Users/Login module using the credentials used
    //  2) Use the id provided by the result to get the access token
    //  3) finally, create the call to get using id as your access key and user id as the id
    //NSLog(@"User Info: %@", userInfo);
    
    //NSError *localError;
    //NSLog(@"Getting crony count for business");
    //Gather User info
    
    //Build location string
    NSString *locationString = [NSString stringWithFormat:@"{\"lat\": %f,\"lng\" : %f}", location.coordinate.latitude, location.coordinate.longitude];
    
    //NSLog(@"Location String: %@", locationString);
    
    userInfo = [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"testKey"]];
    NSString *locationQuery = [NSString stringWithFormat:@"http://api.crony.me:3000/api/Cronies/countAt?here=%@&max=.1&access_token=%@", locationString, userInfo[@"id"]];
    NSString *encodedUrl = [locationQuery stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    //NSLog(@"Crony Encoded URL: %@", encodedUrl);
    
    NSURL *urlRequest = [[NSURL alloc] initWithString:encodedUrl];
    NSData *dataURL;
    if (![urlRequest isEqual:NULL]) {
        dataURL = [NSData dataWithContentsOfURL:urlRequest];
    }
    
    //NSLog(@"DATA: %@", dataURL);
    
    // to receive the returned value (as a string)
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    //NSLog(@"String result: %@", strResult);
    
    NSError *localError;
    NSDictionary *readJsonArray;
    
    //Load data without issue so far
    if((dataURL != NULL || ![strResult isEqual:NULL]) && strResult.length > 0)
    {
        readJsonArray = [NSJSONSerialization JSONObjectWithData:dataURL options:0 error:&localError];
        //NSLog(@"Cronies: %@", readJsonArray);
        numberOfCronies = [readJsonArray[@"count"] intValue];
        
        //For testing only
        numberOfCronies = arc4random() % 20;
        
        return numberOfCronies;
    }
    //Could not pul any data
    else
    {
        numberOfCronies = arc4random() % 20;
    }
    
    //NSLog(@"Results from signin: %@", conn.description);
    
    //return [readJsonArray[@"count"]intValue];
    //return numberOfCronies;
    return numberOfCronies;
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
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSError *localError;
    
    if (connection == loginConnection) {
        NSDictionary *readJSON = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&localError];
        if (![readJSON[@"userId"] isEqual:NULL]) {
            //Save the new data
            NSLog(@"Data: %@", readJSON[@"error"][@"message"]);
            if ([readJSON[@"error"][@"message"] length] > 0) {
                //Update the text of the label
                temp.text = readJSON[@"error"][@"message"];
            }
            else{
                [[NSUserDefaults standardUserDefaults] setObject:readJSON forKey:@"testKey"];
                loginConnection = NULL;
                NSLog(@"User Info saved!");
                vc = [[[[[UIApplication sharedApplication] delegate] window] rootViewController].storyboard instantiateViewControllerWithIdentifier:@"main"];
                [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:vc animated:YES completion:nil];
                
            }
            
        }
        //NSLog(@"Reponse: %@", readJSON);
    }
    else if(connection == createConnection){
        NSDictionary *readJSON = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&localError];
        NSLog(@"Results: %@", readJSON);
        if (![readJSON[@"userId"] isEqual:NULL]) {
            //Save the new data
            NSLog(@"Data: %@", readJSON[@"error"][@"message"]);
            if ([readJSON[@"error"][@"message"] length] > 0) {
                //Update the text of the label
                temp.text = readJSON[@"error"][@"message"];
            }
            else{
                [[NSUserDefaults standardUserDefaults] setObject:readJSON forKey:@"testKey"];
                createConnection = NULL;
                NSLog(@"User Info saved!");
                //vc = [[[[[UIApplication sharedApplication] delegate] window] rootViewController].storyboard instantiateViewControllerWithIdentifier:@"main"];
                //[[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:vc animated:YES completion:nil];
                
                //User logged in
                
                //Login
                [self loginToOurServerUsingUser:username password:pawd errorLabel:temp presentViewControllerWhenComplete:nil];
            }
            
        }
    }
    if (connection == cronieCountResponse){
        //Save the count
        NSDictionary *readJSON = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&localError];
        NSLog(@"Cronies: %@", readJSON);
    }
    if (connection == getCronyInfo) {
        //NSDictionary *readJSON = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&localError];
        //NSLog(@"Crony Submittion response: %@", readJSON);
    }
}

-(void)setCronyCount:(int)newCount{
    numberOfCronies = newCount;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"ERROR with connection: %@: %@", connection.originalRequest.URL, error.localizedDescription);
    currentCrony = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentCrony"];
    [self reportErrorWitTitle:error.localizedDescription content:error.localizedDescription];
}

-(void)reportErrorWitTitle:(NSString *)titleOfError content:(NSString *)errorContent
{
    //Gather User info
    userInfo = [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"testKey"]];
    
    @try {
        currentCrony = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentCrony"];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception.description);
    }
    
}

@end

