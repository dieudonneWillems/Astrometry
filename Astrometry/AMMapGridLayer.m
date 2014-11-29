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

NSString *const AMMapGridLayerChangedMajorGridLineProperties = @"AMMapGridLayerChangedMajorGridLineProperties";
NSString *const AMMapGridLayerChangedMinorGridLineProperties = @"AMMapGridLayerChangedMinorGridLineProperties";
NSString *const AMMapGridLayerChangedMajorGridLineSpacing = @"AMMapGridLayerChangedMajorGridLineSpacing";
NSString *const AMMapGridLayerChangedMinorGridLineSpacing = @"AMMapGridLayerChangedMinorGridLineSpacing";

@interface AMMapGridLayer (private)
- (AMSphericalCoordinates*) coordinatesForLongitude:(double)lon latitude:(double)lat inCoordinateSystems:(AMCoordinateSystem*)cs;
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
        [self setMajorGridLineColor:[NSColor grayColor]];
        [self setMinorGridLineColor:[NSColor lightGrayColor]];
        _coordinateSystem = cs;
    }
    return self;
}

- (BOOL) allowAdditionOfLayerToPlot:(AMPlot*)plot {
    if([plot isKindOfClass:[AMAstrometricMap class]]) return YES; // for maps
    return NO;
}

#pragma mark Setters for properties

- (void) setRelativeMajorGridLineSpacing:(double)relSpacing {
    _relativeMajorGridLineSpacing = relSpacing;
    double scale = 1;
    if([[self plot] isKindOfClass:[AMAstrometricMap class]]){
        scale = [(AMAstrometricMap*)[self plot] scale];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMajorGridLineSpacing object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
}

- (void) setRelativeMinorGridLineSpacing:(double)relSpacing {
    _relativeMinorGridLineSpacing = relSpacing;
    double scale = 1;
    if([[self plot] isKindOfClass:[AMAstrometricMap class]]){
        scale = [(AMAstrometricMap*)[self plot] scale];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMinorGridLineSpacing object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
}

- (void) setMajorGridLineSpacing:(double) spacing {
    _majorGridLineSpacing = spacing;
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMajorGridLineSpacing object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
}

- (void) setMinorGridLineSpacing:(double) spacing {
    _minorGridLineSpacing = spacing;
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMinorGridLineSpacing object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
}

- (void) setMajorGridLineColor:(NSColor*) color {
    _majorGridLineColor = color;
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMajorGridLineProperties object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
}

- (void) setMinorGridLineColor:(NSColor*) color {
    _minorGridLineColor = color;
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMinorGridLineProperties object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
}

- (void) setMajorGridLineWidth:(CGFloat) width {
    _majorGridLineWidth = width;
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMajorGridLineProperties object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
}

- (void) setMinorGridLineWidth:(CGFloat) width {
    _minorGridLineWidth = width;
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMinorGridLineProperties object:self];
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
    double lon,lat;
    [[NSColor blackColor] set];
    AMAstrometricMap *map = (AMAstrometricMap*)plot;
    double maxlon = [[map maximumLongitude] value];
    double minlon = [[map minimumLongitude] value];
    double maxlat = [[map maximumLatitude] value];
    double minlat = [[map minimumLatitude] value];
    
    double clon = [[[(AMAstrometricMap*)plot centre] longitude] value];
    double clat = [[[(AMAstrometricMap*)plot centre] latitude] value];
    
    [[self minorGridLineColor] set];
    for(lon=minlon;lon<=maxlon;lon+=1){
        NSBezierPath *gridline = [NSBezierPath bezierPath];
        for(lat=minlat;lat<=maxlat;lat+=0.1){
            AMSphericalCoordinates *coord = [self coordinatesForLongitude:lon latitude:lat inCoordinateSystems:eqcs];
            NSPoint point = [plot locationInView:view forMeasures:[NSArray arrayWithObject:coord]];
            if([gridline elementCount] <=0){
                [gridline moveToPoint:point];
            }else {
                [gridline lineToPoint:point];
            }
        }
        [gridline setLineWidth:0.5];
        [gridline stroke];
    }
    for(lat=minlat;lat<=maxlat;lat+=1){
        NSBezierPath *gridline = [NSBezierPath bezierPath];
        for(lon=clon-10;lon<=clon+10;lon+=0.1){
            AMSphericalCoordinates *coord = [self coordinatesForLongitude:lon latitude:lat inCoordinateSystems:eqcs];
            NSPoint point = [plot locationInView:view forMeasures:[NSArray arrayWithObject:coord]];
            if([gridline elementCount] <=0){
                [gridline moveToPoint:point];
            }else {
                [gridline lineToPoint:point];
            }
        }
        [gridline setLineWidth:0.5];
        [gridline stroke];
    }
    [[self majorGridLineColor] set];
    for(lon=minlon;lon<=maxlon;lon+=5){
        NSBezierPath *gridline = [NSBezierPath bezierPath];
        for(lat=minlat;lat<=maxlat;lat+=0.1){
            AMSphericalCoordinates *coord = [self coordinatesForLongitude:lon latitude:lat inCoordinateSystems:eqcs];
            NSPoint point = [plot locationInView:view forMeasures:[NSArray arrayWithObject:coord]];
            NSLog(@"Drawing Grid to point: %@ for measure: %@",NSStringFromPoint(point),coord);
            if([gridline elementCount] <=0){
                [gridline moveToPoint:point];
            }else {
                [gridline lineToPoint:point];
            }
        }
        [gridline setLineWidth:0.5];
        [gridline stroke];
    }
    for(lat=minlat;lat<=maxlat;lat+=5){
        NSBezierPath *gridline = [NSBezierPath bezierPath];
        for(lon=clon-10;lon<=clon+10;lon+=0.1){
            AMSphericalCoordinates *coord = [self coordinatesForLongitude:lon latitude:lat inCoordinateSystems:eqcs];
            NSPoint point = [plot locationInView:view forMeasures:[NSArray arrayWithObject:coord]];
            if([gridline elementCount] <=0){
                [gridline moveToPoint:point];
            }else {
                [gridline lineToPoint:point];
            }
        }
        [gridline setLineWidth:0.5];
        [gridline stroke];
    }
}

- (AMSphericalCoordinates*) coordinatesForLongitude:(double)lon latitude:(double)lat inCoordinateSystems:(AMCoordinateSystem*)cs {
    AMSphericalCoordinates *coord = [[AMSphericalCoordinates alloc] initWithCoordinateLongitude:[[AMScalarMeasure alloc] initWithQuantity:[AMQuantity quantityWithName:@"Right ascension"] numericalValue:lon andUnit:[AMUnit unitWithName:@"degree"]] latitude:[[AMScalarMeasure alloc] initWithQuantity:[AMQuantity quantityWithName:@"Declination"] numericalValue:lat andUnit:[AMUnit unitWithName:@"degree"]] inCoordinateSystem:cs];
    return coord;
}

@end
