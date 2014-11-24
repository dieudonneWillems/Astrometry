//
//  AMScalarIndexEntry.h
//  Astrometry
//
//  Created by Don Willems on 24/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AMCatalogueIndexEntry.h"

@class AMCelestialObject;

@interface AMScalarIndexEntry : AMCatalogueIndexEntry

- (id) initWithObject:(AMCelestialObject*)object withValue:(double)value;

@property (readonly) double value;

@end
