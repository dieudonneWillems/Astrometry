//
//  AMCatalogue.h
//  Astrometry
//
//  Created by Don Willems on 22/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMTypes.h"

@class AMCelestialObject,AMQuantity,AMSearchDescriptor;

@interface AMCatalogue : NSObject {
    NSMutableArray *objects;
    NSMutableArray *quantities;
    NSMutableArray *properties;
    NSMutableDictionary *indexes;
    NSMutableArray *fileDefinitions;
}

+ (NSArray*) catalogues;
+ (AMCatalogue*) catalogueForName:(NSString*)name;

@property (readonly) NSString *name;
@property (readwrite) NSString *catalogueDescription;

- (void) setName:(NSString *)name;

- (NSArray*) celestialObjects;

- (void) addCelestialObject:(AMCelestialObject*)object;

- (NSArray*) properties;
- (void) addPropertyKey:(NSString*)key;
- (NSArray*) quantities;
- (void) addQuantity:(AMQuantity*)quantity;

- (void) addCelestialObjectsFromCatalogue:(AMCatalogue*)cat;

- (void) index;
- (AMCatalogue*) subsetUsingSearchDescriptor:(AMSearchDescriptor*)searchDescriptor;
- (NSUInteger) maximumObjectCountUsingSearchDescriptor:(AMSearchDescriptor*)searchDescriptor;

- (NSArray*) fileDefinitions;
- (void) addFileDefinition:(NSXMLElement*)fileDefinitionElement;
@end
