//
//  AMCylindricalMapProjection.m
//  Astrometry
//
//  Created by Don Willems on 26/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMEquirectangularMapProjection.h"
#import "AMScalarMeasure.h"
#import "AMSphericalCoordinates.h"
#import "AMCoordinateSystem.h"
#import "AMQuantity.h"
#import "AMUnit.h"

@implementation AMEquirectangularMapProjection

- (NSString*) name {
    return @"Equirectangular";
}

- (NSPoint) pointForSphericalCoordinates:(AMSphericalCoordinates*)coordinates
                   withCentreCoordinates:(AMSphericalCoordinates*)centre {
    AMSphericalCoordinates *local = [self convert:coordinates
                          toLocalSystemWithCentre:centre];
    // todo unit conversion - expected degrees
    NSPoint point = NSMakePoint(-[[local longitude] value], [[local latitude] value]);
    return point;
}

- (AMSphericalCoordinates*) sphericalCoordinatesForPoint:(NSPoint)point
                                   withCentreCoordinates:(AMSphericalCoordinates*)centre {
    AMScalarMeasure *longitude = [[AMScalarMeasure alloc] initWithQuantity:[AMQuantity quantityWithName:@"Longitude"] numericalValue:-point.x andUnit:[AMUnit unitWithName:@"degree"]];
    AMScalarMeasure *latitude = [[AMScalarMeasure alloc] initWithQuantity:[AMQuantity quantityWithName:@"Latitude"] numericalValue:point.y andUnit:[AMUnit unitWithName:@"degree"]];
    AMSphericalCoordinates *ncoord = [[AMSphericalCoordinates alloc] initWithCoordinateLongitude:longitude latitude:latitude inCoordinateSystem:[[AMCoordinateSystem alloc] initWithType:AMLocalCoordinateSystem inEquinox:nil onEpoch:nil]];
    AMSphericalCoordinates *coord = [self convert:ncoord fromLocalSystemWithCentre:centre];
    return coord;
}

@end
