//
//  AMSearchDescriptor.m
//  Astrometry
//
//  Created by Don Willems on 24/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMSearchDescriptor.h"
#import "AMCelestialObject.h"

@implementation AMSearchDescriptor

- (BOOL) includesCelestialObject:(AMCelestialObject*)object {
    return NO;
}

@end
