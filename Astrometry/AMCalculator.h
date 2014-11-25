//
//  AMCalculator.h
//  Astrometry
//
//  Created by Don Willems on 25/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMCelestialObject,AMMeasure;

@interface AMCalculator : NSObject

- (AMMeasure*) calculateMeasureForCelestialObject:(AMCelestialObject*)object;
- (void) calculateAndInsertMeasureForCelestialObject:(AMCelestialObject*) object;

@end
