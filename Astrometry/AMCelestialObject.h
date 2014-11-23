//
//  AMCelestialObject.h
//  Astrometry
//
//  Created by Don Willems on 23/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMMeasure,AMSphericalCoordinates,AMQuantity;

@interface AMCelestialObject : NSObject {
    NSMutableDictionary *measures;
    NSMutableDictionary *properties;
}

- (id) init;
- (id) initWithPosition:(AMSphericalCoordinates*)position;

- (NSString*) identifier;
- (AMSphericalCoordinates*) position;

- (NSArray*) measures;
- (AMMeasure*) measureForQuantity:(AMQuantity*)quantity;
- (void) setMeasure:(AMMeasure*)measure;
- (NSArray*) quantities;

- (NSArray*) objectProperties;
- (id) objectPropertyForKey:(NSString*)key;
- (void) setObjectProperty:(id)property forKey:(NSString *)key;
- (NSArray*) propertyKeys;

@end
