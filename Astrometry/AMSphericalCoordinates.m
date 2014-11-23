//
//  AMSphericalCoordinates.m
//  Astrometry
//
//  Created by Don Willems on 23/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMSphericalCoordinates.h"
#import "AMCoordinateSystem.h"
#import "AMScalarMeasure.h"
#import "AMQuantity.h"

@implementation AMSphericalCoordinates

- (id) initWithCoordinateLongitude:(AMScalarMeasure*)longitude latitude:(AMScalarMeasure*)latitude inCoordinateSystem:(AMCoordinateSystem*)system {
    self = [self initWithCoordinateLongitude:longitude latitude:latitude andDistance:nil inCoordinateSystem:system];
    if(self){
        
    }
    return self;
}

- (id) initWithCoordinateLongitude:(AMScalarMeasure*)longitude latitude:(AMScalarMeasure*)latitude andDistance:(AMScalarMeasure*)distance inCoordinateSystem:(AMCoordinateSystem*)system {
    self = [super initWithQuantity:[AMQuantity quantityWithName:@"Spherical position"]];
    if(self){
        _coordinateSystem = system;
        _longitude = longitude;
        _latitude = latitude;
        _distance = distance;
    }
    return self;
}

- (NSString*) description {
    if([self distance]==nil){
        return [NSString stringWithFormat:@"(%@,%@)",[self longitude],[self latitude]];
    }
    return [NSString stringWithFormat:@"(%@,%@,%@)",[self longitude],[self latitude],[self distance]];
}

@end
