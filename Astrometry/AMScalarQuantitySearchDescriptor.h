//
//  AMQuantitySearchDescriptor.h
//  Astrometry
//
//  Created by Don Willems on 24/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMSearchDescriptor.h"

@class AMQuantity,AMUnit;

@interface AMScalarQuantitySearchDescriptor : AMSearchDescriptor

- (id) initForQuantity:(AMQuantity*)quantity maxValue:(double)max minValue:(double)min inUnit:(AMUnit*)unit;

@property (readonly) AMQuantity* quantity;
@property (readonly) AMUnit *unit;
@property (readonly) double maxValue;
@property (readonly) double minValue;
@end
