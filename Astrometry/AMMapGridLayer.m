//
//  AMMapGridLayer.m
//  Astrometry
//
//  Created by Don Willems on 27/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMMapGridLayer.h"
#import "AMSphericalCoordinates.h"
#import "AMScalarMeasure.h"
#import "AMQuantity.h"
#import "AMUnit.h"
#import "AMCoordinateSystem.h"
#import "AMPlot.h"
#import "AMAstrometricMap.h"
#import "AMAstrometricMap.h"
#import "AMCoordinateSystem.h"

NSString *const AMMapGridLayerChangedMajorGridLinePropertiesNotification = @"AMMapGridLayerChangedMajorGridLinePropertiesNotification";
NSString *const AMMapGridLayerChangedMinorGridLinePropertiesNotification = @"AMMapGridLayerChangedMinorGridLinePropertiesNotification";
NSString *const AMMapGridLayerChangedMajorGridLineSpacingNotification = @"AMMapGridLayerChangedMajorGridLineSpacingNotification";
NSString *const AMMapGridLayerChangedMinorGridLineSpacingNotification = @"AMMapGridLayerChangedMinorGridLineSpacingNotification";
NSString *const AMMapGridVisibilityChangedNotification = @"AMMapGridVisibilityChangedNotification";

@interface AMMapGridLayer (private)
- (AMSphericalCoordinates*) coordinatesForLongitude:(double)lon latitude:(double)lat inCoordinateSystems:(AMCoordinateSystem*)cs;
- (void) drawGridInRect:(NSRect)rect onPlot:(AMAstrometricMap*)map inView:(AMPlotView*)view  withMinimumLongitude:(double)minlon maximumLongitude:(double)maxlon  minimumLatitude:(double)minlat maximumLatitude:(double)maxlat inCoordinateSystem:(AMCoordinateSystem*)eqcs;
- (void) drawAxesInRect:(NSRect)rect onPlot:(AMAstrometricMap*)map inView:(AMPlotView*)view  withMinimumLongitude:(double)minlon maximumLongitude:(double)maxlon  minimumLatitude:(double)minlat maximumLatitude:(double)maxlat inCoordinateSystem:(AMCoordinateSystem*)eqcs;
@end

@implementation AMMapGridLayer

- (id) init {
    self = [self initWithCoordinateSystem:[AMCoordinateSystem equatorialCoordinateSystemJ2000]];
    if(self){
    }
    return self;
}

- (id) initWithCoordinateSystem:(AMCoordinateSystem*)cs {
    self = [super init];
    if(self){
        [self setAxisLineColor:[NSColor darkGrayColor]];
        [self setMajorGridLineColor:[NSColor grayColor]];
        [self setMinorGridLineColor:[NSColor lightGrayColor]];
        [self setAxisLineWidth:1.0];
        [self setMajorGridLineWidth:0.5];
        [self setMinorGridLineWidth:0.3];
        [self setDrawGrid:YES];
        _coordinateSystem = cs;
    }
    return self;
}

- (BOOL) allowAdditionOfLayerToPlot:(AMPlot*)plot {
    if([plot isKindOfClass:[AMAstrometricMap class]]) return YES; // for maps
    return NO;
}

#pragma mark Setters for properties

- (void) setDrawGrid:(BOOL)drawGrid {
    if([self drawGrid] != drawGrid){
        _drawGrid = drawGrid;
        [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridVisibilityChangedNotification object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
    }
}

- (void) setRelativeMajorGridLineSpacing:(double)relSpacing {
    _relativeMajorGridLineSpacing = relSpacing;
    double scale = 1;
    if([[self plot] isKindOfClass:[AMAstrometricMap class]]){
        scale = [(AMAstrometricMap*)[self plot] scale];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMajorGridLineSpacingNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
}

- (void) setRelativeMinorGridLineSpacing:(double)relSpacing {
    _relativeMinorGridLineSpacing = relSpacing;
    double scale = 1;
    if([[self plot] isKindOfClass:[AMAstrometricMap class]]){
        scale = [(AMAstrometricMap*)[self plot] scale];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMinorGridLineSpacingNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
}

- (void) setMajorGridLineSpacing:(double) spacing {
    _majorGridLineSpacing = spacing;
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMajorGridLineSpacingNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
}

- (void) setMinorGridLineSpacing:(double) spacing {
    _minorGridLineSpacing = spacing;
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMinorGridLineSpacingNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
}

- (void) setAxisLineColor:(NSColor*) color {
    _axisLineColor = color;
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMajorGridLinePropertiesNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
}

- (void) setMajorGridLineColor:(NSColor*) color {
    _majorGridLineColor = color;
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMajorGridLinePropertiesNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
}

- (void) setMinorGridLineColor:(NSColor*) color {
    _minorGridLineColor = color;
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMinorGridLinePropertiesNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
}

- (void) setAxisLineWidth:(CGFloat) width {
    _axisLineWidth = width;
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMajorGridLinePropertiesNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
}

- (void) setMajorGridLineWidth:(CGFloat) width {
    _majorGridLineWidth = width;
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMajorGridLinePropertiesNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
}

- (void) setMinorGridLineWidth:(CGFloat) width {
    _minorGridLineWidth = width;
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMinorGridLinePropertiesNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
}

#pragma mark Action

- (IBAction) changeMajorGridLineColor:(id)sender {
    
}

- (IBAction) changeMinorGridLineColor:(id)sender {
    
}

#pragma mark Nib loading

- (NSString*) listItemInfoPanelNibName {
    return nil;
}

- (NSString*) listItemTableCellViewNibName {
    return @"AMMapGridLayerTableCell";
}

- (void) didLoadTableCellViewNib{
    NSLog(@"Table cell view loaded nib");
    NSLog(@"Checkbox: %@",visibilityCB);
}

- (void) didLoadInfoPanelNib{
    
}

#pragma mark Layer drawing

- (void) drawRect:(NSRect)rect
           onPlot:(AMPlot*)plot
           inView:(AMPlotView*)view {
    AMCoordinateSystem *eqcs = [AMCoordinateSystem equatorialCoordinateSystemJ2000];
    AMAstrometricMap *map = (AMAstrometricMap*)plot;
    double maxlon = [[map maximumLongitude] value];
    double minlon = [[map minimumLongitude] value];
    double maxlat = [[map maximumLatitude] value];
    double minlat = [[map minimumLatitude] value];
    if([self drawGrid]){
        [self drawGridInRect:rect onPlot:map inView:view withMinimumLongitude:minlon maximumLongitude:maxlon minimumLatitude:minlat maximumLatitude:maxlat inCoordinateSystem:eqcs];
    }
    [self drawAxesInRect:rect onPlot:map inView:view withMinimumLongitude:minlon maximumLongitude:maxlon minimumLatitude:minlat maximumLatitude:maxlat inCoordinateSystem:eqcs];
}

- (void) drawGridInRect:(NSRect)rect onPlot:(AMAstrometricMap*)map inView:(AMPlotView*)view  withMinimumLongitude:(double)minlon maximumLongitude:(double)maxlon  minimumLatitude:(double)minlat maximumLatitude:(double)maxlat inCoordinateSystem:(AMCoordinateSystem*)eqcs{
    double lon,lat;
    [[NSColor blackColor] set];
    
    [[self minorGridLineColor] set];
    for(lon=minlon;lon<=maxlon;lon+=1){
        NSBezierPath *gridline = [NSBezierPath bezierPath];
        for(lat=minlat;lat<=maxlat;lat+=0.1){
            AMSphericalCoordinates *coord = [self coordinatesForLongitude:lon latitude:lat inCoordinateSystems:eqcs];
            NSPoint point = [map locationInView:view forMeasures:[NSArray arrayWithObject:coord]];
            if(NSPointInRect(point,[map viewRect])){
                if([gridline elementCount] <=0){
                    [gridline moveToPoint:point];
                }else {
                    [gridline lineToPoint:point];
                }
            }else{
                if([gridline elementCount] >0){
                    [gridline setLineWidth:[self minorGridLineWidth]];
                    [gridline stroke];
                    gridline = [NSBezierPath bezierPath];
                }
            }
        }
        if([gridline elementCount] >0){
            [gridline setLineWidth:[self minorGridLineWidth]];
            [gridline stroke];
        }
    }
    for(lat=minlat;lat<=maxlat;lat+=1){
        NSBezierPath *gridline = [NSBezierPath bezierPath];
        for(lon=minlon;lon<=maxlon;lon+=0.1){
            AMSphericalCoordinates *coord = [self coordinatesForLongitude:lon latitude:lat inCoordinateSystems:eqcs];
            NSPoint point = [map locationInView:view forMeasures:[NSArray arrayWithObject:coord]];
            if(NSPointInRect(point,[map viewRect])){
                if([gridline elementCount] <=0){
                    [gridline moveToPoint:point];
                }else {
                    [gridline lineToPoint:point];
                }
            }else{
                if([gridline elementCount] >0){
                    [gridline setLineWidth:[self minorGridLineWidth]];
                    [gridline stroke];
                    gridline = [NSBezierPath bezierPath];
                }
            }
        }
        if([gridline elementCount] >0){
            [gridline setLineWidth:[self minorGridLineWidth]];
            [gridline stroke];
        }
    }
    [[self majorGridLineColor] set];
    for(lon=minlon;lon<=maxlon;lon+=5){
        NSBezierPath *gridline = [NSBezierPath bezierPath];
        for(lat=minlat;lat<=maxlat;lat+=0.1){
            AMSphericalCoordinates *coord = [self coordinatesForLongitude:lon latitude:lat inCoordinateSystems:eqcs];
            NSPoint point = [map locationInView:view forMeasures:[NSArray arrayWithObject:coord]];
            if(NSPointInRect(point,[map viewRect])){
                if([gridline elementCount] <=0){
                    [gridline moveToPoint:point];
                }else {
                    [gridline lineToPoint:point];
                }
            }else{
                if([gridline elementCount] >0){
                    [gridline setLineWidth:[self majorGridLineWidth]];
                    [gridline stroke];
                    gridline = [NSBezierPath bezierPath];
                }
            }
        }
        if([gridline elementCount] >0){
            [gridline setLineWidth:[self majorGridLineWidth]];
            [gridline stroke];
        }
    }
    for(lat=minlat;lat<=maxlat;lat+=5){
        NSBezierPath *gridline = [NSBezierPath bezierPath];
        for(lon=minlon;lon<=maxlon;lon+=0.1){
            AMSphericalCoordinates *coord = [self coordinatesForLongitude:lon latitude:lat inCoordinateSystems:eqcs];
            NSPoint point = [map locationInView:view forMeasures:[NSArray arrayWithObject:coord]];
            if(NSPointInRect(point,[map viewRect])){
                if([gridline elementCount] <=0){
                    [gridline moveToPoint:point];
                }else {
                    [gridline lineToPoint:point];
                }
            }else{
                if([gridline elementCount] >0){
                    [gridline setLineWidth:[self majorGridLineWidth]];
                    [gridline stroke];
                    gridline = [NSBezierPath bezierPath];
                }
            }
        }
        if([gridline elementCount] >0){
            [gridline setLineWidth:[self majorGridLineWidth]];
            [gridline stroke];
        }
    }
}

- (void) drawAxesInRect:(NSRect)rect onPlot:(AMAstrometricMap*)map inView:(AMPlotView*)view  withMinimumLongitude:(double)minlon maximumLongitude:(double)maxlon  minimumLatitude:(double)minlat maximumLatitude:(double)maxlat inCoordinateSystem:(AMCoordinateSystem*)eqcs {
    [[self axisLineColor] set];
    if([map useRectangularViewPort]){
        NSBezierPath *bp = [NSBezierPath bezierPathWithRect:[map viewRect]];
        [bp setLineWidth:[self axisLineWidth]];
        [bp stroke];
    }else {
        NSBezierPath *bp = [NSBezierPath bezierPath];
        double lon,lat;
        for(lon = minlon;lon<=maxlon;lon+=0.1){
            AMSphericalCoordinates *coord = [self coordinatesForLongitude:lon latitude:minlat inCoordinateSystems:eqcs];
            NSPoint point = [map locationInView:view forMeasures:[NSArray arrayWithObject:coord]];
            if([bp elementCount] <=0){
                [bp moveToPoint:point];
            }else {
                [bp lineToPoint:point];
            }
        }
        for(lat = minlat;lat<=maxlat;lat+=0.1){
            AMSphericalCoordinates *coord = [self coordinatesForLongitude:maxlon latitude:lat inCoordinateSystems:eqcs];
            NSPoint point = [map locationInView:view forMeasures:[NSArray arrayWithObject:coord]];
            if([bp elementCount] <=0){
                [bp moveToPoint:point];
            }else {
                [bp lineToPoint:point];
            }
        }
        for(lon = maxlon;lon>=minlon;lon-=0.1){
            AMSphericalCoordinates *coord = [self coordinatesForLongitude:lon latitude:maxlat inCoordinateSystems:eqcs];
            NSPoint point = [map locationInView:view forMeasures:[NSArray arrayWithObject:coord]];
            if([bp elementCount] <=0){
                [bp moveToPoint:point];
            }else {
                [bp lineToPoint:point];
            }
        }
        for(lat = maxlat;lat>=minlat;lat-=0.1){
            AMSphericalCoordinates *coord = [self coordinatesForLongitude:minlon latitude:lat inCoordinateSystems:eqcs];
            NSPoint point = [map locationInView:view forMeasures:[NSArray arrayWithObject:coord]];
            if([bp elementCount] <=0){
                [bp moveToPoint:point];
            }else {
                [bp lineToPoint:point];
            }
        }
        [bp closePath];
        [bp setLineWidth:[self axisLineWidth]];
        [bp stroke];
    }
}

- (AMSphericalCoordinates*) coordinatesForLongitude:(double)lon latitude:(double)lat inCoordinateSystems:(AMCoordinateSystem*)cs {
    AMSphericalCoordinates *coord = [[AMSphericalCoordinates alloc] initWithCoordinateLongitude:[[AMScalarMeasure alloc] initWithQuantity:[AMQuantity quantityWithName:@"Right ascension"] numericalValue:lon andUnit:[AMUnit unitWithName:@"degree"]] latitude:[[AMScalarMeasure alloc] initWithQuantity:[AMQuantity quantityWithName:@"Declination"] numericalValue:lat andUnit:[AMUnit unitWithName:@"degree"]] inCoordinateSystem:cs];
    return coord;
}

@end
