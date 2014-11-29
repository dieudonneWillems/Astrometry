//
//  AMAstrometricMap.h
//  Astrometry
//
//  Created by Don Willems on 25/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMPlot.h"

@class AMSphericalCoordinates,AMMapProjection,AMScalarMeasure;

@interface AMAstrometricMap : AMPlot {
    AMScalarMeasure *minimumLongitude;
    AMScalarMeasure *maximumLongitude;
    AMScalarMeasure *minimumLatitude;
    AMScalarMeasure *maximumLatitude;
}

- (id) init;
- (id) initWithCoordinates:(AMSphericalCoordinates*)coord andScale:(double)scale;

@property (readonly) BOOL useRectangularViewPort;
- (void) setUseRectangularViewPort:(BOOL)useRectangularViewPort;
@property (readonly) AMSphericalCoordinates* centre;
- (void) setCentre:(AMSphericalCoordinates *)centre;
@property (readonly) double scale;
- (void) setScale:(double)scale;
@property (readonly) AMMapProjection *projection;
- (void) setMapProjection:(AMMapProjection*)projection;

- (AMScalarMeasure*) minimumLongitude;
- (AMScalarMeasure*) maximumLongitude;
- (AMScalarMeasure*) minimumLatitude;
- (AMScalarMeasure*) maximumLatitude;


- (AMSphericalCoordinates*) sphericalCoordinatesForLocation:(NSPoint)location inViewRect:(NSRect)viewRect;
- (AMSphericalCoordinates*) sphericalCoordinatesForLocation:(NSPoint)location inView:(AMPlotView*)view;
- (NSPoint) locationInView:(AMPlotView *)view forSphericalCoordinates:(AMSphericalCoordinates*) coodinates;
@end
