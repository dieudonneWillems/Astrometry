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

@interface AMMapGridLayer (private)
- (AMSphericalCoordinates*) coordinatesForLongitude:(double)lon latitude:(double)lat inCoordinateSystems:(AMCoordinateSystem*)cs;
@end

@implementation AMMapGridLayer

- (id) init {
    self = [super init];
    if(self){
        [self setMajorGridLineColor:[NSColor grayColor]];
        [self setMinorGridLineColor:[NSColor lightGrayColor]];
    }
    return self;
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
    [[NSColor blackColor] set];
    AMCoordinateSystem *eqcs = [AMCoordinateSystem equatorialCoordinateSystemJ2000];
    double lon,lat;
    [[NSColor blackColor] set];
    double clon = [[[(AMAstrometricMap*)plot centre] longitude] value];
    double clat = [[[(AMAstrometricMap*)plot centre] latitude] value];
    double minlat = clat-10;
    double maxlat = clat+10;
    if(minlat<-90) minlat = -90;
    if(maxlat>90) maxlat = 90;
    [[self minorGridLineColor] set];
    for(lon=clon-10;lon<=clon+10;lon+=1){
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
    for(lon=clon-10;lon<=clon+10;lon+=5){
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
