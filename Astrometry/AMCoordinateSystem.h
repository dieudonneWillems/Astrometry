//
//  AMCoordinateSystem.h
//  Astrometry
//
//  Created by Don Willems on 23/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMTypes.h"

@interface AMCoordinateSystem : NSObject

+ (AMCoordinateSystem*) equatorialCoordinateSystemJ2000;
+ (AMCoordinateSystem*) equatorialCoordinateSystemJ2000AtEpoch:(NSDate*)epoch;
+ (AMCoordinateSystem*) galacticCoordinateSystem;

- (id) initWithType:(AMCoordinateSystemType)type inEquinox:(NSDate*)equinox onEpoch:(NSDate*)epoch;

@property (readonly) AMCoordinateSystemType type;
@property (readonly) NSDate* epoch;
@property (readonly) NSDate* equinox;

@end
