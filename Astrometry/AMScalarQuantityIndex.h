//
//  AMScalarQuantityIndex.h
//  Astrometry
//
//  Created by Don Willems on 24/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AMQuantityIndex.h"

@class AMUnit,AMScalarQuantitySearchDescriptor;

@interface AMScalarQuantityIndex : AMQuantityIndex

- (id) initWithQuantity:(AMQuantity*)quantity andUnit:(AMUnit*) unit;

@property (readonly) AMUnit* unit;

- (NSRange) rangeForObjectsIncludedInSearchDescriptor:(AMScalarQuantitySearchDescriptor*)searchDescriptor;
@end
