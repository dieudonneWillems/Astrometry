//
//  AMPlotView.h
//  Astrometry
//
//  Created by Don Willems on 25/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AMPlot,AMLayer;

@interface AMPlotView : NSView {
}

@property (readwrite) AMPlot *plot;

@end
