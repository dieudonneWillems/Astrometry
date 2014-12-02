//
//  AMMapGridLayer.h
//  Astrometry
//
//  Created by Don Willems on 27/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMLayer.h"
#import "AMTypes.h"

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
@property (readonly) double relativeMajorLongitudeGridLineSpacing; // relative to scale.
- (void) setRelativeMajorLongitudeGridLineSpacing:(double)relSpacing;
@property (readonly) double relativeMinorLongitudeGridLineSpacing; // relative to scale.
- (void) setRelativeMinorLongitudeGridLineSpacing:(double)relSpacing;
@property (readonly) double majorLongitudeGridLineSpacing; // in degrees
- (void) setMajorLongitudeGridLineSpacing:(double) spacing;
@property (readonly) double minorLongitudeGridLineSpacing; // in degrees
- (void) setMinorLongitudeGridLineSpacing:(double) spacing;
@property (readonly) double relativeMajorLatitudeGridLineSpacing; // relative to scale.
- (void) setRelativeMajorLatitudeGridLineSpacing:(double)relSpacing;
@property (readonly) double relativeMinorLatitudeGridLineSpacing; // relative to scale.
- (void) setRelativeMinorLatitudeGridLineSpacing:(double)relSpacing;
@property (readonly) double majorLatitudeGridLineSpacing; // in degrees
- (void) setMajorLatitudeGridLineSpacing:(double) spacing;
@property (readonly) double minorLatitudeGridLineSpacing; // in degrees
- (void) setMinorLatitudeGridLineSpacing:(double) spacing;

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

@property (readonly) NSFont* coordinateFont;
- (void) setCoordinateFont:(NSFont *)coordinateFont;
@property (readonly) NSColor* coordinateColor;
- (void) setCoordinateColor:(NSColor *)coordinateColor;
@property (readonly) BOOL alwaysDrawFullCoordinateString;
- (void) setAlwaysDrawFullCoordinateString:(BOOL)alwaysDrawFullCoordinateString;

- (IBAction) changeMajorGridLineColor:(id)sender;
- (IBAction) changeMinorGridLineColor:(id)sender;

- (NSAttributedString*) attributedStringForLongitude:(double)lon forCoordinateSystemType:(AMCoordinateSystemType)type forceShowCompleteString:(BOOL)complete;
- (NSAttributedString*) attributedStringForLatitude:(double)lat forCoordinateSystemType:(AMCoordinateSystemType)type forceShowCompleteString:(BOOL)complete;
@end
