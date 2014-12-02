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
        displayRectangles = [NSMutableDictionary dictionary];
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

- (AMLayer*) layerForIdentifier:(NSString*)layerid {
    for(AMLayer *layer in layers){
        if([[layer layerIdentifier] isEqualToString:layerid]){
            return layer;
        }
    }
    return nil;
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



#pragma mark Determining Free areas for drawing

- (BOOL) freeForDrawingInRect:(NSRect)rect {
    NSArray *layerids = [displayRectangles allKeys];
    for(NSString *layerid in layerids){
        AMLayer *layer = [self layerForIdentifier:layerid];
        if([layer visible]){
            NSArray *layerrects = [displayRectangles objectForKey:layerid];
            for(NSValue *value in layerrects){
                NSRect testRect = [value rectValue];
                if(NSIntersectsRect(rect, testRect)) return NO;
            }
        }
    }
    return YES;
}

- (void) addDrawingRect:(NSRect)rect fromLayer:(AMLayer*)layer {
    NSMutableArray *layerrects = [displayRectangles objectForKey:[layer layerIdentifier]];
    if(!layerrects){
        layerrects = [NSMutableArray array];
        [displayRectangles setObject:layerrects forKey:[layer layerIdentifier]];
    }
    [layerrects addObject:[NSValue valueWithRect:rect]];
}

- (void) removeAllDrawingRectsForLayer:(AMLayer*)layer {
    [displayRectangles removeObjectForKey:[layer layerIdentifier]];
}

- (void) resetDrawingRects {
    return [displayRectangles removeAllObjects];
}

@end
