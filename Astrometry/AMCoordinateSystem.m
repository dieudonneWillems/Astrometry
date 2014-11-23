//
//  AMCoordinateSystem.m
//  Astrometry
//
//  Created by Don Willems on 23/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMCoordinateSystem.h"

@implementation AMCoordinateSystem

+ (AMCoordinateSystem*) equatorialCoordinateSystemJ2000 {
    return nil;
}

+ (AMCoordinateSystem*) equatorialCoordinateSystemJ2000AtEpoch:(NSDate*)epoch {
    return nil;
}

+ (AMCoordinateSystem*) galacticCoordinateSystem {
    return nil;
}

- (id) initWithType:(AMCoordinateSystemType)type inEquinox:(NSDate*)equinox onEpoch:(NSDate*)epoch {
    self = [super init];
    if(self){
        _type = type;
        _equinox = equinox;
        _epoch = epoch;
    }
    return self;
}
@end
