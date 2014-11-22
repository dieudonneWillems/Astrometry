//
//  AMCatalogue.h
//  Astrometry
//
//  Created by Don Willems on 22/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMTypes.h"

@interface AMCatalogue : NSObject {
    AMCelestialObject **objects;
    AMQuantity **quantities;
    AMPropertyKey **properties;
    NSInteger nObjects;
    NSInteger nProperties;
    NSInteger nQuantities;
}

@property (readwrite) NSString *name;
@property (readwrite) NSString *catalogueDescription;

- (void) addCelestialObject:(AMCelestialObject*)object;
@end
