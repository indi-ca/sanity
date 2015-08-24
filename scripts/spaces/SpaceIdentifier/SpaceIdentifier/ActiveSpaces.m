//
//  ActiveSpaces.m
//  SpaceIdentifier
//
//  Created by Indika Piyasena on 22/08/2015.
//  Copyright (c) 2015 Indika Piyasena. All rights reserved.
//

#import "ActiveSpaces.h"

@implementation ActiveSpaces

int get_space_via_keywin() {
    CFArrayRef winList =
            CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);

    int len = CFArrayGetCount(winList);
    int i, num = 0;
    for (i = 0; i < len; i++) {
        CFDictionaryRef winDict = CFArrayGetValueAtIndex(winList, i);
        if (CFDictionaryContainsKey(winDict, kCGWindowWorkspace)) {
            const void *thing = CFDictionaryGetValue(winDict, kCGWindowWorkspace);
            CFNumberRef numRef = (CFNumberRef)thing;
            CFNumberGetValue(numRef, kCFNumberIntType, &num);
            return num;
        }
    }
    return -1;
}

- (NSString *)activeSpaceIdentifier {
    [[NSUserDefaults standardUserDefaults] removeSuiteNamed:@"com.apple.spaces"];
    [[NSUserDefaults standardUserDefaults] addSuiteNamed:@"com.apple.spaces"];

    NSDictionary *configuration = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"SpacesDisplayConfiguration"];
    NSArray *monitors = configuration[@"Management Data"][@"Monitors"];
    NSDictionary *spaceProperties = configuration[@"Space Properties"];


    NSMutableArray *monitorsArray = [NSMutableArray array];
    for (NSDictionary *monitorDictionary in monitors)
    {
        //NSString *monitorOut = @"Monitor {spaces=[%@]}";
        NSDictionary *currentSpace = monitorDictionary[@"Current Space"];
        NSDictionary *spaces = monitorDictionary[@"Spaces"];

        NSMutableArray *spacesArray = [NSMutableArray array];
        for (NSDictionary *space in spaces){
            NSString *spaceStr = [NSString stringWithFormat:@"Space {id64=\"%@\", uuid=\"%@\"}", space[@"id64"], space[@"uuid"]];
            [spacesArray addObject:spaceStr];
        }

        NSString *spacesStr = [NSString stringWithFormat:@"spaces = [%@]", [spacesArray componentsJoinedByString:@","]];

        // Next: add the spacesStr and display identifier to the Monitor object

        //NSString *displayIdentifier = monitorDictionary[@"Display Identifier"];

        NSString *monitorNameStr = [NSString stringWithFormat:@"nameMonitor=\"%@\"", monitorDictionary[@"Display Identifier"]];

        NSString *monitorStr = [NSString stringWithFormat:@"Monitor {%@, %@}", monitorNameStr, spacesStr];
        [monitorsArray addObject:monitorStr];
    }
    NSString *monitorDataStr = [NSString stringWithFormat:@"MonitorData { monitors = [%@] }", [monitorsArray componentsJoinedByString:@","]];


    NSMutableArray *spaceWindowArray = [NSMutableArray array];
    for (NSDictionary *space in spaceProperties)
    {
        NSString *nameStr = [NSString stringWithFormat:@"name = \"%@\"", space[@"name"]];

        NSDictionary *windows = space[@"windows"];
        NSMutableArray *windowArray = [NSMutableArray array];
        for (id window in windows){
            [windowArray addObject:window];
        }
        NSString *windowIds = [windowArray componentsJoinedByString:@","];
        NSString *windowsStr = [NSString stringWithFormat:@"windows = [%@]", windowIds];

        NSString *spaceWindowStr = [NSString stringWithFormat:@"SpaceWindows {%@, %@}", nameStr, windowsStr];
        [spaceWindowArray addObject:spaceWindowStr];
    }

    NSString *spaceDataStr = [NSString stringWithFormat:@"SpaceData [%@]", [spaceWindowArray componentsJoinedByString:@","]];

    NSString *output = [NSString stringWithFormat:@"AllData {monitorData = %@, spaceData = %@}", monitorDataStr, spaceDataStr];

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
