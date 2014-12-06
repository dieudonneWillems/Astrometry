//
//  AMCylindricalMapProjection.m
//  Astrometry
//
//  Created by Don Willems on 26/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMEquirectangularMapProjection.h"
#import "AMScalarMeasure.h"
#import "AMSphericalCoordinates.h"
#import "AMCoordinateSystem.h"
#import "AMQuantity.h"
#import "AMUnit.h"
#import "AMAstrometricMap.h"

@interface AMEquirectangularMapProjection (private)
- (AMSphericalCoordinates*) sphericalCoordinatesForLocation:(NSPoint)location inViewRect:(NSRect)viewRect withScale:(double)scale andCentre:(AMSphericalCoordinates*)centre;
- (double) findRealMinimumLongitudeAtLatitude:(double)lat
                         withMinimumLongitude:(double)minlon
                          andMaximumLongitude:(double)maxlon
                                        inMap:(AMAstrometricMap*)map;
- (double) findRealMinimumLatitudeAtLongitude:(double)lon
                          withMinimumLatitude:(double)minlat
                           andMaximumLatitude:(double)maxlat
                                        inMap:(AMAstrometricMap*)map;
- (double) findRealMaximumLatitudeAtLongitude:(double)lon
                          withMinimumLatitude:(double)minlat
                           andMaximumLatitude:(double)maxlat
                                        inMap:(AMAstrometricMap*)map;
@end

@implementation AMEquirectangularMapProjection

- (NSString*) name {
    return @"Equirectangular";
}


- (BOOL) fullGlobeProjection {
    return NO;
}

- (void) calculateMinimumLongitude:(AMScalarMeasure**)minimumLongitude
                  maximumLongitude:(AMScalarMeasure**)maximumLongitude
                   minimumLatitude:(AMScalarMeasure**)minimumLatitude
                   maximumLatitude:(AMScalarMeasure**)maximumLatitude
                             inMap:(AMAstrometricMap*)map {
    if(![map centre] || [map viewRect].size.height==0 || [map viewRect].size.width==0 || [map scale]<=0) return;
    double clon = [[[map centre] longitude] value];
    NSPoint p1 = [map viewRect].origin;
    NSPoint p2 = [map viewRect].origin;
    p2.y = p2.y+[map viewRect].size.height;
    NSPoint p3 = [map viewRect].origin;
    p3.y = p3.y+[map viewRect].size.height/2;
    NSPoint p4 = [map viewRect].origin;
    p4.x = p4.x+[map viewRect].size.width/2;
    NSPoint p5 = [map viewRect].origin;
    p5.y = p5.y+[map viewRect].size.height;
    p5.x = p5.x+[map viewRect].size.width/2;
    AMSphericalCoordinates *sc1 = [self sphericalCoordinatesForLocation:p1 inViewRect:[map viewRect] withScale:[map scale] andCentre:[map centre]];
    AMSphericalCoordinates *sc2 = [self sphericalCoordinatesForLocation:p2 inViewRect:[map viewRect] withScale:[map scale] andCentre:[map centre]];
    AMSphericalCoordinates *sc3 = [self sphericalCoordinatesForLocation:p3 inViewRect:[map viewRect] withScale:[map scale] andCentre:[map centre]];
    AMSphericalCoordinates *sc4 = [self sphericalCoordinatesForLocation:p4 inViewRect:[map viewRect] withScale:[map scale] andCentre:[map centre]];
    AMSphericalCoordinates *sc5 = [self sphericalCoordinatesForLocation:p5 inViewRect:[map viewRect] withScale:[map scale] andCentre:[map centre]];
    NSLog(@"scale: %f",[map scale]);
    NSLog(@"%@ --> %@",NSStringFromPoint(p1),sc1);
    NSLog(@"%@ --> %@",NSStringFromPoint(p2),sc2);
    NSLog(@"%@ --> %@",NSStringFromPoint(p3),sc3);
    NSLog(@"%@ --> %@",NSStringFromPoint(p4),sc4);
    NSLog(@"%@ --> %@",NSStringFromPoint(p5),sc5);
    if([map useRectangularViewPort]){
        // spherical bounds should be outside viewport
        double dltest = fabs([[sc4 longitude] value]-[[sc5 longitude] value]);
        if(dltest<0.001){
            *maximumLongitude = [sc1 longitude];
            if([[sc2 longitude] value]>[*maximumLongitude value]) *maximumLongitude = [sc2 longitude];
            if([[sc3 longitude] value]>[*maximumLongitude value]) *maximumLongitude = [sc3 longitude];
            double minlon = clon-([*maximumLongitude value]-clon);
            while(minlon>=360) minlon-=360;
            while(minlon<0) minlon+=360;
            *minimumLongitude = [[AMScalarMeasure alloc] initWithQuantity:[*maximumLongitude quantity] numericalValue:minlon andUnit:[*maximumLongitude unit]];
            *minimumLatitude = [sc1 latitude];
            if([[sc4 latitude] value]<[*minimumLatitude value]) *minimumLatitude = [sc4 latitude];
            *maximumLatitude = [sc2 latitude];
            if([[sc5 latitude] value]>[*maximumLatitude value]) *maximumLatitude = [sc5 latitude];
        }else{
            if([[sc5 latitude] value]>0){ //north pole
                *maximumLatitude = [[AMScalarMeasure alloc] initWithQuantity:[*maximumLatitude quantity] numericalValue:90 andUnit:[*maximumLatitude unit]];
                *minimumLatitude = [sc1 latitude];
            }else if([[sc4 latitude] value]<0){ //south pole
                *minimumLatitude = [[AMScalarMeasure alloc] initWithQuantity:[*minimumLatitude quantity] numericalValue:-90 andUnit:[*minimumLatitude unit]];
                *maximumLatitude = [sc2 latitude];
            }
            *maximumLongitude = [[AMScalarMeasure alloc] initWithQuantity:[*maximumLongitude quantity] numericalValue:360 andUnit:[*maximumLongitude unit]];
            *minimumLongitude = [[AMScalarMeasure alloc] initWithQuantity:[*minimumLongitude quantity] numericalValue:0 andUnit:[*minimumLongitude unit]];
        }
    }else{
        // spherical bounds should be inside viewport
        if(!sc4 || !sc5 || [[sc4 latitude] value]==[[sc5 latitude] value]){ // Includes (one of) the poles.
            double maxlat = 90;
            double minlat = [[sc3 latitude] value];
            if(fabs([[sc5 latitude] value])> fabs(minlat)) minlat = [[sc5 latitude]value];
            if([[sc5 latitude] value]<0){
                maxlat = minlat;
                minlat = -90;
            }
            *maximumLatitude = [[AMScalarMeasure alloc] initWithQuantity:[*maximumLatitude quantity] numericalValue:maxlat andUnit:[*maximumLatitude unit]];
            *minimumLatitude = [[AMScalarMeasure alloc] initWithQuantity:[*minimumLatitude quantity] numericalValue:minlat andUnit:[*minimumLatitude unit]];
            *maximumLongitude = [[AMScalarMeasure alloc] initWithQuantity:[*maximumLongitude quantity] numericalValue:360 andUnit:[*maximumLongitude unit]];
            *minimumLongitude = [[AMScalarMeasure alloc] initWithQuantity:[*minimumLongitude quantity] numericalValue:0 andUnit:[*minimumLongitude unit]];
        } else if([[sc3 latitude] value]>=0){
            double startminlon = clon-([[sc1 longitude] value]-clon);
            while(startminlon>=360) startminlon-=360;
            while(startminlon<0) startminlon+=360;
            double minlon = [self findRealMinimumLongitudeAtLatitude:[[sc4 latitude] value] withMinimumLongitude:startminlon andMaximumLongitude:startminlon inMap:map];
            double maxlon = clon+(clon-minlon);
            while(maxlon>=360) maxlon-=360;
            while(maxlon<0) maxlon+=360;
            *minimumLongitude = [[AMScalarMeasure alloc] initWithQuantity:[*maximumLongitude quantity] numericalValue:minlon andUnit:[*maximumLongitude unit]];
            *maximumLongitude = [[AMScalarMeasure alloc] initWithQuantity:[*maximumLongitude quantity] numericalValue:maxlon andUnit:[*maximumLongitude unit]];
            *minimumLatitude = [sc4 latitude];
            double maxlat = 0;
            if(fabs(fabs([[sc5 longitude] value]-[[sc4 longitude] value])-180)<1){
                maxlat = 90;
            }else{
                maxlat = [self findRealMaximumLatitudeAtLongitude:[*minimumLongitude value] withMinimumLatitude:[[sc5 latitude] value] andMaximumLatitude:[[sc5 latitude] value] inMap:map];
            }
            *maximumLatitude = [[AMScalarMeasure alloc] initWithQuantity:[*maximumLatitude quantity] numericalValue:maxlat andUnit:[*maximumLatitude unit]];
        }else if([[sc3 latitude] value]<0){
            double startminlon = clon-([[sc2 longitude] value]-clon);
            while(startminlon>=360) startminlon-=360;
            while(startminlon<0) startminlon+=360;
            double minlon = [self findRealMinimumLongitudeAtLatitude:[[sc5 latitude] value] withMinimumLongitude:startminlon andMaximumLongitude:clon-([[sc2 longitude] value]-clon) inMap:map];
            double maxlon = clon+(clon-minlon);
            while(maxlon>=360) maxlon-=360;
            while(maxlon<0) maxlon+=360;
            *minimumLongitude = [[AMScalarMeasure alloc] initWithQuantity:[*maximumLongitude quantity] numericalValue:minlon andUnit:[*maximumLongitude unit]];
            *maximumLongitude = [[AMScalarMeasure alloc] initWithQuantity:[*maximumLongitude quantity] numericalValue:maxlon andUnit:[*maximumLongitude unit]];
            *maximumLatitude = [sc5 latitude];
            double minlat = 0;
            if(fabs(fabs([[sc5 longitude] value]-[[sc4 longitude] value])-180)<1){
                minlat = -90;
            }else{
                minlat = [self findRealMinimumLatitudeAtLongitude:[*minimumLongitude value] withMinimumLatitude:[[sc1 latitude] value] andMaximumLatitude:[[sc1 latitude] value] inMap:map];
            }
            *minimumLatitude = [[AMScalarMeasure alloc] initWithQuantity:[*maximumLatitude quantity] numericalValue:minlat andUnit:[*maximumLatitude unit]];
        }/*else {
            AMSphericalCoordinates *s0 = [[AMSphericalCoordinates alloc] initWithCoordinateLongitude:[[map centre] longitude] latitude:[[AMScalarMeasure alloc] initWithQuantity:[[[map centre] latitude] quantity] numericalValue:0 andUnit:[[[map centre] latitude] unit]] inCoordinateSystem:[[map centre] coordinateSystem]];
            NSPoint c0g = [self pointForSphericalCoordinates:s0 withCentreCoordinates:[map centre]];
            c0g.x = [map viewRect].origin.x;
            c0g.y = [map viewRect].origin.y+[map viewRect].size.height/2+c0g.y*[map scale];
            AMSphericalCoordinates *s1 = [self sphericalCoordinatesForLocation:c0g inViewRect:[map viewRect] withScale:[map scale] andCentre:[map centre]];
            *maximumLongitude = [s1 longitude];
            double minlon =clon-([[s1 longitude] value] - clon);
            while(minlon>=360) minlon-=360;
            while(minlon<0) minlon+=360;
            *minimumLongitude = [[AMScalarMeasure alloc] initWithQuantity:[[[map centre] longitude] quantity] numericalValue:minlon andUnit:[[[map centre] longitude] unit]];
            double minlat = [self findRealMinimumLatitudeAtLongitude:[*minimumLongitude value] withMinimumLatitude:[[sc1 latitude] value] andMaximumLatitude:[[sc1 latitude] value] inMap:map];
            *minimumLatitude = [[AMScalarMeasure alloc] initWithQuantity:[*maximumLatitude quantity] numericalValue:minlat andUnit:[*maximumLatitude unit]];
            double maxlat = [self findRealMaximumLatitudeAtLongitude:[*minimumLongitude value] withMinimumLatitude:[[sc2 latitude] value] andMaximumLatitude:[[sc2 latitude] value] inMap:map];
            *maximumLatitude = [[AMScalarMeasure alloc] initWithQuantity:[*maximumLatitude quantity] numericalValue:maxlat andUnit:[*maximumLatitude unit]];
        }*/
    }
}

- (double) findRealMinimumLongitudeAtLatitude:(double)lat
                         withMinimumLongitude:(double)minlon
                          andMaximumLongitude:(double)maxlon
                                        inMap:(AMAstrometricMap*)map {
    CGFloat leftb =[map viewRect].origin.x+[map viewRect].size.width;
    AMSphericalCoordinates *coord2 = [[AMSphericalCoordinates alloc] initWithCoordinateLongitude:[[AMScalarMeasure alloc] initWithQuantity:[[[map centre] longitude] quantity] numericalValue:minlon andUnit:[[[map centre] longitude] unit]] latitude:[[AMScalarMeasure alloc] initWithQuantity:[[[map centre] latitude] quantity] numericalValue:lat andUnit:[[[map centre] latitude] unit]] inCoordinateSystem:[[map centre] coordinateSystem]];
    NSPoint p2 = [map locationInView:nil forSphericalCoordinates:coord2];
    if(p2.x<leftb) minlon = minlon-5/[map scale];
    
    if(minlon>maxlon) return minlon;
    double lon = maxlon-([[[map centre] longitude] value]-maxlon)*.1;
    if(minlon<maxlon) lon = (maxlon-minlon)/2.+minlon;
    AMSphericalCoordinates *coord = [[AMSphericalCoordinates alloc] initWithCoordinateLongitude:[[AMScalarMeasure alloc] initWithQuantity:[[[map centre] longitude] quantity] numericalValue:lon andUnit:[[[map centre] longitude] unit]] latitude:[[AMScalarMeasure alloc] initWithQuantity:[[[map centre] latitude] quantity] numericalValue:lat andUnit:[[[map centre] latitude] unit]] inCoordinateSystem:[[map centre] coordinateSystem]];
    NSPoint p = [map locationInView:nil forSphericalCoordinates:coord];
    if(fabs(p.x-leftb)<0.2) return lon;
    if(p.x>leftb){
        return [self findRealMinimumLongitudeAtLatitude:lat withMinimumLongitude:lon andMaximumLongitude:maxlon inMap:map];
    }
    if(p.x<leftb){
        return [self findRealMinimumLongitudeAtLatitude:lat withMinimumLongitude:minlon andMaximumLongitude:lon inMap:map];
    }
    return lon;
}
- (double) findRealMinimumLatitudeAtLongitude:(double)lon
                          withMinimumLatitude:(double)minlat
                           andMaximumLatitude:(double)maxlat
                                        inMap:(AMAstrometricMap*)map {
    CGFloat leftb =[map viewRect].origin.y;
    AMSphericalCoordinates *coord2 = [[AMSphericalCoordinates alloc] initWithCoordinateLongitude:[[AMScalarMeasure alloc] initWithQuantity:[[[map centre] longitude] quantity] numericalValue:lon andUnit:[[[map centre] longitude] unit]] latitude:[[AMScalarMeasure alloc] initWithQuantity:[[[map centre] latitude] quantity] numericalValue:minlat andUnit:[[[map centre] latitude] unit]] inCoordinateSystem:[[map centre] coordinateSystem]];
    NSPoint p2 = [map locationInView:nil forSphericalCoordinates:coord2];
    if(p2.y>leftb) minlat = minlat-5/[map scale];
    AMSphericalCoordinates *coord3 = [[AMSphericalCoordinates alloc] initWithCoordinateLongitude:[[AMScalarMeasure alloc] initWithQuantity:[[[map centre] longitude] quantity] numericalValue:lon andUnit:[[[map centre] longitude] unit]] latitude:[[AMScalarMeasure alloc] initWithQuantity:[[[map centre] latitude] quantity] numericalValue:maxlat andUnit:[[[map centre] latitude] unit]] inCoordinateSystem:[[map centre] coordinateSystem]];
    NSPoint p3 = [map locationInView:nil forSphericalCoordinates:coord3];
    if(p3.y<leftb) maxlat = maxlat+5/[map scale];
    
    if(minlat>maxlat) return minlat;
    double lat = maxlat-([[[map centre] latitude] value]-maxlat)*.1;
    if(minlat<maxlat) lat = (maxlat-minlat)/2.+minlat;
    AMSphericalCoordinates *coord = [[AMSphericalCoordinates alloc] initWithCoordinateLongitude:[[AMScalarMeasure alloc] initWithQuantity:[[[map centre] longitude] quantity] numericalValue:lon andUnit:[[[map centre] longitude] unit]] latitude:[[AMScalarMeasure alloc] initWithQuantity:[[[map centre] latitude] quantity] numericalValue:lat andUnit:[[[map centre] latitude] unit]] inCoordinateSystem:[[map centre] coordinateSystem]];
    NSPoint p = [map locationInView:nil forSphericalCoordinates:coord];
    if(fabs(p.y-leftb)<0.2) return lat;
    if(p.y<leftb){
        return [self findRealMinimumLatitudeAtLongitude:lon withMinimumLatitude:lat andMaximumLatitude:maxlat inMap:map];
    }
    if(p.y>leftb){
        return [self findRealMinimumLatitudeAtLongitude:lon withMinimumLatitude:minlat andMaximumLatitude:lat inMap:map];
    }
    return lat;
}

- (double) findRealMaximumLatitudeAtLongitude:(double)lon
                          withMinimumLatitude:(double)minlat
                           andMaximumLatitude:(double)maxlat
                                        inMap:(AMAstrometricMap*)map {
    CGFloat leftb =[map viewRect].origin.y+[map viewRect].size.height;
        AMSphericalCoordinates *coord2 = [[AMSphericalCoordinates alloc] initWithCoordinateLongitude:[[AMScalarMeasure alloc] initWithQuantity:[[[map centre] longitude] quantity] numericalValue:lon andUnit:[[[map centre] longitude] unit]] latitude:[[AMScalarMeasure alloc] initWithQuantity:[[[map centre] latitude] quantity] numericalValue:minlat andUnit:[[[map centre] latitude] unit]] inCoordinateSystem:[[map centre] coordinateSystem]];
        NSPoint p2 = [map locationInView:nil forSphericalCoordinates:coord2];
        if(p2.y>leftb) minlat = minlat-5/[map scale];
        AMSphericalCoordinates *coord3 = [[AMSphericalCoordinates alloc] initWithCoordinateLongitude:[[AMScalarMeasure alloc] initWithQuantity:[[[map centre] longitude] quantity] numericalValue:lon andUnit:[[[map centre] longitude] unit]] latitude:[[AMScalarMeasure alloc] initWithQuantity:[[[map centre] latitude] quantity] numericalValue:maxlat andUnit:[[[map centre] latitude] unit]] inCoordinateSystem:[[map centre] coordinateSystem]];
        NSPoint p3 = [map locationInView:nil forSphericalCoordinates:coord3];
        if(p3.y<leftb) maxlat = maxlat+5/[map scale];
    
    
    if(minlat>maxlat) return maxlat;
    double lat = minlat+([[[map centre] latitude] value]-maxlat)*.1;
    if(minlat<maxlat) lat = (maxlat-minlat)/2.+minlat;
    AMSphericalCoordinates *coord = [[AMSphericalCoordinates alloc] initWithCoordinateLongitude:[[AMScalarMeasure alloc] initWithQuantity:[[[map centre] longitude] quantity] numericalValue:lon andUnit:[[[map centre] longitude] unit]] latitude:[[AMScalarMeasure alloc] initWithQuantity:[[[map centre] latitude] quantity] numericalValue:lat andUnit:[[[map centre] latitude] unit]] inCoordinateSystem:[[map centre] coordinateSystem]];
    NSPoint p = [map locationInView:nil forSphericalCoordinates:coord];
    NSLog(@"p: %@ --> %@",NSStringFromPoint(p),coord);
    NSLog(@"leftb=%f",leftb);
    if(fabs(p.y-leftb)<0.2) return lat;
    if(p.y<leftb){
        return [self findRealMaximumLatitudeAtLongitude:lon withMinimumLatitude:lat andMaximumLatitude:maxlat inMap:map];
    }
    if(p.y>leftb){
        return [self findRealMaximumLatitudeAtLongitude:lon withMinimumLatitude:minlat andMaximumLatitude:lat inMap:map];
    }
    return lat;
}

- (AMSphericalCoordinates*) sphericalCoordinatesForLocation:(NSPoint)location inViewRect:(NSRect)viewRect withScale:(double)scale andCentre:(AMSphericalCoordinates*)centre {
    NSPoint centrePoint;
    centrePoint.x = viewRect.origin.x + (viewRect.size.width/2.);
    centrePoint.y = viewRect.origin.y + (viewRect.size.height/2.);
    CGFloat dx = (location.x-centrePoint.x)/scale;
    CGFloat dy = (location.y-centrePoint.y)/scale;
    NSPoint point = NSMakePoint(dx, dy);
    AMSphericalCoordinates *sc = [self sphericalCoordinatesForPoint:point withCentreCoordinates:centre];
    return sc;
}

- (NSPoint) pointForSphericalCoordinates:(AMSphericalCoordinates*)coordinates
                   withCentreCoordinates:(AMSphericalCoordinates*)centre {
    AMSphericalCoordinates *local = [self convert:coordinates
                          toLocalSystemWithCentre:centre];
    // todo unit conversion - expected degrees
    NSPoint point = NSMakePoint(-[[local longitude] value], [[local latitude] value]);
    return point;
}

- (AMSphericalCoordinates*) sphericalCoordinatesForPoint:(NSPoint)point
                                   withCentreCoordinates:(AMSphericalCoordinates*)centre {
    AMScalarMeasure *longitude = [[AMScalarMeasure alloc] initWithQuantity:[AMQuantity quantityWithName:@"Longitude"] numericalValue:-point.x andUnit:[AMUnit unitWithName:@"degree"]];
    AMScalarMeasure *latitude = [[AMScalarMeasure alloc] initWithQuantity:[AMQuantity quantityWithName:@"Latitude"] numericalValue:point.y andUnit:[AMUnit unitWithName:@"degree"]];
    AMSphericalCoordinates *ncoord = [[AMSphericalCoordinates alloc] initWithCoordinateLongitude:longitude latitude:latitude inCoordinateSystem:[[AMCoordinateSystem alloc] initWithType:AMLocalCoordinateSystem inEquinox:nil onEpoch:nil]];
    AMSphericalCoordinates *coord = [self convert:ncoord fromLocalSystemWithCentre:centre];
    return coord;
}

@end
