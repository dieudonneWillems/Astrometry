//
//  AMSearchDescriptor.h
//  Astrometry
//
//  Created by Don Willems on 24/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMCelestialObject;

@interface AMSearchDescriptor : NSObject

- (BOOL) includesCelestialObject:(AMCelestialObject*)object;
@end
