//
//  AMQuantityIndex.h
//  Astrometry
//
//  Created by Don Willems on 24/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AMCatalogueIndex.h"

@class AMMeasure,AMQuantity;

@interface AMQuantityIndex : AMCatalogueIndex

- (id) initWithQuantity:(AMQuantity*)quantity;

@property (readonly) AMQuantity* quantity;

- (void) addCelestialObject:(AMCelestialObject *)object withMeasure:(AMMeasure*)measure;

@end
