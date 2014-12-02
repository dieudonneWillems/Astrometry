//
//  AMLayer.h
//  Astrometry
//
//  Created by Don Willems on 25/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AMListItemController.h"

FOUNDATION_EXPORT NSString *const AMLayerChangedVisibilityNotification;
FOUNDATION_EXPORT NSString *const AMLayerChangedNotification;

@class AMPlotView,AMPlot;

@interface AMLayer : AMListItemController {
    IBOutlet NSButton *visibilityCB;
}

// Needs to be overrided by subclasses
// Tests whether a layer can be added to a specific type of plot.
// e.g. map layers should only be added to map plots and not to CMB plots.
- (BOOL) allowAdditionOfLayerToPlot:(AMPlot*)plot;

- (IBAction) setVisibility:(id)sender;

@property (readwrite) NSString *name;
@property (readonly) NSString *layerIdentifier;
@property (readwrite) AMPlot *plot;
@property (readonly) BOOL visible;

- (void) setVisible:(BOOL)visible;

- (void) drawRect:(NSRect)rect
           onPlot:(AMPlot*)plot
           inView:(AMPlotView*)view;

- (void) drawLabelsInRect:(NSRect)rect
                   onPlot:(AMPlot*)plot
                   inView:(AMPlotView*)view;

- (void) drawAttributedString:(NSAttributedString*)string atPoint:(NSPoint)point relativeToPivot:(NSPoint)pivot withAngle:(double)angle;

@end
