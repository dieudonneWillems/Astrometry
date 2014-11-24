//
//  AMCatalogueIndexEntry.m
//  Astrometry
//
//  Created by Don Willems on 24/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMCatalogueIndexEntry.h"
#import "AMCelestialObject.h"

@implementation AMCatalogueIndexEntry

- (id) initWithObject:(AMCelestialObject*)object {
    self = [super init];
    if(self){
        _object = object;
    }
    return self;
}

- (NSComparisonResult) compare:(AMCatalogueIndexEntry*)entry {
    return NSOrderedSame;
}

@end
