//
//  AMAstrometricMap.m
//  Astrometry
//
//  Created by Don Willems on 25/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMAstrometricMap.h"
#import "AMSphericalCoordinates.h"
#import "AMMapProjection.h"
#import "AMEquirectangularMapProjection.h"

@implementation AMAstrometricMap

- (id) init {
    self = [super init];
    if(self){
        [self setCentre:[AMSphericalCoordinates equatorialCoordinatesWithRightAscension:0 declination:45]];
        [self setScale:1.];
        [self setProjection:[[AMEquirectangularMapProjection alloc] init]];
    }
    return self;
}

- (id) initWithCoordinates:(AMSphericalCoordinates*)coord andScale:(double)scale {
    self = [super init];
    if(self){
        [self setCentre:coord];
        [self setScale:scale];
    }
    return self;
}


#pragma mark Coordinate space conversions

- (NSArray*) measuresForLocation:(NSPoint)location inView:(AMPlotView*)view {
    NSRect viewRect = [self viewRect];
    NSPoint centrePoint;
    centrePoint.x = viewRect.origin.x + (viewRect.size.width/2.);
    centrePoint.y = viewRect.origin.y + (viewRect.size.height/2.);
    CGFloat dx = -(location.x-centrePoint.x)/[self scale];
    CGFloat dy = (location.y-centrePoint.y)/[self scale];
    NSPoint point = NSMakePoint(dx, dy);
    AMSphericalCoordinates *sc = [[self projection] sphericalCoordinatesForPoint:point withCentreCoordinates:[self centre]];
    NSArray *array = [NSArray arrayWithObjects:sc, nil];
    return array;
}

- (NSPoint) locationInView:(AMPlotView*)view forMeasures:(NSArray*)measures {
    NSRect viewRect = [self viewRect];
    NSPoint centrePoint;
    centrePoint.x = viewRect.origin.x + (viewRect.size.width/2.);
    centrePoint.y = viewRect.origin.y + (viewRect.size.height/2.);
    AMSphericalCoordinates *sc = nil;
    for(AMMeasure *measure in measures){
        if([measure isKindOfClass:[AMSphericalCoordinates class]]){
            sc = (AMSphericalCoordinates*)measure;
            break;
        }
    }
    NSPoint point = [[self projection] pointForSphericalCoordinates:sc withCentreCoordinates:[self centre]];
    point.x = centrePoint.x+point.x*[self scale];
    point.y = centrePoint.y+point.y*[self scale];
    return point;
}


#pragma mark Map as list item controller

- (void) didLoadTableCellViewNib {
    NSLog(@"loaded table cell view for map");
}

- (NSString*) listItemInfoPanelNibName {
    return nil;
}

- (NSString*) listItemTableCellViewNibName {
    return @"AMAstrometricMapTableCell";
}

@end
