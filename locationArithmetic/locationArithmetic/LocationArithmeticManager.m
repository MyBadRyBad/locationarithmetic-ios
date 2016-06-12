//
//  LocationArithmeticManager.m
//  locationArithmetic
//
//  Created by Ryan Badilla on 6/12/16.
//  Copyright © 2016 rybad. All rights reserved.
//

#import "LocationArithmeticManager.h"

@implementation LocationArithmeticManager

#pragma mark -
#pragma mark - sharedManager
+ (id)sharedManager {
    static LocationArithmeticManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}


#pragma mark -
#pragma mark - conversion methods
- (NSString *)locationStringFromInteger:(NSUInteger)integer {
    
    NSUInteger locationInteger = integer;
    
    NSMutableString *locationString = [[NSMutableString alloc] init];
    
    // find next highest location numeral
    for (char c = 'z'; c >= 'a'; c--) {
        
        NSUInteger convertedInteger = [self integerfromLocationNumeral:c];
        
        // add multiple location numerals if necessary
        while ((locationInteger / convertedInteger) >= 1) {
            [locationString insertString:[NSString stringWithFormat:@"%c", c] atIndex:0];
            
            // multiple 'z' characters
            if (c == 'z' && (locationInteger - convertedInteger) > convertedInteger) {
                locationInteger = locationInteger - convertedInteger;
            } else {
                locationInteger = locationInteger % convertedInteger;
            }
        }
    }
    
    return locationString;
    
}

- (NSUInteger)integerFromLocationNumeral:(NSString *)locationNumeral {
    NSString *locationString = [locationNumeral lowercaseString];
    NSUInteger convertedInteger = 0;
    
    for (int index = 0; index < [locationString length]; index++) {
        char c = [locationString characterAtIndex:index];
        
        if ([self isValidLocationNumeral:c]) {
            convertedInteger = convertedInteger + [self integerfromLocationNumeral:c];
        }
    }
    
    return convertedInteger;
}

- (NSString *)abbreviatedLocationNumeralFromLocationNumeral:(NSString *)locationNumeral byCountingDuplicates:(BOOL)byCountingDuplicates {
    
    // count duplicate numerals if locationStringFromInteger method no longer returns abbreviated form
    if (byCountingDuplicates) {
        NSMutableDictionary *numeralCountDictionary = [self getDictionaryOfNumeralLocationCountsFromString:locationNumeral];
        numeralCountDictionary = [self convertDuplicateLocationNumeralsFromDictionary:numeralCountDictionary];
        
        return [self locationNumeralStringFromDictionaryOfCounts:numeralCountDictionary];
    } else { // just convert the location numeral to an integer, and use locationStringFromInteger method to return abbreviated form
        NSUInteger convertedInteger = [self integerFromLocationNumeral:locationNumeral];
        return [self locationStringFromInteger:convertedInteger];
    }
}


#pragma mark -
#pragma mark - location numeral helper methods
- (BOOL)isValidLocationNumeral:(char)locationNumeral {
    return (locationNumeral >= 'a' && locationNumeral <= 'z');
}

- (NSUInteger)integerfromLocationNumeral:(char)locationNumeral {
    return (locationNumeral == 'a') ? 1 : 2 << ((locationNumeral - 'a') - 1);
}

#pragma mark -
#pragma mark - abbreviated location numeral helper methods
- (NSMutableDictionary *)getDictionaryOfNumeralLocationCountsFromString:(NSString *)locationNumeralString {
    
    if (locationNumeralString && [locationNumeralString length] > 0) {
        // add characters in given string to dictionary and count the occurrences
        NSMutableDictionary *numeralCountDictionary = [[NSMutableDictionary alloc] init];
        
        for (int index = 0; index < [locationNumeralString length]; index++) {
            char c = [locationNumeralString characterAtIndex:index];
            NSString *characterString = [NSString stringWithFormat:@"%c", c];
            
            if ([self isValidLocationNumeral:c]) {
                NSNumber *count = [numeralCountDictionary objectForKey:characterString];
                if (!count) {
                    count = [NSNumber numberWithUnsignedInteger:1];
                } else {
                    count = [NSNumber numberWithUnsignedInteger:[count unsignedIntegerValue] + 1];
                }
                
                [numeralCountDictionary setObject:count forKey:characterString];
            }
        }
        
        return numeralCountDictionary;
    }
    
    return nil;
}

- (NSMutableDictionary *)convertDuplicateLocationNumeralsFromDictionary:(NSMutableDictionary *)numeralCountDictionary {
    
    if (numeralCountDictionary) {
        // convert duplicates
        for (char c = 'a'; c <= 'z'; c++) {
            NSString *characterString = [NSString stringWithFormat:@"%c", c];
            NSNumber *count = [numeralCountDictionary objectForKey:characterString];
            
            // character exists and there are duplicates, so remove duplicates and add to next character
            if (count && ([count unsignedIntegerValue] > 1) && c != 'z') {
                NSUInteger nextCount = [count unsignedIntegerValue] / 2;
                
                NSString *nextStringCharacter = [NSString stringWithFormat:@"%c", c + 1];
                NSNumber *nextNumber = [numeralCountDictionary objectForKey:nextStringCharacter];
                
                // remove current character from dictionary if even number of duplicates i.e. aa || aaaa
                if ([count unsignedIntegerValue] % 2 == 0) {
                    [numeralCountDictionary removeObjectForKey:characterString];
                } else { // set to remainder
                    NSNumber *newNumber = [NSNumber numberWithUnsignedInteger:[count unsignedIntegerValue] % 2];
                    [numeralCountDictionary setObject:newNumber forKey:characterString];
                }
                
                // add number of duplicates to next character's count
                if (!nextNumber) {
                    NSNumber *newNumber = [NSNumber numberWithUnsignedInteger:nextCount];
                    [numeralCountDictionary setObject:newNumber forKey:nextStringCharacter];
                } else {
                    NSNumber *newNumber = [NSNumber numberWithUnsignedInteger:nextCount + [nextNumber unsignedIntValue]];
                    [numeralCountDictionary setObject:newNumber forKey:nextStringCharacter];
                }
            }
        }
    }
    
    return numeralCountDictionary;
}

- (NSString *)locationNumeralStringFromDictionaryOfCounts:(NSMutableDictionary *)numeralCountDictionary {
    if (numeralCountDictionary) {
        NSMutableString *locationNumeralString = [[NSMutableString alloc] init];
        
        for (char c = 'a'; c <= 'z'; c++) {
            NSString *characterString = [NSString stringWithFormat:@"%c", c];
            
            NSNumber *count = [numeralCountDictionary objectForKey:characterString];
            if (count) {
                for (NSUInteger index = 0; index < [count unsignedIntValue]; index++) {
                    [locationNumeralString appendString:characterString];
                }
            }
        }
        
        return locationNumeralString;
    }
    
    return nil;
}

@end
