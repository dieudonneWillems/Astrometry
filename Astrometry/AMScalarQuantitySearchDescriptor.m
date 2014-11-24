//
//  AMQuantitySearchDescriptor.m
//  Astrometry
//
//  Created by Don Willems on 24/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMScalarQuantitySearchDescriptor.h"
#import "AMQuantity.h"
#import "AMUnit.h"
#import "AMMeasure.h"
#import "AMScalarQuantity.h"
#import "AMCelestialObject.h"
#import "AMScalarMeasure.h"

@implementation AMScalarQuantitySearchDescriptor

- (id) initForQuantity:(AMQuantity*)quantity maxValue:(double)max minValue:(double)min inUnit:(AMUnit*)unit {
    self = [super init];
    if(self){
        _quantity = quantity;
        _unit = unit;
        _maxValue = max;
        _minValue = min;
    }
    return self;
}

- (BOOL) includesCelestialObject:(AMCelestialObject*)object {
    AMMeasure *measure = [object measureForQuantity:[self quantity]];
    // todo unit conversion
    if([measure isKindOfClass:[AMScalarMeasure class]]){
        AMScalarMeasure* scmeas = (AMScalarMeasure*)measure;
        if([scmeas value]+[scmeas positiveError]>[self minValue] &&
           [scmeas value]-[scmeas negativeError]<[self maxValue]){
            return YES;
        }
    }
    return NO;
}

@end
