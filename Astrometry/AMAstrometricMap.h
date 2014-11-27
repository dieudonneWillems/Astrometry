//
//  AMAstrometricMap.h
//  Astrometry
//
//  Created by Don Willems on 25/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMPlot.h"

@class AMSphericalCoordinates,AMMapProjection;

@interface AMAstrometricMap : AMPlot

- (id) init;
- (id) initWithCoordinates:(AMSphericalCoordinates*)coord andScale:(double)scale;

@property (readwrite) AMSphericalCoordinates* centre;
@property (readwrite) double scale;
@property (readwrite) AMMapProjection *projection;

@end
