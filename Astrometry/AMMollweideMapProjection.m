//
//  AMMollweideMapProjection.m
//  Astrometry
//
//  Created by Don Willems on 05/12/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMMollweideMapProjection.h"
#import "AMSphericalCoordinates.h"
#import "AMScalarMeasure.h"
#import "AMAstrometricMap.h"

@interface AMMollweideMapProjection (private)
- (double) calculateThetaWithLatitude:(double)lat andPreviousTheta:(double)ptheta;
@end

@implementation AMMollweideMapProjection


- (NSString*) name {
    return @"Mollweide";
}

// if YES the whole globe is shown and the scale is ignored.
- (BOOL) fullGlobeProjection {
    return YES;
}

- (void) calculateMinimumLongitude:(AMScalarMeasure**)minlon
                  maximumLongitude:(AMScalarMeasure**)maxlon
                   minimumLatitude:(AMScalarMeasure**)minlat
                   maximumLatitude:(AMScalarMeasure**)maxlat
                             inMap:(AMAstrometricMap*)map {
    *minlon = [[AMScalarMeasure alloc] initWithQuantity:[[[map centre] longitude] quantity] numericalValue:0 andUnit:[[[map centre] longitude] unit]];
    *maxlon = [[AMScalarMeasure alloc] initWithQuantity:[[[map centre] longitude] quantity] numericalValue:360 andUnit:[[[map centre] longitude] unit]];
    *minlat = [[AMScalarMeasure alloc] initWithQuantity:[[[map centre] latitude] quantity] numericalValue:-90 andUnit:[[[map centre] latitude] unit]];
    *maxlat = [[AMScalarMeasure alloc] initWithQuantity:[[[map centre] latitude] quantity] numericalValue:90 andUnit:[[[map centre] latitude] unit]];
}

- (NSPoint) pointForSphericalCoordinates:(AMSphericalCoordinates*)coordinates
                   withCentreCoordinates:(AMSphericalCoordinates*)centre {
    AMSphericalCoordinates *local = [self convert:coordinates toLocalSystemWithCentre:centre];
    double lat = [[local latitude] value];
    double theta = lat/180*M_PI;
    //theta in radians!
    if(fabs(lat)!=90) theta = [self calculateThetaWithLatitude:lat/180*M_PI andPreviousTheta:theta];
    double x = [[local longitude] value]*cos(theta)/180;
    double y = sin(theta)/2;
    return NSMakePoint(x, y);
}

- (AMSphericalCoordinates*) sphericalCoordinatesForPoint:(NSPoint)point
                                   withCentreCoordinates:(AMSphericalCoordinates*)centre {
    // theta in radians!
    double theta = asin(2*point.y);
    double lat = 180/M_PI*asin((2*theta+sin(2*theta))/M_PI);
    double lon = 180/M_PI*M_PI*point.x/cos(theta);
    AMScalarMeasure *longitude = [[AMScalarMeasure alloc] initWithQuantity:[[centre longitude] quantity] numericalValue:lon andUnit:[[centre longitude] unit]];
    AMScalarMeasure *latitude = [[AMScalarMeasure alloc] initWithQuantity:[[centre latitude] quantity] numericalValue:lat andUnit:[[centre latitude] unit]];
    AMSphericalCoordinates *local = [[AMSphericalCoordinates alloc] initWithCoordinateLongitude:longitude latitude:latitude inCoordinateSystem:nil];
    AMSphericalCoordinates *coord = [self convert:local fromLocalSystemWithCentre:centre];
    return coord;
    
}

// theta in radians!
- (double) calculateThetaWithLatitude:(double)lat andPreviousTheta:(double)ptheta {
    double theta = ptheta-(2*ptheta+sin(2*ptheta)-M_PI*sin(lat))/(2+2*cos(2*ptheta));
    if(fabs(theta-ptheta)>0.000001) theta = [self calculateThetaWithLatitude:lat andPreviousTheta:theta];
    return theta;
}

@end
