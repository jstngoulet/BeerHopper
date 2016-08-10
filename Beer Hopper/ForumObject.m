//
//  ForumObject.m
//  Beer Hopper
//
//  Created by Justin Goulet on 1/17/16.
//  Copyright © 2016 The Crony Project. All rights reserved.
//

#import "ForumObject.h"

@implementation ForumObject

-(id)initWithTitle:(NSString *)title message:(NSString *)messageContent imageAddress:(NSString *)imgURL rating:(double)thisRating dateOfPost:(NSDate *)date messageType:(NSString *)type likes:(int)numLikes dislikes:(int)numDislikes user:(NSString *)userName{
    
    self.titleOfPost = title;
    self.messageBody = messageContent;
    //self.postImage
    self.rating = thisRating;
    self.messageDate = date;
    self.messageType = type;
    self.numberOfLikes = numLikes;
    self.numberOfDislikes = numDislikes;
    self.user = userName;
    
    self.dateString = [self formatDate:self.messageDate];
    
    return self;
}


-(NSString *)formatDate:(NSDate *)dateToFormat
{
    //The date is in he following format:
    /*
     *  YYYY-MM-DDTHH-MM-SS000Z
     *
     *  Starting with the year (YYYY-MM-DD) then work into the time(HH:MM:SS).
     *  We will then add the timesince at the end (30 seconds ago...)
     *
     */
    //NSString *formattedDate = [[NSString alloc] init];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    //The Z at the end of your string represents Zulu which is UTC
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    NSDate* newTime = [dateFormatter dateFromString:dateToFormat.description];
    //NSLog(@"original time: %@", newTime);
    
    //Add the following line to display the time in the local time zone
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    //[dateFormatter setDateFormat:@"EEEE'\t|\t' MMM d, yyyy '\t|\t' h:mm a"];
    //[dateFormatter setDateFormat:@"h:mm a '\t\t|\t' EEEE '\t|\t' MMM d, yyy"];
    NSString* finalTime = [dateFormatter stringFromDate:newTime];
    
    float secondsSincePost = [[NSDate date] timeIntervalSinceDate:newTime];
    
    int number = 0;
    
    //If years
    if (secondsSincePost > 31557600) {
        number = 31557600;
        finalTime = @"A Long Time Ago...";
    }
    //If months
    else if (secondsSincePost > 2629800){
        number = (int)(secondsSincePost/2629800);
        finalTime = [NSString stringWithFormat:@"%i month", number];
    }
    //If weeks
    else if (secondsSincePost > 604800){
        number = (int)(secondsSincePost/604800);
        finalTime = [NSString stringWithFormat:@"%i week", number];
    }
    //If days
    else if (secondsSincePost > 86400){
        number = (int)(secondsSincePost/86400);
        finalTime = [NSString stringWithFormat:@"%i day", number];
    }
    //If hours
    else if (secondsSincePost > 3600){
        number = (int)(secondsSincePost/3600);
        finalTime = [NSString stringWithFormat:@"%i hour", number];
    }
    //If Mins
    else if (secondsSincePost > 60){
        number = (int)(secondsSincePost/60);
        finalTime = [NSString stringWithFormat:@"%i minute", number];
    }
    //If secs
    else if (secondsSincePost > 0){
        number = (int)(secondsSincePost);
        finalTime = [NSString stringWithFormat:@"%i second", number];
    }
    else return @"";
    
    if (number == 1) {
        finalTime = [finalTime stringByAppendingString:@" ago"];
    }
    else if ((number == 0 || number > 1) && number < 31557600){
        finalTime = [finalTime stringByAppendingString:@"s ago"];
    }
    else if (finalTime.length > 0){
        
    }
    else if (number < 31557600){
        finalTime = [finalTime stringByAppendingString:@"s ago"];
    }
    
    
    //NSLog(@"%@", finalTime);
    
    if (finalTime.length > 0) {
        return finalTime;
    }
    else
        return @"";
}

-(NSComparisonResult)sortByDate:(ForumObject *)other{
    return [other.messageDate compare:self.messageDate];
}
@end
