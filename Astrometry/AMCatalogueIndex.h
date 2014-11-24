//
//  AMCatalogueIndex.h
//  Astrometry
//
//  Created by Don Willems on 24/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMCelestialObject,AMCatalogueIndexEntry;

@interface AMCatalogueIndex : NSObject {
    NSMutableArray *indexEntries;
}

- (id) init;

- (void) addCelestialObject:(AMCelestialObject*)object;
- (AMCelestialObject*) celestialObjectAtIndex:(NSUInteger)index;
- (NSArray*) celestialObjectsInRange:(NSRange)range;
- (void) insertCatalogueIndexEntry:(AMCatalogueIndexEntry*)entry;
- (NSUInteger) indexOfEntry:(AMCatalogueIndexEntry*)entry;

@end
