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

@class AMPlotView,AMPlot;

@interface AMLayer : AMListItemController {
    IBOutlet NSButton *visibilityCB;
}

- (IBAction) setVisibility:(id)sender;

@property (readonly) BOOL visible;
- (void) setVisible:(BOOL)visible;

- (void) drawRect:(NSRect)rect
           onPlot:(AMPlot*)plot
           inView:(AMPlotView*)view;

@end
