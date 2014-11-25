//
//  AMCalculator.m
//  Astrometry
//
//  Created by Don Willems on 25/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMCalculator.h"
#import "AMCelestialObject.h"
#import "AMMeasure.h"

@implementation AMCalculator

- (AMMeasure*) calculateMeasureForCelestialObject:(AMCelestialObject*)object {
    return nil;
}

- (void) calculateAndInsertMeasureForCelestialObject:(AMCelestialObject*) object {
    AMMeasure *measure = [self calculateMeasureForCelestialObject:object];
    if(measure) [object setMeasure:measure];
}
@end
