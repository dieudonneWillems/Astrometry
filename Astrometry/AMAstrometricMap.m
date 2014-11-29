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
        [self setUseRectangularViewPort:YES];
        [self setCentre:[AMSphericalCoordinates equatorialCoordinatesWithRightAscension:230 declination:30]];
        [self setScale:1.];
        AMMapProjection *mapproj =[[AMEquirectangularMapProjection alloc] init];
        [self setMapProjection:mapproj];
        AMSphericalCoordinates *cntr =[AMSphericalCoordinates equatorialCoordinatesWithRightAscension:15 declination:27];
        AMSphericalCoordinates *test = [AMSphericalCoordinates equatorialCoordinatesWithRightAscension:15 declination:27];
        NSPoint point = [mapproj pointForSphericalCoordinates:test withCentreCoordinates:cntr];
        AMSphericalCoordinates *ntest = [mapproj sphericalCoordinatesForPoint:point withCentreCoordinates:cntr];
    }
    return self;
}

- (id) initWithCoordinates:(AMSphericalCoordinates*)coord andScale:(double)scale {
    self = [super init];
    if(self){
        [self setUseRectangularViewPort:YES];
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
    double clon = [[[self centre] longitude] value];
    double clat = [[[self centre] latitude] value];
    if([self useRectangularViewPort]){
        // spherical bounds should be outside viewport
        NSRect vrect = [self viewRect];
        NSPoint p1 = vrect.origin;
        NSPoint p2 = vrect.origin;
        p2.y = p2.y+vrect.size.height;
        AMSphericalCoordinates *sc1 = [self sphericalCoordinatesForLocation:p1 inViewRect:vrect];
        AMSphericalCoordinates *sc2 = [self sphericalCoordinatesForLocation:p2 inViewRect:vrect];
        maximumLongitude = [sc1 longitude];
        double minlon = clon-([maximumLongitude value]-clon);
        minimumLongitude = [[AMScalarMeasure alloc] initWithQuantity:[maximumLongitude quantity] numericalValue:minlon andUnit:[maximumLongitude unit]];
        minimumLatitude = [sc1 latitude];
        maximumLatitude = [sc2 latitude];
    }else{
        // spherical bounds should be inside viewport
    }
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
    centrePoint.x = viewRect.origin.x + (viewRect.size.width/2.);
    centrePoint.y = viewRect.origin.y + (viewRect.size.height/2.);
    CGFloat dx = -(location.x-centrePoint.x)/[self scale];
    CGFloat dy = (location.y-centrePoint.y)/[self scale];
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
    NSPoint centrePoint;
    centrePoint.x = viewRect.origin.x + (viewRect.size.width/2.);
    centrePoint.y = viewRect.origin.y + (viewRect.size.height/2.);
    NSPoint point = [[self projection] pointForSphericalCoordinates:sc withCentreCoordinates:[self centre]];
    point.x = centrePoint.x+point.x*[self scale];
    point.y = centrePoint.y+point.y*[self scale];
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
