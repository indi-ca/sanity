//
//  ActiveSpaces.m
//  SpaceIdentifier
//
//  Created by Indika Piyasena on 22/08/2015.
//  Copyright (c) 2015 Indika Piyasena. All rights reserved.
//

#import "ActiveSpaces.h"

@implementation ActiveSpaces

- (NSString *)activeSpaceIdentifier {
    [[NSUserDefaults standardUserDefaults] removeSuiteNamed:@"com.apple.spaces"];
    [[NSUserDefaults standardUserDefaults] addSuiteNamed:@"com.apple.spaces"];

    NSString *output = @"AllSpaces {monitors = [";

    NSArray *spaceProperties = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"SpacesDisplayConfiguration"][@"Management Data"][@"Monitors"];

    for (NSDictionary *monitorDictionary in spaceProperties)
    {
        //NSString *monitorOut = @"Monitor {spaces=[%@]}";
        NSDictionary *currentSpace = monitorDictionary[@"Current Space"];
        NSDictionary *spaces = monitorDictionary[@"Spaces"];
        NSDictionary *displayIdentifier = monitorDictionary[@"Display Identifier"];
    }

    output = [NSString stringWithFormat:@"%@%@", output, @"]}"];

    printf([output UTF8String]);
    return nil;


/*    NSMutableDictionary *spaceIdentifiersByWindowNumber = [NSMutableDictionary dictionary];
    for (NSDictionary *spaceDictionary in spaceProperties) {
        NSArray *windows = spaceDictionary[@"windows"];
        for (NSNumber *window in windows) {
            if (spaceIdentifiersByWindowNumber[window]) {
                spaceIdentifiersByWindowNumber[window] = [spaceIdentifiersByWindowNumber[window] arrayByAddingObject:spaceDictionary[@"name"]];
            } else {
                spaceIdentifiersByWindowNumber[window] = @[ spaceDictionary[@"name"] ];
            }
        }
    }
    
    CFArrayRef windowDescriptions = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
    NSString *activeSpaceIdentifier = nil;
    
    for (NSDictionary *dictionary in (__bridge NSArray *)windowDescriptions) {
        NSNumber *windowNumber = dictionary[(__bridge NSString *)kCGWindowNumber];
        NSArray *spaceIdentifiers = spaceIdentifiersByWindowNumber[windowNumber];
        
        if (spaceIdentifiers.count == 1) {
            activeSpaceIdentifier = spaceIdentifiers[0];
            break;
        }
    }
    
    CFRelease(windowDescriptions);
    
    return activeSpaceIdentifier;*/
}

@end
