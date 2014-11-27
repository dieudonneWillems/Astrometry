//
//  AMPlot.h
//  Astrometry
//
//  Created by Don Willems on 25/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AMListItemController.h"

@class AMPlotView,AMCelestialObject,AMLayer;

@interface AMPlot : AMListItemController {
    NSMutableArray *layers;
    NSRect _viewRect;
}

- (id) init;

- (NSRect) viewRect;
- (void) setViewRect:(NSRect)nrect;

#pragma mark Layers

- (NSArray*) layers;
- (void) addLayer:(AMLayer*)layer;
- (void) removeLayer:(AMLayer*)layer;


#pragma mark Coordinate space conversions

- (NSArray*) measuresForLocation:(NSPoint)location inView:(AMPlotView*)view;
- (NSPoint) locationInView:(AMPlotView*)view forMeasures:(NSArray*)measures;
- (NSPoint) locationInView:(AMPlotView*)view forCelestialObject:(AMCelestialObject*) object;
@end
