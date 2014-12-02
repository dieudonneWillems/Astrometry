//
//  AMLayer.m
//  Astrometry
//
//  Created by Don Willems on 25/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMLayer.h"
#import "AMPlotView.h"
#import "AMPlot.h"

NSString *const AMLayerChangedVisibilityNotification = @"AMLayerChangedVisibilityNotification";
NSString *const AMLayerChangedNotification = @"AMLayerChangedNotification";

@implementation AMLayer

- (id) init {
    self = [super init];
    if(self){
        [self setVisible:YES];
        [self setName:@"Default Layer"];
        _layerIdentifier = [[NSUUID UUID] UUIDString];
    }
    return self;
}

- (BOOL) allowAdditionOfLayerToPlot:(AMPlot*)plot {
    return NO;
}

#pragma mark Actions

- (IBAction) setVisibility:(id)sender {
    NSInteger state = [visibilityCB state];
    if(state == NSOnState){
        [self setVisible:YES];
    }else if(state == NSOffState){
        [self setVisible:NO];
    }
}

- (void) setVisible:(BOOL)visible {
    if(_visible == visible) return;
    _visible = visible;
    if(visible){
        [visibilityCB setState:NSOnState];
    }else{
        [visibilityCB setState:NSOffState];
    }
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSLog(@"Posted layer changed visibility notification");
    [nc postNotificationName:AMLayerChangedVisibilityNotification object:self];
}

- (void) drawRect:(NSRect)rect
           onPlot:(AMPlot*)plot
           inView:(AMPlotView*)view {
    
}

- (void) drawLabelsInRect:(NSRect)rect
                   onPlot:(AMPlot*)plot
                   inView:(AMPlotView*)view {
    
}

- (void) drawAttributedString:(NSAttributedString*)string atPoint:(NSPoint)point relativeToPivot:(NSPoint)pivot withAngle:(double)angle {
    NSAffineTransform *transform = [[NSAffineTransform alloc] init];
    [transform translateXBy:pivot.x yBy:pivot.y];
    [transform rotateByDegrees:angle];
    [transform concat];
    [string drawAtPoint:point];
    [transform invert];
    [transform concat];
}

@end
