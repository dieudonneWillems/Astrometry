//
//  AMCatalogue.h
//  Astrometry
//
//  Created by Don Willems on 22/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMTypes.h"

@class AMCelestialObject;

@interface AMCatalogue : NSObject {
    NSMutableArray *objects;
    NSMutableArray *quantities;
    NSMutableArray *properties;
}

@property (readwrite) NSString *name;
@property (readwrite) NSString *catalogueDescription;

- (void) addCelestialObject:(AMCelestialObject*)object;
@end
