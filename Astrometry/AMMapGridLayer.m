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
        _axisLineColor = [NSColor blackColor];
        _majorGridLineColor =[NSColor grayColor];
        _minorGridLineColor = [NSColor lightGrayColor];
        _axisLineWidth = 1.0;
        _majorGridLineWidth = 0.5;
        _minorGridLineWidth = 0.3;
        _drawGrid = YES;
        _minorLongitudeGridLineSpacing = 15./360.;
        _minorLatitudeGridLineSpacing = 0.05;
        _majorLongitudeGridLineSpacing = 0.25;
        _majorLatitudeGridLineSpacing = 0.25;
        _coordinateSystem = cs;
        _coordinateFont = [NSFont systemFontOfSize:11];
        _coordinateColor = [NSColor blackColor];
        _alwaysDrawFullCoordinateString = NO;
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

- (void) setRelativeMajorLongitudeGridLineSpacing:(double)relSpacing {
    _relativeMajorLongitudeGridLineSpacing = relSpacing;
    double scale = 1;
    if([[self plot] isKindOfClass:[AMAstrometricMap class]]){
        scale = [(AMAstrometricMap*)[self plot] scale];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMajorGridLineSpacingNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
}

- (void) setRelativeMinorLongitudeGridLineSpacing:(double)relSpacing {
    _relativeMinorLongitudeGridLineSpacing = relSpacing;
    double scale = 1;
    if([[self plot] isKindOfClass:[AMAstrometricMap class]]){
        scale = [(AMAstrometricMap*)[self plot] scale];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMinorGridLineSpacingNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
}

- (void) setMajorLongitudeGridLineSpacing:(double) spacing {
    _majorLongitudeGridLineSpacing = spacing;
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMajorGridLineSpacingNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
}

- (void) setMinorLongitudeGridLineSpacing:(double) spacing {
    _minorLongitudeGridLineSpacing = spacing;
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMinorGridLineSpacingNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
}

- (void) setRelativeMajorLatitudeGridLineSpacing:(double)relSpacing {
    _relativeMajorLatitudeGridLineSpacing = relSpacing;
    double scale = 1;
    if([[self plot] isKindOfClass:[AMAstrometricMap class]]){
        scale = [(AMAstrometricMap*)[self plot] scale];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMajorGridLineSpacingNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
}

- (void) setRelativeMinorLatitudeGridLineSpacing:(double)relSpacing {
    _relativeMinorLatitudeGridLineSpacing = relSpacing;
    double scale = 1;
    if([[self plot] isKindOfClass:[AMAstrometricMap class]]){
        scale = [(AMAstrometricMap*)[self plot] scale];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMinorGridLineSpacingNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
}

- (void) setMajorLatitudeGridLineSpacing:(double) spacing {
    _majorLatitudeGridLineSpacing = spacing;
    [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMajorGridLineSpacingNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
}

- (void) setMinorLatitudeGridLineSpacing:(double) spacing {
    _minorLatitudeGridLineSpacing = spacing;
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

- (void) setCoordinateFont:(NSFont *)coordinateFont {
    if(![[self coordinateFont] isEqualTo:coordinateFont]){
        _coordinateFont = coordinateFont;
        [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMinorGridLinePropertiesNotification object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
    }
}

- (void) setCoordinateColor:(NSColor *)coordinateColor {
    if(![[self coordinateColor] isEqualTo:coordinateColor]){
        _coordinateColor = coordinateColor;
        [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMinorGridLinePropertiesNotification object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
    }
}
- (void) setAlwaysDrawFullCoordinateString:(BOOL)alwaysDrawFullCoordinateString {
    if([self alwaysDrawFullCoordinateString]!=alwaysDrawFullCoordinateString){
        _alwaysDrawFullCoordinateString = alwaysDrawFullCoordinateString;
        [[NSNotificationCenter defaultCenter] postNotificationName:AMMapGridLayerChangedMinorGridLinePropertiesNotification object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:AMLayerChangedNotification object:self];
    }
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
    if([map scale]<=0) return;
    double lon,lat;
    [[NSColor blackColor] set];
   // NSBezierPath *rbp = [NSBezierPath bezierPathWithRect:[map viewRect]];
   // [rbp stroke];
    
    [[self minorGridLineColor] set];
    double startlon = (double)((NSInteger) (minlon/[self minorLongitudeGridLineSpacing])+1)*[self minorLongitudeGridLineSpacing];
    double endlon = (double)((NSInteger) (maxlon/[self minorLongitudeGridLineSpacing]))*[self minorLongitudeGridLineSpacing];
    for(lon=startlon;lon<=endlon;lon+=[self minorLongitudeGridLineSpacing]){
        NSBezierPath *gridline = [NSBezierPath bezierPath];
        for(lat=minlat;lat<=maxlat;lat+=[self minorLatitudeGridLineSpacing]/10){
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
    double startlat = (double)((NSInteger) (minlat/[self minorLatitudeGridLineSpacing])+1)*[self minorLatitudeGridLineSpacing];
    double endlat = (double)((NSInteger) (maxlat/[self minorLatitudeGridLineSpacing]))*[self minorLatitudeGridLineSpacing];
    if(minlat<0){
        startlat = (double)((NSInteger) (minlat/[self minorLatitudeGridLineSpacing]))*[self minorLatitudeGridLineSpacing];
    }
    if(maxlat<0){
        endlat = (double)((NSInteger) (maxlat/[self minorLatitudeGridLineSpacing])-1)*[self minorLatitudeGridLineSpacing];
    }
    for(lat=startlat;lat<=endlat;lat+=[self minorLatitudeGridLineSpacing]){
        NSBezierPath *gridline = [NSBezierPath bezierPath];
        for(lon=minlon;lon<=maxlon;lon+=[self minorLongitudeGridLineSpacing]/10){
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
    startlon = (double)((NSInteger) (minlon/[self majorLongitudeGridLineSpacing])+1)*[self majorLongitudeGridLineSpacing];
    endlon = (double)((NSInteger) (maxlon/[self majorLongitudeGridLineSpacing]))*[self majorLongitudeGridLineSpacing];
    for(lon=startlon;lon<=endlon;lon+=[self majorLongitudeGridLineSpacing]){
        NSBezierPath *gridline = [NSBezierPath bezierPath];
        for(lat=minlat;lat<=maxlat;lat+=[self minorLatitudeGridLineSpacing]/10){
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
    startlat = (double)((NSInteger) (minlat/[self majorLatitudeGridLineSpacing])+1)*[self majorLatitudeGridLineSpacing];
    endlat = (double)((NSInteger) (maxlat/[self majorLatitudeGridLineSpacing]))*[self majorLatitudeGridLineSpacing];
    if(minlat<0){
        startlat = (double)((NSInteger) (minlat/[self majorLatitudeGridLineSpacing]))*[self majorLatitudeGridLineSpacing];
    }
    if(maxlat<0){
        endlat = (double)((NSInteger) (maxlat/[self majorLatitudeGridLineSpacing])-1)*[self majorLatitudeGridLineSpacing];
    }
    for(lat=startlat;lat<=endlat;lat+=[self majorLatitudeGridLineSpacing]){
        NSBezierPath *gridline = [NSBezierPath bezierPath];
        for(lon=minlon;lon<=maxlon;lon+=[self minorLongitudeGridLineSpacing]/10){
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


#pragma mark Label drawing

- (void) drawLabelsInRect:(NSRect)rect
                   onPlot:(AMPlot*)plot
                   inView:(AMPlotView*)view {
    [[self majorGridLineColor] set];
    AMCoordinateSystem *eqcs = [AMCoordinateSystem equatorialCoordinateSystemJ2000];
    AMAstrometricMap *map = (AMAstrometricMap*)[self plot];
    double maxlon = [[map maximumLongitude] value];
    double minlon = [[map minimumLongitude] value];
    double maxlat = [[map maximumLatitude] value];
    double minlat = [[map minimumLatitude] value];
    double startlon = (double)((NSInteger) (minlon/[self majorLongitudeGridLineSpacing])+1)*[self majorLongitudeGridLineSpacing];
    double endlon = (double)((NSInteger) (maxlon/[self majorLongitudeGridLineSpacing]))*[self majorLongitudeGridLineSpacing];
    double lon,lat;
    for(lon=startlon;lon<=endlon;lon+=[self majorLongitudeGridLineSpacing]){
        lat = minlat;
        AMSphericalCoordinates *coord = [self coordinatesForLongitude:lon latitude:lat inCoordinateSystems:eqcs];
        NSPoint point = [map locationInView:view forMeasures:[NSArray arrayWithObject:coord]];
        if(NSPointInRect(point,rect)){
            NSAttributedString *string = [self attributedStringForLongitude:lon forCoordinateSystemType:[eqcs type] forceShowCompleteString:(lon==startlon || lon==endlon)];
            NSSize size = [string size];
            AMSphericalCoordinates *coord2 = [self coordinatesForLongitude:lon latitude:minlat-[self minorLatitudeGridLineSpacing]/10. inCoordinateSystems:eqcs];
            NSPoint point2 = [map locationInView:view forMeasures:[NSArray arrayWithObject:coord2]];
            double angle = 180./M_PI*atan2((point2.y-point.y),(point2.x-point.x));
            NSPoint p = NSZeroPoint;
            if(angle>135){
                angle-=180;
                p.x = -size.width-0.3*size.height;
                p.y = -size.height/2;
            }else if(angle<-135){
                angle+=180;
                p.x = -size.width-0.3*size.height;
                p.y = -size.height/2;
            }else if(angle>45){
                angle-=90;
                p.x = -size.width/2;
                p.y = +size.height*0.1;
            }else if(angle<-45){
                angle+=90;
                p.x = -size.width/2;
                p.y = -size.height*1.1;
            }else {
                p.x = +size.height*0.3;
                p.y = -size.height/2;
            }
            [self drawAttributedString:string atPoint:p relativeToPivot:point withAngle:angle];
        }
    }
    for(lon=startlon;lon<=endlon;lon+=[self majorLongitudeGridLineSpacing]){
        lat = maxlat;
        AMSphericalCoordinates *coord = [self coordinatesForLongitude:lon latitude:lat inCoordinateSystems:eqcs];
        NSPoint point = [map locationInView:view forMeasures:[NSArray arrayWithObject:coord]];
        if(NSPointInRect(point,rect)){
            NSAttributedString *string = [self attributedStringForLongitude:lon forCoordinateSystemType:[eqcs type] forceShowCompleteString:(lon==startlon || lon==endlon)];
            NSSize size = [string size];
            AMSphericalCoordinates *coord2 = [self coordinatesForLongitude:lon latitude:maxlat+[self minorLatitudeGridLineSpacing]/10. inCoordinateSystems:eqcs];
            NSPoint point2 = [map locationInView:view forMeasures:[NSArray arrayWithObject:coord2]];
            double angle = 180./M_PI*atan2((point2.y-point.y),(point2.x-point.x));
            NSPoint p = NSZeroPoint;
            if(angle>135){
                angle-=180;
                p.x = -size.width-0.3*size.height;
                p.y = -size.height/2;
            }else if(angle<-135){
                angle+=180;
                p.x = -size.width-0.3*size.height;
                p.y = -size.height/2;
            }else if(angle>45){
                angle-=90;
                p.x = -size.width/2;
                p.y = +size.height*0.1;
            }else if(angle<-45){
                angle+=90;
                p.x = -size.width/2;
                p.y = -size.height*1.1;
            }else {
                p.x = +size.height*0.3;
                p.y = -size.height/2;
            }
            [self drawAttributedString:string atPoint:p relativeToPivot:point withAngle:angle];
        }
    }
    double startlat = (double)((NSInteger) (minlat/[self majorLatitudeGridLineSpacing])+1)*[self majorLatitudeGridLineSpacing];
    double endlat = (double)((NSInteger) (maxlat/[self majorLatitudeGridLineSpacing]))*[self majorLatitudeGridLineSpacing];
    if(minlat<0){
        startlat = (double)((NSInteger) (minlat/[self majorLatitudeGridLineSpacing]))*[self majorLatitudeGridLineSpacing];
    }
    if(maxlat<0){
        endlat = (double)((NSInteger) (maxlat/[self majorLatitudeGridLineSpacing])-1)*[self majorLatitudeGridLineSpacing];
    }
    for(lat=startlat;lat<=endlat;lat+=[self majorLatitudeGridLineSpacing]){
        lon = minlon;
        AMSphericalCoordinates *coord = [self coordinatesForLongitude:lon latitude:lat inCoordinateSystems:eqcs];
        NSPoint point = [map locationInView:view forMeasures:[NSArray arrayWithObject:coord]];
        if(NSPointInRect(point,rect)){
            NSAttributedString *string = [self attributedStringForLatitude:lat forCoordinateSystemType:[eqcs type] forceShowCompleteString:(lat==startlat || lat==endlat)];
            NSSize size = [string size];
            AMSphericalCoordinates *coord2 = [self coordinatesForLongitude:minlon-[self minorLongitudeGridLineSpacing]/10. latitude:lat inCoordinateSystems:eqcs];
            NSPoint point2 = [map locationInView:view forMeasures:[NSArray arrayWithObject:coord2]];
            double angle = 180./M_PI*atan2((point2.y-point.y),(point2.x-point.x));
            NSPoint p = NSZeroPoint;
            if(angle>135){
                angle-=180;
                p.x = -size.width-0.3*size.height;
                p.y = -size.height/2;
            }else if(angle<-135){
                angle+=180;
                p.x = -size.width-0.3*size.height;
                p.y = -size.height/2;
            }else if(angle>45){
                angle-=90;
                p.x = -size.width/2;
                p.y = +size.height*0.1;
            }else if(angle<-45){
                angle+=90;
                p.x = -size.width/2;
                p.y = -size.height*1.1;
            }else {
                p.x = +size.height*0.3;
                p.y = -size.height/2;
            }
            [self drawAttributedString:string atPoint:p relativeToPivot:point withAngle:angle];
        }
    }
    for(lat=startlat;lat<=endlat;lat+=[self majorLatitudeGridLineSpacing]){
        lon = maxlon;
        AMSphericalCoordinates *coord = [self coordinatesForLongitude:lon latitude:lat inCoordinateSystems:eqcs];
        NSPoint point = [map locationInView:view forMeasures:[NSArray arrayWithObject:coord]];
        if(NSPointInRect(point,rect)){
            NSAttributedString *string = [self attributedStringForLatitude:lat forCoordinateSystemType:[eqcs type] forceShowCompleteString:(lat==startlat || lat==endlat)];
            NSSize size = [string size];
            AMSphericalCoordinates *coord2 = [self coordinatesForLongitude:maxlon+[self minorLongitudeGridLineSpacing]/10. latitude:lat inCoordinateSystems:eqcs];
            NSPoint point2 = [map locationInView:view forMeasures:[NSArray arrayWithObject:coord2]];
            double angle = 180./M_PI*atan2((point2.y-point.y),(point2.x-point.x));
            NSPoint p = NSZeroPoint;
            if(angle>135){
                angle-=180;
                p.x = -size.width-0.3*size.height;
                p.y = -size.height/2;
            }else if(angle<-135){
                angle+=180;
                p.x = -size.width-0.3*size.height;
                p.y = -size.height/2;
            }else if(angle>45){
                angle-=90;
                p.x = -size.width/2;
                p.y = +size.height*0.1;
            }else if(angle<-45){
                angle+=90;
                p.x = -size.width/2;
                p.y = -size.height*1.1;
            }else {
                p.x = +size.height*0.3;
                p.y = -size.height/2;
            }
            [self drawAttributedString:string atPoint:p relativeToPivot:point withAngle:angle];
        }
    }
}

- (NSAttributedString*) attributedStringForLongitude:(double)lon forCoordinateSystemType:(AMCoordinateSystemType)type forceShowCompleteString:(BOOL)complete {
    if(type==AMEquatortialCoordinateSystem){
        NSFont *superScriptFont = [[NSFontManager sharedFontManager] convertFont:[self coordinateFont] toSize:[[self coordinateFont] pointSize]-2];
        NSDictionary *coordAttr = [NSDictionary dictionaryWithObjectsAndKeys:[self coordinateFont],NSFontAttributeName, nil];
        NSDictionary *superscriptAttr = [NSDictionary dictionaryWithObjectsAndKeys:superScriptFont,NSFontAttributeName,[NSNumber numberWithInteger:1],NSSuperscriptAttributeName, nil];
        double dh = [self majorLongitudeGridLineSpacing]/15.;
        if(dh>=1){
            int h = (int)(lon/15.+0.5);
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
            [string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",h] attributes:coordAttr]];
            [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"h" attributes:superscriptAttr]];
            return string;
        } else if(dh>=0.016){
            int h = (int)(lon/15.);
            int m = (int)(((lon/15.-(double)h)*60)+0.5);
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
            if(m==0 || complete || [self alwaysDrawFullCoordinateString]){
                [string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",h] attributes:coordAttr]];
                [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"h" attributes:superscriptAttr]];
            }
            NSString *mstr = nil;
            if(m<10){
                mstr = [NSString stringWithFormat:@"0%d",m];
            }else{
                mstr = [NSString stringWithFormat:@"%d",m];
            }
            [string appendAttributedString:[[NSAttributedString alloc] initWithString:mstr attributes:coordAttr]];
            [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"m" attributes:superscriptAttr]];
            return string;
        } else if(dh>=0.00026){
            int h = (int)(lon/15.);
            int m = (int)((lon/15.-(double)h)*60);
            int s = (int)((lon/15.-(double)h-(double)m/60.)*3600+0.5);
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
            if(s==0 || complete || [self alwaysDrawFullCoordinateString]){
                [string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",h] attributes:coordAttr]];
                [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"h" attributes:superscriptAttr]];
                NSString *mstr = nil;
                if(m<10){
                    mstr = [NSString stringWithFormat:@"0%d",m];
                }else{
                    mstr = [NSString stringWithFormat:@"%d",m];
                }
                [string appendAttributedString:[[NSAttributedString alloc] initWithString:mstr attributes:coordAttr]];
                [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"m" attributes:superscriptAttr]];
            }
            NSString *sstr = nil;
            if(s<10){
                sstr = [NSString stringWithFormat:@"0%d",s];
            }else{
                sstr = [NSString stringWithFormat:@"%d",s];
            }
            [string appendAttributedString:[[NSAttributedString alloc] initWithString:sstr attributes:coordAttr]];
            [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"s" attributes:superscriptAttr]];
            return string;
        }
    }else{
        NSDictionary *coordAttr = [NSDictionary dictionaryWithObjectsAndKeys:[self coordinateFont],NSFontAttributeName, nil];
        double dg = [self majorLatitudeGridLineSpacing];
        if(dg>=1){
            int deg = (int)(lon+0.5);
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
            [string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d°",deg] attributes:coordAttr]];
            return string;
        }else if(dg>=0.016){
            int deg = (int)(lon);
            int min = (int)((lon-(double)deg)*60+0.5);
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
            NSString* mstr = nil;
            if(min<10){
                mstr = [NSString stringWithFormat:@"0%d",min];
            }else{
                mstr = [NSString stringWithFormat:@"%d",min];
            }
            if(min==0 || complete || [self alwaysDrawFullCoordinateString]){
                [string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d°",deg] attributes:coordAttr]];
            }
            [string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@'",mstr] attributes:coordAttr]];
            return string;
        }else if(dg>=0.00027){
            int deg = (int)(lon);
            int min = (int)((lon-(double)deg)*60);
            int sec = (int)((lon-(double)deg-(double)min/60.)*3600+0.5);
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
            NSString* mstr = nil;
            if(min<10){
                mstr = [NSString stringWithFormat:@"0%d",min];
            }else{
                mstr = [NSString stringWithFormat:@"%d",min];
            }
            NSString* sstr = nil;
            if(sec<10){
                sstr = [NSString stringWithFormat:@"0%d",sec];
            }else{
                sstr = [NSString stringWithFormat:@"%d",sec];
            }
            if(sec==0 || complete || [self alwaysDrawFullCoordinateString]){
                [string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d°%@'",deg,mstr] attributes:coordAttr]];
            }
            [string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\"",sstr] attributes:coordAttr]];
            return string;
        }
    }
    return nil;
}

- (NSAttributedString*) attributedStringForLatitude:(double)lat forCoordinateSystemType:(AMCoordinateSystemType)type forceShowCompleteString:(BOOL)complete {
    NSDictionary *coordAttr = [NSDictionary dictionaryWithObjectsAndKeys:[self coordinateFont],NSFontAttributeName, nil];
    double dg = [self majorLatitudeGridLineSpacing];
    NSString *sign = @"+";
    if(lat<0) sign = @"-";
    lat = fabs(lat);
    if(dg>=1){
        int deg = (int)(lat+0.5);
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%d°",sign,deg] attributes:coordAttr]];
        return string;
    }else if(dg>=0.016){
        int deg = (int)(lat);
        int min = (int)((lat-(double)deg)*60+0.5);
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
        NSString* mstr = nil;
        if(min<10){
            mstr = [NSString stringWithFormat:@"0%d",min];
        }else{
            mstr = [NSString stringWithFormat:@"%d",min];
        }
        if(min==0 || complete || [self alwaysDrawFullCoordinateString]){
            [string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%d°",sign,deg] attributes:coordAttr]];
        }
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@'",mstr] attributes:coordAttr]];
        return string;
    }else if(dg>=0.00027){
        int deg = (int)(lat);
        int min = (int)((lat-(double)deg)*60);
        int sec = (int)((lat-(double)deg-(double)min/60.)*3600+0.5);
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
        NSString* mstr = nil;
        if(min<10){
            mstr = [NSString stringWithFormat:@"0%d",min];
        }else{
            mstr = [NSString stringWithFormat:@"%d",min];
        }
        NSString* sstr = nil;
        if(sec<10){
            sstr = [NSString stringWithFormat:@"0%d",sec];
        }else{
            sstr = [NSString stringWithFormat:@"%d",sec];
        }
        if(sec==0 || complete || [self alwaysDrawFullCoordinateString]){
            [string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%d°%@'",sign,deg,mstr] attributes:coordAttr]];
        }
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\"",sstr] attributes:coordAttr]];
        return string;
    }
    return nil;
}



- (AMSphericalCoordinates*) coordinatesForLongitude:(double)lon latitude:(double)lat inCoordinateSystems:(AMCoordinateSystem*)cs {
    AMSphericalCoordinates *coord = [[AMSphericalCoordinates alloc] initWithCoordinateLongitude:[[AMScalarMeasure alloc] initWithQuantity:[AMQuantity quantityWithName:@"Right ascension"] numericalValue:lon andUnit:[AMUnit unitWithName:@"degree"]] latitude:[[AMScalarMeasure alloc] initWithQuantity:[AMQuantity quantityWithName:@"Declination"] numericalValue:lat andUnit:[AMUnit unitWithName:@"degree"]] inCoordinateSystem:cs];
    return coord;
}

@end
