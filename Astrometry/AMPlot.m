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

NSString *const AMLayerAddedToPlotNotification = @"AMLayerAddedToPlotNotification";
NSString *const AMLayerRemovedFromPlotNotification = @"AMLayerRemovedFromPlotNotification";
NSString *const AMPlotPropertiesChangedNotification = @"AMPlotPropertiesChangedNotification";

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
    [[NSNotificationCenter defaultCenter] postNotificationName:AMPlotPropertiesChangedNotification object:self];
}

- (NSArray*) layers {
    return layers;
}

- (void) addLayer:(AMLayer*)layer {
    if([layer allowAdditionOfLayerToPlot:self]){
        if([layer plot]) [[layer plot] removeLayer:layer];
        if(!layers) layers = [NSMutableArray array];
        [layers insertObject:layer atIndex:0];
        [layer setPlot:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerAddedToPlotNotification object:layer];
    }
}

- (void) removeLayer:(AMLayer*)layer {
    if([[layer plot] isEqualTo:self]){
        [layers removeObject:layer];
        [layer setPlot:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerRemovedFromPlotNotification object:layer];
    }
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
