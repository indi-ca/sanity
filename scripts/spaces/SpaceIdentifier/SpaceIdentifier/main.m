//
//  main.m
//  SpaceIdentifier
//
//  Created by Indika Piyasena on 22/08/2015.
//  Copyright (c) 2015 Indika Piyasena. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "ActiveSpaces.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...

        ActiveSpaces *spaces = [[ActiveSpaces alloc]init];
        [spaces activeSpaceIdentifier];
    }
    return 0;
}
