//
//  AMMapGridLayer.h
//  Astrometry
//
//  Created by Don Willems on 27/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMLayer.h"

@class AMCoordinateSystem;

FOUNDATION_EXPORT NSString *const AMMapGridLayerChangedMajorGridLinePropertiesNotification;
FOUNDATION_EXPORT NSString *const AMMapGridLayerChangedMinorGridLinePropertiesNotification;
FOUNDATION_EXPORT NSString *const AMMapGridLayerChangedMajorGridLineSpacingNotification;
FOUNDATION_EXPORT NSString *const AMMapGridLayerChangedMinorGridLineSpacingNotification;
FOUNDATION_EXPORT NSString *const AMMapGridVisibilityChangedNotification;

@interface AMMapGridLayer : AMLayer{
    IBOutlet NSImageView *imageView;
    IBOutlet NSTextField *nameField;
}

- (id) initWithCoordinateSystem:(AMCoordinateSystem*)cs;

@property (readonly) AMCoordinateSystem* coordinateSystem;

@property (readonly) BOOL drawGrid;
- (void) setDrawGrid:(BOOL)drawGrid;
@property (readonly) double relativeMajorGridLineSpacing; // relative to scale.
- (void) setRelativeMajorGridLineSpacing:(double)relSpacing;
@property (readonly) double relativeMinorGridLineSpacing; // relative to scale.
- (void) setRelativeMinorGridLineSpacing:(double)relSpacing;
@property (readonly) double majorGridLineSpacing; // in degrees
- (void) setMajorGridLineSpacing:(double) spacing;
@property (readonly) double minorGridLineSpacing; // in degrees
- (void) setMinorGridLineSpacing:(double) spacing;

@property (readonly) NSColor *axisLineColor;
- (void) setAxisLineColor:(NSColor*) color;
@property (readonly) NSColor *majorGridLineColor;
- (void) setMajorGridLineColor:(NSColor*) color;
@property (readonly) NSColor *minorGridLineColor;
- (void) setMinorGridLineColor:(NSColor*) color;
@property (readonly) CGFloat axisLineWidth;
- (void) setAxisLineWidth:(CGFloat) width;
@property (readonly) CGFloat majorGridLineWidth;
- (void) setMajorGridLineWidth:(CGFloat) width;
@property (readonly) CGFloat minorGridLineWidth;
- (void) setMinorGridLineWidth:(CGFloat) width;

- (IBAction) changeMajorGridLineColor:(id)sender;
- (IBAction) changeMinorGridLineColor:(id)sender;

@end
