//
//  AMCatalogueIndexEntry.h
//  Astrometry
//
//  Created by Don Willems on 24/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMCelestialObject;

@interface AMCatalogueIndexEntry : NSObject

- (id) initWithObject:(AMCelestialObject*)object;

@property (readonly) AMCelestialObject* object;

- (NSComparisonResult) compare:(AMCatalogueIndexEntry*)entry;

@end
