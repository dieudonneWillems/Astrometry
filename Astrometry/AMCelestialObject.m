//
//  AMCelestialObject.m
//  Astrometry
//
//  Created by Don Willems on 23/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMCelestialObject.h"
#import "AMMeasure.h"
#import "AMSphericalCoordinates.h"
#import "AMQuantity.h"
#import "AMTypes.h"

@implementation AMCelestialObject

- (id) init {
    self = [super init];
    if(self){
        measures = [NSMutableDictionary dictionary];
        properties = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id) initWithPosition:(AMSphericalCoordinates*)position {
    self = [self init];
    if(self){
        [self setMeasure:position];
    }
    return self;
}

- (NSString*) identifier {
    return [self objectPropertyForKey:AMIdentifierPropertyKey];
}

- (AMSphericalCoordinates*) position {
    return (AMSphericalCoordinates*)[self measureForQuantity:[AMQuantity quantityWithName:@"Spherical position"]];
}

- (NSArray*) measures {
    return [measures allValues];
}

- (AMMeasure*) measureForQuantity:(AMQuantity*)quantity {
    return [measures objectForKey:[quantity name]];
}

- (void) setMeasure:(AMMeasure*)measure {
    [measures setObject:measure forKey:[[measure quantity] name]];
}

- (NSArray*) quantities {
    return [measures allKeys];
}

- (NSArray*) objectProperties {
    return [properties allValues];
}

- (id) objectPropertyForKey:(NSString*)key {
    return [properties objectForKey:key];
}

- (void) setObjectProperty:(id)property forKey:(NSString *)key {
    [properties setObject:property forKey:key];
}

- (NSArray*) propertyKeys {
    return [properties allKeys];
}

- (NSString*) description {
    NSMutableString *string = [NSMutableString string];
    [string appendString:@"CelestialObject ["];
    NSInteger i=0;
    for(NSString *prop in [properties allKeys]){
        [string appendFormat:@"%@ = %@",prop,[properties objectForKey:prop]];
        if(i<[properties count]-1) [string appendString:@", "];
        i++;
    }
    if([properties count]>0 && [measures count]>0) [string appendString:@", "];
    i=0;
    for(AMMeasure *measure in [measures allValues]){
        [string appendString:[measure description]];
        if(i<[measures count]-1) [string appendString:@", "];
        i++;
    }
    [string appendString:@"]"];
    return string;
}

@end
