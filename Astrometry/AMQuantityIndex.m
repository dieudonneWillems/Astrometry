//
//  AMQuantityIndex.m
//  Astrometry
//
//  Created by Don Willems on 24/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMQuantityIndex.h"

#import "AMMeasure.h"
#import "AMQuantity.h"
#import "AMCelestialObject.h"

@implementation AMQuantityIndex

- (id) initWithQuantity:(AMQuantity*)quantity {
    self = [super init];
    if(self){
        _quantity = quantity;
    }
    return self;
}

- (void) addCelestialObject:(AMCelestialObject*)object {
    AMMeasure *measure = [object measureForQuantity:[self quantity]];
    [self addCelestialObject:object withMeasure:measure];
}

- (void) addCelestialObject:(AMCelestialObject *)object withMeasure:(AMMeasure*)measure {
    
    // todo unit conversion when needed
}

@end
