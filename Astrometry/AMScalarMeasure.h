//
//  AMScalarMeasure.h
//  Astrometry
//
//  Created by Don Willems on 23/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMMeasure.h"

@class AMUnit;

@interface AMScalarMeasure : AMMeasure

- (id) initWithQuantity:(AMQuantity*)quantity numericalValue:(double)value andUnit:(AMUnit*)unit;
- (id) initWithQuantity:(AMQuantity*)quantity numericalValue:(double)value error:(double)error andUnit:(AMUnit*)unit;
- (id) initWithQuantity:(AMQuantity*)quantity numericalValue:(double)value positiveError:(double)positiveError negativeError:(double)negativeError andUnit:(AMUnit*)unit;

@property (readonly) double value;
@property (readonly) double positiveError;
@property (readonly) double negativeError;
@property (readonly) AMUnit* unit;

@end
