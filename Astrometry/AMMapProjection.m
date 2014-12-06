//
//  AMMapProjection.m
//  Astrometry
//
//  Created by Don Willems on 26/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMMapProjection.h"
#import "AMSphericalCoordinates.h"
#import "AMScalarMeasure.h"
#import "AMCoordinateSystem.h"
#import "AMQuantity.h"
#import "AMUnit.h"
#import "AMScalarMeasure.h"
#import "AMAstrometricMap.h"

@implementation AMMapProjection


- (NSString*) name {
    return @"";
}

- (BOOL) fullGlobeProjection {
    return NO;
}

- (void) calculateMinimumLongitude:(AMScalarMeasure**)minlon maximumLongitude:(AMScalarMeasure**)maxlon minimumLatitude:(AMScalarMeasure**)minlat maximumLatitude:(AMScalarMeasure**)maxlat inMap:(AMAstrometricMap*)map {
}

- (NSPoint) pointForSphericalCoordinates:(AMSphericalCoordinates*)coordinates
                   withCentreCoordinates:(AMSphericalCoordinates*)centre {
    return NSZeroPoint;
}

- (AMSphericalCoordinates*) sphericalCoordinatesForPoint:(NSPoint)point
                                   withCentreCoordinates:(AMSphericalCoordinates*)centre {
    return nil;
}

- (AMSphericalCoordinates*) convert:(AMSphericalCoordinates*)coordinates
            toLocalSystemWithCentre:(AMSphericalCoordinates*)centre {
    // todo convert units
    // todo convert coordinate systems
    if([[coordinates latitude] value]<-90 || [[coordinates latitude] value]>90) return nil;
    double lon = [[coordinates longitude] value]/180.*M_PI;
    double lat = [[coordinates latitude] value]/180.*M_PI;
    double clon = [[centre longitude] value]/180.*M_PI;
    double clat = [[centre latitude] value]/180.*M_PI;
    while(clon>2*M_PI) clon-=2*M_PI;
    while(clon<0) clon+=2*M_PI;
    double x = cos(lon)*cos(lat);
    double y = sin(lon)*cos(lat);
    double z = sin(lat);
    double x1 = cos(-clon)*x-sin(-clon)*y; // rotation about z
    double y1 = sin(-clon)*x+cos(-clon)*y;
    double x2 = cos(clat)*x1+sin(clat)*z; // rotation about y
    double z2 = -sin(clat)*x1+cos(clat)*z;
    double nlat = asin(z2)*180/M_PI;
    double nlon = atan2(y1, x2)*180/M_PI;
    //if(nlon<0) nlon+=360;
    AMScalarMeasure *nlongitude = [[AMScalarMeasure alloc] initWithQuantity:[AMQuantity quantityWithName:@"longitude"] numericalValue:nlon andUnit:[AMUnit unitWithName:@"degree"]];
    AMScalarMeasure *nlatitude = [[AMScalarMeasure alloc] initWithQuantity:[AMQuantity quantityWithName:@"latitude"] numericalValue:nlat andUnit:[AMUnit unitWithName:@"degree"]];
    AMSphericalCoordinates *ncoord = [[AMSphericalCoordinates alloc] initWithCoordinateLongitude:nlongitude latitude:nlatitude inCoordinateSystem:[[AMCoordinateSystem alloc] initWithType:AMLocalCoordinateSystem inEquinox:nil onEpoch:nil]];
    return ncoord;
}


- (AMSphericalCoordinates*) convert:(AMSphericalCoordinates*)coordinates
          fromLocalSystemWithCentre:(AMSphericalCoordinates*)centre {
    // todo convert units
    // todo convert coordinate systems
    if([[coordinates latitude] value]<-90 || [[coordinates latitude] value]>90) return nil;
    double lon = [[coordinates longitude] value]/180.*M_PI;
    double lat = [[coordinates latitude] value]/180.*M_PI;
    double clon = [[centre longitude] value]/180.*M_PI;
    while(clon>2*M_PI) clon-=2*M_PI;
    while(clon<0) clon+=2*M_PI;
    double clat = [[centre latitude] value]/180.*M_PI;
    double x = cos(lon)*cos(lat);
    double y = sin(lon)*cos(lat);
    double z = sin(lat);
    double x2 = cos(-clat)*x+sin(-clat)*z; // rotation about y
    double z2 = -sin(-clat)*x+cos(-clat)*z;
    double x1 = cos(clon)*x2-sin(clon)*y; // rotation about z
    double y1 = sin(clon)*x2+cos(clon)*y;
    double nlat = asin(z2)*180/M_PI;
    double nlon = atan2(y1, x1)*180/M_PI;
    if(nlon<0) nlon+=360;
    AMScalarMeasure *nlongitude = [[AMScalarMeasure alloc] initWithQuantity:[AMQuantity quantityWithName:@"longitude"] numericalValue:nlon andUnit:[AMUnit unitWithName:@"degree"]];
    AMScalarMeasure *nlatitude = [[AMScalarMeasure alloc] initWithQuantity:[AMQuantity quantityWithName:@"latitude"] numericalValue:nlat andUnit:[AMUnit unitWithName:@"degree"]];
    AMSphericalCoordinates *ncoord = [[AMSphericalCoordinates alloc] initWithCoordinateLongitude:nlongitude latitude:nlatitude inCoordinateSystem:[[AMCoordinateSystem alloc] initWithType:AMLocalCoordinateSystem inEquinox:nil onEpoch:nil]];
    return ncoord;
}
@end
