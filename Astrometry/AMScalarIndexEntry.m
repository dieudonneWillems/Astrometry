//
//  AMScalarIndexEntry.m
//  Astrometry
//
//  Created by Don Willems on 24/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMScalarIndexEntry.h"
#import "AMCelestialObject.h"

@implementation AMScalarIndexEntry

- (id) initWithObject:(AMCelestialObject*)object withValue:(double)value {
    self = [super initWithObject:object];
    if(self){
        _value = value;
    }
    return self;
}

- (NSComparisonResult) compare:(AMCatalogueIndexEntry*)entry {
    if([entry isKindOfClass:[AMScalarIndexEntry class]]){
        if([self value] < [(AMScalarIndexEntry*)entry value]) return NSOrderedAscending;
        if([self value] > [(AMScalarIndexEntry*)entry value]) return NSOrderedDescending;
    }
    return NSOrderedSame;
}

@end
