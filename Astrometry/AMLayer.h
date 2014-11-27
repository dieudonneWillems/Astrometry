//
//  AMLayer.h
//  Astrometry
//
//  Created by Don Willems on 25/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AMListItemController.h"

@class AMPlotView,AMPlot;

@interface AMLayer : AMListItemController {
}

@property (readwrite) BOOL visible;

- (void) drawRect:(NSRect)rect
           onPlot:(AMPlot*)plot
           inView:(AMPlotView*)view;

@end
