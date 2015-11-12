//
//  MapService.h
//  SJSU Interactive Map
//
//  Created by Dexter Wei on 11/10/15.
//  Copyright © 2015 ___PERSONAL___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapService : NSObject
-(NSDictionary *) distancetime:(NSString *)orig destination:(NSString *)dest;
@end