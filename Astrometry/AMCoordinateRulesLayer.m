//
//  AMCoordinateRulesLayer.m
//  Astrometry
//
//  Created by Don Willems on 25/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMCoordinateRulesLayer.h"
#import "AMSphericalCoordinates.h"
#import "AMScalarMeasure.h"
#import "AMQuantity.h"
#import "AMUnit.h"
#import "AMCoordinateSystem.h"
#import "AMPlot.h"

@implementation AMCoordinateRulesLayer

- (NSString*) listItemInfoPanelNibName {
    return nil;
}

- (NSString*) listItemTableCellViewNibName {
    return @"AMCoordinateRulesLayerTableCell";
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
    NSLog(@"Drawing coordinates layer");
    AMCoordinateSystem *eqcs = [AMCoordinateSystem equatorialCoordinateSystemJ2000];
    double lon,lat;
    [[NSColor blackColor] set];
    for(lon=-10;lon<=10;lon+=2){
        for(lat=35;lat<=55;lat+=2){
            AMSphericalCoordinates *coord = [[AMSphericalCoordinates alloc] initWithCoordinateLongitude:[[AMScalarMeasure alloc] initWithQuantity:[AMQuantity quantityWithName:@"Right ascension"] numericalValue:lon andUnit:[AMUnit unitWithName:@"degree"]] latitude:[[AMScalarMeasure alloc] initWithQuantity:[AMQuantity quantityWithName:@"Declination"] numericalValue:lat andUnit:[AMUnit unitWithName:@"degree"]] inCoordinateSystem:eqcs];
            NSPoint point = [plot locationInView:view forMeasures:[NSArray arrayWithObject:coord]];
            NSLog(@"POINT for %@ = %@",coord,NSStringFromPoint(point));
            NSBezierPath *bp = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(point.x-1, point.y-1, 2, 2)];
            [bp fill];
        }
    }
}

@end