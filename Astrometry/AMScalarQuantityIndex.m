//
//  AMScalarQuantityIndex.m
//  Astrometry
//
//  Created by Don Willems on 24/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMScalarQuantityIndex.h"
#import "AMUnit.h"
#import "AMMeasure.h"
#import "AMScalarMeasure.h"
#import "AMScalarIndexEntry.h"
#import "AMScalarQuantitySearchDescriptor.h"

@implementation AMScalarQuantityIndex

- (id) initWithQuantity:(AMQuantity*)quantity andUnit:(AMUnit*) unit{
    self = [super initWithQuantity:quantity];
    if(self){
        _unit = unit;
    }
    return self;
}

- (void) addCelestialObject:(AMCelestialObject *)object withMeasure:(AMMeasure*)measure {
    if([measure isKindOfClass:[AMScalarMeasure class]]){
        AMScalarMeasure *scmeas = (AMScalarMeasure*)measure;
        if([self unit]==nil){
            _unit = [scmeas unit];
        }
        
        // todo unit conversion when needed
        
        double value = [scmeas value];
        AMScalarIndexEntry *entry = [[AMScalarIndexEntry alloc] initWithObject:object withValue:value];
        [self insertCatalogueIndexEntry:entry];
    }
}


- (NSRange) rangeForObjectsIncludedInSearchDescriptor:(AMScalarQuantitySearchDescriptor*)searchDescriptor {
    AMScalarIndexEntry *min = [[AMScalarIndexEntry alloc] initWithObject:nil withValue:[searchDescriptor minValue]];
    AMScalarIndexEntry *max = [[AMScalarIndexEntry alloc] initWithObject:nil withValue:[searchDescriptor maxValue]];
    NSUInteger minIndex = [self indexOfEntry:min];
    NSUInteger maxIndex = [self indexOfEntry:max];
    return NSMakeRange(minIndex, maxIndex-minIndex);
}

@end
