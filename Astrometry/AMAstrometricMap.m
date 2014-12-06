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
#import "AMScalarMeasure.h"

@interface AMAstrometricMap (private)
- (void) recalculateSphericalBounds;
@end

@implementation AMAstrometricMap

- (id) init {
    self = [super init];
    if(self){
        [self setUseRectangularViewPort:NO];
        [self setCentre:[AMSphericalCoordinates equatorialCoordinatesWithRightAscension:3 declination:0]];
        [self setScale:100.];
        AMMapProjection *mapproj =[[AMEquirectangularMapProjection alloc] init];
        [self setMapProjection:mapproj];
        /* // test
        AMSphericalCoordinates *cntr =[AMSphericalCoordinates equatorialCoordinatesWithRightAscension:15 declination:27];
        AMSphericalCoordinates *test = [AMSphericalCoordinates equatorialCoordinatesWithRightAscension:15 declination:27];
        NSPoint point = [mapproj pointForSphericalCoordinates:test withCentreCoordinates:cntr];
        AMSphericalCoordinates *ntest = [mapproj sphericalCoordinatesForPoint:point withCentreCoordinates:cntr];
        AMSphericalCoordinates *test1 = [AMSphericalCoordinates equatorialCoordinatesWithRightAscension:12 declination:27];
        NSPoint point1 = [mapproj pointForSphericalCoordinates:test1 withCentreCoordinates:cntr];
        AMSphericalCoordinates *ntest1 = [mapproj sphericalCoordinatesForPoint:point1 withCentreCoordinates:cntr];
         */
    }
    return self;
}

- (id) initWithCoordinates:(AMSphericalCoordinates*)coord andScale:(double)scale {
    self = [super init];
    if(self){
        [self setUseRectangularViewPort:NO];
        [self setCentre:coord];
        [self setScale:scale];
        [self setMapProjection:[[AMEquirectangularMapProjection alloc] init]];
    }
    return self;
}


#pragma Setter methods

- (void) setUseRectangularViewPort:(BOOL)useRectangularViewPort {
    if(useRectangularViewPort!=_useRectangularViewPort){
        _useRectangularViewPort = useRectangularViewPort;
        [self recalculateSphericalBounds];
        [[NSNotificationCenter defaultCenter] postNotificationName:AMPlotPropertiesChangedNotification object:self];
    }
}

- (void) setCentre:(AMSphericalCoordinates *)centre {
    if(((_centre!=nil && centre==nil) || (_centre==nil && centre!=nil)) || !(_centre && centre && [_centre isEqual:centre])){
        _centre = centre;
        [self recalculateSphericalBounds];
        [[NSNotificationCenter defaultCenter] postNotificationName:AMPlotPropertiesChangedNotification object:self];
    }
}

- (void) setScale:(double)scale {
    if(_scale!=scale){
        _scale = scale;
        [self recalculateSphericalBounds];
        [[NSNotificationCenter defaultCenter] postNotificationName:AMPlotPropertiesChangedNotification object:self];
    }
}

- (void) setMapProjection:(AMMapProjection*)projection {
    if((!_projection && projection) || (_projection && !projection) || !(projection && [projection isEqual:_projection])){
        _projection = projection;
        [self recalculateSphericalBounds];
        [[NSNotificationCenter defaultCenter] postNotificationName:AMPlotPropertiesChangedNotification object:self];
    }
}

// Overridden
- (void) setViewRect:(NSRect)nrect {
    if(!NSEqualRects(nrect, [self viewRect])){
        [super setViewRect:nrect];
        [self recalculateSphericalBounds];
        [[NSNotificationCenter defaultCenter] postNotificationName:AMPlotPropertiesChangedNotification object:self];
    }
}

#pragma mark Spherical bounds

- (void) recalculateSphericalBounds {
    AMScalarMeasure *minlon=nil;
    AMScalarMeasure *maxlon=nil;
    AMScalarMeasure *minlat=nil;
    AMScalarMeasure *maxlat=nil;
    [[self projection] calculateMinimumLongitude:&minlon maximumLongitude:&maxlon minimumLatitude:&minlat maximumLatitude:&maxlat inMap:self];
    minimumLongitude = minlon;
    maximumLongitude = maxlon;
    minimumLatitude = minlat;
    maximumLatitude = maxlat;
}

- (AMScalarMeasure*) minimumLongitude {
    if(!minimumLongitude){
        [self recalculateSphericalBounds];
    }
    return minimumLongitude;
}

- (AMScalarMeasure*) maximumLongitude {
    if(!maximumLongitude){
        [self recalculateSphericalBounds];
    }
    return maximumLongitude;
}

- (AMScalarMeasure*) minimumLatitude {
    if(!minimumLatitude){
        [self recalculateSphericalBounds];
    }
    return minimumLatitude;
}

- (AMScalarMeasure*) maximumLatitude {
    if(!maximumLatitude){
        [self recalculateSphericalBounds];
    }
    return maximumLatitude;
}


#pragma mark Coordinate space conversions

- (AMSphericalCoordinates*) sphericalCoordinatesForLocation:(NSPoint)location inViewRect:(NSRect)viewRect {
    NSPoint centrePoint;
    double scale = [self scale];
    if([[self projection] fullGlobeProjection]) scale = viewRect.size.width/2;
    centrePoint.x = viewRect.origin.x + (viewRect.size.width/2.);
    centrePoint.y = viewRect.origin.y + (viewRect.size.height/2.);
    CGFloat dx = (location.x-centrePoint.x)/scale;
    CGFloat dy = (location.y-centrePoint.y)/scale;
    NSPoint point = NSMakePoint(dx, dy);
    AMSphericalCoordinates *sc = [[self projection] sphericalCoordinatesForPoint:point withCentreCoordinates:[self centre]];
    return sc;
}

- (AMSphericalCoordinates*) sphericalCoordinatesForLocation:(NSPoint)location inView:(AMPlotView*)view  {
    NSRect viewRect = [self viewRect];
    return [self sphericalCoordinatesForLocation:location inViewRect:viewRect];
}

- (NSArray*) measuresForLocation:(NSPoint)location inView:(AMPlotView*)view {
    AMSphericalCoordinates *sc = [self sphericalCoordinatesForLocation:location inView:view];
    NSArray *array = [NSArray arrayWithObjects:sc, nil];
    return array;
}

- (NSPoint) locationInView:(AMPlotView *)view forSphericalCoordinates:(AMSphericalCoordinates*) sc {
    NSRect viewRect = [self viewRect];
    double scale = [self scale];
    if([[self projection] fullGlobeProjection]) scale = viewRect.size.width/2;
    NSPoint centrePoint;
    centrePoint.x = viewRect.origin.x + (viewRect.size.width/2.);
    centrePoint.y = viewRect.origin.y + (viewRect.size.height/2.);
    NSPoint point = [[self projection] pointForSphericalCoordinates:sc withCentreCoordinates:[self centre]];
    point.x = centrePoint.x+point.x*scale;
    point.y = centrePoint.y+point.y*scale;
    return point;
}

- (NSPoint) locationInView:(AMPlotView*)view forMeasures:(NSArray*)measures {
    AMSphericalCoordinates *sc = nil;
    for(AMMeasure *measure in measures){
        if([measure isKindOfClass:[AMSphericalCoordinates class]]){
            sc = (AMSphericalCoordinates*)measure;
            break;
        }
    }
    return [self locationInView:view forSphericalCoordinates:sc];
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
