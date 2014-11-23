//
//  AMSphericalCoordinates.h
//  Astrometry
//
//  Created by Don Willems on 23/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMMeasure.h"

@class AMCoordinateSystem,AMScalarMeasure;

@interface AMSphericalCoordinates : AMMeasure

- (id) initWithCoordinateLongitude:(AMScalarMeasure*)longitude latitude:(AMScalarMeasure*)latitude inCoordinateSystem:(AMCoordinateSystem*)system;

- (id) initWithCoordinateLongitude:(AMScalarMeasure*)longitude latitude:(AMScalarMeasure*)latitude andDistance:(AMScalarMeasure*)distance inCoordinateSystem:(AMCoordinateSystem*)system;

@property (readonly) AMCoordinateSystem *coordinateSystem;
@property (readonly) AMScalarMeasure *longitude;
@property (readonly) AMScalarMeasure *latitude;
@property (readonly) AMScalarMeasure *distance;

@end
