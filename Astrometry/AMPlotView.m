//
//  AMPlotView.m
//  Astrometry
//
//  Created by Don Willems on 25/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMPlotView.h"
#import "AMPlot.h"
#import "AMLayer.h"

@interface AMPlotView (private)
- (void) layerVisibilityChangedNotificationRecieved:(NSNotification*)notification;
- (void) layersChangedNotifcationReceived:(NSNotification*)notification;
- (void) plotChangedNotificationReceived:(NSNotification*)notification;
- (void) resetViewPort;
- (void) createLayerImages;
- (void) createImageForLayer:(AMLayer*)layer;
@end

@implementation AMPlotView

- (id) init {
    self = [super init];
    if(self){
    }
    return self;
}

- (id) initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if(self){
    }
    return self;
}

- (void) awakeFromNib {
    layerImages = [NSMutableDictionary dictionary];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(layerVisibilityChangedNotificationRecieved:) name:AMLayerChangedVisibilityNotification object:nil];
    [nc addObserver:self selector:@selector(layersChangedNotifcationReceived:) name:AMLayerAddedToPlotNotification object:nil];
    [nc addObserver:self selector:@selector(layersChangedNotifcationReceived:) name:AMLayerRemovedFromPlotNotification object:nil];
    [nc addObserver:self selector:@selector(layersChangedNotifcationReceived:) name:AMLayerChangedNotification object:nil];
    [nc addObserver:self selector:@selector(plotChangedNotificationReceived:) name:AMPlotPropertiesChangedNotification object:nil];
}

- (void) setPlot:(AMPlot *)plot {
    _plot = plot;
    [self resetViewPort];
}

- (void) resetViewPort {
    if([self plot]){
        NSRect vr = [[self plot] viewRect];
        NSRect frame = [self frame];
        frame.origin.x =40;
        frame.origin.y =80;
        frame.size.width -=80;
        frame.size.height -=120;
        if(vr.size.width!=frame.size.width || vr.size.height!=frame.size.height
           || vr.origin.x != frame.origin.x || vr.origin.y!=frame.origin.y){
            [[self plot] setViewRect:frame];
            [self createLayerImages];
        }
    }
}

- (void) layerVisibilityChangedNotificationRecieved:(NSNotification*)notification {
    NSLog(@"Received layer changed visibility notification");
    [self setNeedsDisplay:YES];
}

- (void) layersChangedNotifcationReceived:(NSNotification*)notification {
    if([[notification object] isKindOfClass:[AMLayer class]]){
        NSLog(@"Received layer notification %@",notification);
        if([[notification name] isEqualToString:AMLayerAddedToPlotNotification]){
            [self createImageForLayer:(AMLayer*)[notification object]];
        }else if([[notification name] isEqualToString:AMLayerRemovedFromPlotNotification]){
            [layerImages removeObjectForKey:[(AMLayer*)[notification object] layerIdentifier]];
        }else {
            [self createImageForLayer:(AMLayer*)[notification object]];
        }
    }
}

- (void) plotChangedNotificationReceived:(NSNotification*)notification {
    if([[notification object] isEqualTo:[self plot]]){
        NSLog(@"Received plot changed notification %@",notification);
        [self createLayerImages];
    }
}


#pragma mark Drawing layers

- (void) createLayerImages {
    [layerImages removeAllObjects];
    NSArray *layers = [[self plot] layers];
    for(AMLayer *layer in layers){
        [self createImageForLayer:layer];
    }
}

- (void) createImageForLayer:(AMLayer*)layer {
    NSRect rect = [self frame];
    rect.origin = NSZeroPoint;
    NSImage *image = [[NSImage alloc] initWithSize:rect.size];
    [image lockFocus];
    [layer drawRect:rect onPlot:[self plot] inView:self];
    [image unlockFocus];
    [layerImages setObject:image forKey:[layer layerIdentifier]];
}

- (void) setNeedsDisplayLayer:(AMLayer*)layer {
    [self createImageForLayer:layer];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    NSLog(@"frame : %@",NSStringFromRect([self frame]));
    [super drawRect:dirtyRect];
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
    NSArray* layers = [[self plot] layers];
    if([layers count] != [layerImages count]){
        [self createLayerImages];
    }
    for(AMLayer *layer in layers){
        if([layer visible]){
            NSImage *image = [layerImages objectForKey:[layer layerIdentifier]];
            [image drawInRect:dirtyRect fromRect:dirtyRect operation:NSCompositeSourceOver fraction:0.5];
        }
    }
}

@end
