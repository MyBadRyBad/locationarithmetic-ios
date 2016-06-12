//
//  LocationArithmeticManager.h
//  locationArithmetic
//
//  Created by Ryan Badilla on 6/12/16.
//  Copyright © 2016 rybad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationArithmeticManager : NSObject

+ (id)sharedManager;

- (NSString *)locationStringFromInteger:(NSUInteger)integer;
- (NSUInteger)integerFromLocationNumeral:(NSString *)locationNumeral;
- (NSString *)abbreviatedLocationNumeralFromLocationNumeral:(NSString *)locationNumeral byCountingDuplicates:(BOOL) byCountingDuplicates;


@end
