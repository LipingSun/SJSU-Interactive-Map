//
//  MapService.m
//  SJSU Interactive Map
//
//  Created by Dexter Wei on 11/10/15.
//  Copyright © 2015 ___PERSONAL___. All rights reserved.
//

#import "MapService.h"

@implementation MapService
-(NSDictionary *) distancetime:(NSString *)orig destination:(NSString *)dest{
    
    //    NSString *key = @"YOUR API KEY";
    NSMutableString *google = [NSMutableString stringWithCapacity:1000];
    [google appendString:@"https://maps.googleapis.com/maps/api/distancematrix/json?"];
    [google appendString:@"origins="];
    [google appendString:orig];
    [google appendString:@"&destinations="];
    [google appendString:dest];
    [google appendString:@"&mode=walking"];
    //        [google appendString:@"&key="];
    //        [google appendString:key];
    
    //NSLog(@"%@",google);
    
    //send synchronous http request
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:google]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    //handle response
    if(error != NULL){
        NSLog(@"Error: %@, %@",response.description,error.description);
        NSDictionary *ret = @{@"distance":@"None",@"time":@"None"};
        return ret;
        
    }else{
        //NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSError *myError = nil;
        
        //parse json from data
        NSMutableDictionary * innerJson = [NSJSONSerialization
                                           JSONObjectWithData:data options:kNilOptions error:&myError
                                           ];
        //retrive fields of interest
        NSArray *rows = [innerJson objectForKey:@"rows"];
        NSArray *elements = [rows[0] objectForKey:@"elements"];
        NSMutableDictionary *dist = [elements[0] objectForKey:@"distance"];
        NSMutableDictionary *time = [elements[0] objectForKey:@"duration"];
        NSString *meters = [dist objectForKey:@"text"];
        NSString *seconds = [time objectForKey:@"text"];
        
        NSDictionary *ret = @{@"distance":meters,@"time":seconds};
        return ret;
    }
}
@end
