//
//  AMPlot.m
//  Astrometry
//
//  Created by Don Willems on 25/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMPlot.h"
#import "AMPlotView.h"
#import "AMCelestialObject.h"
#import "AMLayer.h"

@implementation AMPlot

- (id) init {
    self = [super init];
    if(self){
        layers = [NSMutableArray array];
    }
    return self;
}

- (NSRect) viewRect {
    return _viewRect;
}

- (void) setViewRect:(NSRect)nrect {
    _viewRect = nrect;
}

- (NSArray*) layers {
    return layers;
}

- (void) addLayer:(AMLayer*)layer {
    if(!layers) layers = [NSMutableArray array];
    [layers insertObject:layer atIndex:0];
}

- (void) removeLayer:(AMLayer*)layer {
    [layers removeObject:layer];
}

- (NSArray*) measuresForLocation:(NSPoint)location inView:(AMPlotView*)view {
    return nil;
}

- (NSPoint) locationInView:(AMPlotView*)view forMeasures:(NSArray*)measures {
    return NSZeroPoint;
}

- (NSPoint) locationInView:(AMPlotView*)view forCelestialObject:(AMCelestialObject*) object {
    return [self locationInView:view forMeasures:[object measures]];
}

@end
