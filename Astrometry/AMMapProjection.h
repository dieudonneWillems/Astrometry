//
//  AMMapProjection.h
//  Astrometry
//
//  Created by Don Willems on 26/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMSphericalCoordinates;

@interface AMMapProjection : NSObject

- (NSString*) name;

- (NSPoint) pointForSphericalCoordinates:(AMSphericalCoordinates*)coordinates
                   withCentreCoordinates:(AMSphericalCoordinates*)centre;
- (AMSphericalCoordinates*) sphericalCoordinatesForPoint:(NSPoint)point
                                   withCentreCoordinates:(AMSphericalCoordinates*)centre;

- (AMSphericalCoordinates*) convert:(AMSphericalCoordinates*)coordinates
            toLocalSystemWithCentre:(AMSphericalCoordinates*)centre;

- (AMSphericalCoordinates*) convert:(AMSphericalCoordinates*)coordinates
          fromLocalSystemWithCentre:(AMSphericalCoordinates*)centre;
@end
