//
//  AMMapProjection.h
//  Astrometry
//
//  Created by Don Willems on 26/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMSphericalCoordinates,AMScalarMeasure,AMAstrometricMap;

@interface AMMapProjection : NSObject

- (NSString*) name;

// if YES the whole globe is shown and the scale is ignored.
- (BOOL) fullGlobeProjection;

- (void) calculateMinimumLongitude:(AMScalarMeasure**)minlon maximumLongitude:(AMScalarMeasure**)maxlon minimumLatitude:(AMScalarMeasure**)minlat maximumLatitude:(AMScalarMeasure**)maxlat inMap:(AMAstrometricMap*)map;

- (NSPoint) pointForSphericalCoordinates:(AMSphericalCoordinates*)coordinates
                   withCentreCoordinates:(AMSphericalCoordinates*)centre;
- (AMSphericalCoordinates*) sphericalCoordinatesForPoint:(NSPoint)point
                                   withCentreCoordinates:(AMSphericalCoordinates*)centre;

- (AMSphericalCoordinates*) convert:(AMSphericalCoordinates*)coordinates
            toLocalSystemWithCentre:(AMSphericalCoordinates*)centre;

- (AMSphericalCoordinates*) convert:(AMSphericalCoordinates*)coordinates
          fromLocalSystemWithCentre:(AMSphericalCoordinates*)centre;
@end
