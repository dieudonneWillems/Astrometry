//
//  AMCatalogue.m
//  Astrometry
//
//  Created by Don Willems on 22/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMCatalogue.h"
#import "AMCelestialObject.h"
#import "AMQuantity.h"
#import "AMScalarQuantity.h"
#import "AMScalarQuantityIndex.h"
#import "AMSearchDescriptor.h"
#import "AMScalarQuantitySearchDescriptor.h"
#import "AMCompoundSearchDescriptor.h"

static NSMutableDictionary *__catalogues;

@interface AMCatalogue (private)

@end

@implementation AMCatalogue

+ (NSArray*) catalogues {
    if(!__catalogues) return [NSArray array];
    return [__catalogues allKeys];
}

+ (AMCatalogue*) catalogueForName:(NSString*)name {
    if(!__catalogues) return nil;
    return [__catalogues objectForKey:name];
}

- (id) init {
    self = [super init];
    if(self){
        if(!__catalogues){
            __catalogues = [NSMutableDictionary dictionary];
        }
        objects = [NSMutableArray array];
        quantities = [NSMutableArray array];
        properties = [NSMutableArray array];
        indexes = [NSMutableDictionary dictionary];
        fileDefinitions = [NSMutableArray array];
    }
    return self;
}

- (void) setName:(NSString *)name {
    _name = name;
    [__catalogues setObject:self forKey:name];
}

- (NSArray*) celestialObjects {
    return objects;
}

- (void) addCelestialObject:(AMCelestialObject*)object {
    [objects addObject:object];
}

- (NSArray*) properties {
    return properties;
}

- (void) addPropertyKey:(NSString*)key {
    if(![properties containsObject:key]) [properties addObject:key];
}

- (NSArray*) quantities {
    return quantities;
}

- (void) addQuantity:(AMQuantity*)quantity {
    if(![quantities containsObject:quantity]) [quantities addObject:quantity];
}

- (void) addCelestialObjectsFromCatalogue:(AMCatalogue*)cat {
    for(NSString* key in [cat properties]){
        if(![properties containsObject:key]) [properties addObject:key];
    }
    for(AMQuantity* quantity in [cat quantities]){
        if(![quantities containsObject:quantity]) [quantities addObject:quantity];
    }
    NSArray *cobjs = [cat celestialObjects];
    for(AMCelestialObject *cob in cobjs){
        if(![objects containsObject:cob]){
            [objects addObject:cob];
        }
    }
    [self index];
}

- (void) index {
    [indexes removeAllObjects];
    for(AMQuantity *quantity in quantities){
        if([quantity isKindOfClass:[AMScalarQuantity class]]){
            AMScalarQuantityIndex *index = [[AMScalarQuantityIndex alloc] initWithQuantity:quantity];
            [indexes setObject:index forKey:[quantity name]];
        }
    }
    // todo properties indexes
    
    for(AMCelestialObject *object in objects){
        for(AMCatalogueIndex *index in [indexes allValues]){
            [index addCelestialObject:object];
        }
    }
}

- (AMCatalogue*) subsetUsingSearchDescriptor:(AMSearchDescriptor*)searchDescriptor {
    if([searchDescriptor isKindOfClass:[AMScalarQuantitySearchDescriptor class]]){
        AMScalarQuantitySearchDescriptor *sqsd = (AMScalarQuantitySearchDescriptor*)searchDescriptor;
        AMScalarQuantityIndex *index = [indexes objectForKey:[[sqsd quantity] name]];
        NSRange range = [index rangeForObjectsIncludedInSearchDescriptor:sqsd];
        NSArray *robjects = [index celestialObjectsInRange:range];
        AMCatalogue *subset = [[AMCatalogue alloc] init];
        for(AMQuantity *quantity in quantities){
            [subset addQuantity:quantity];
        }
        for(NSString *key in properties){
            [subset addPropertyKey:key];
        }
        for(AMCelestialObject *object in robjects){
            [subset addCelestialObject:object];
        }
        [subset index];
        return subset;
    }else if([searchDescriptor isKindOfClass:[AMCompoundSearchDescriptor class]]){
        AMCompoundSearchDescriptor *csd = (AMCompoundSearchDescriptor*)searchDescriptor;
        if([csd searchOperator]==AMAndSearchOperator){
            AMSearchDescriptor *sdmin;
            NSUInteger min = [objects count];
            for(AMSearchDescriptor *sd in [csd searchDescriptors]){
                NSUInteger mcnt = [self maximumObjectCountUsingSearchDescriptor:sd];
                if(mcnt<min){
                    min = mcnt;
                    sdmin = sd;
                }
            }
            AMCatalogue *set = [self subsetUsingSearchDescriptor:sdmin];
            NSMutableArray *remainingSD = [NSMutableArray arrayWithArray:[csd searchDescriptors]];
            [remainingSD removeObject:sdmin];
            if([remainingSD count]>1){
                AMCompoundSearchDescriptor *ncsd = [[AMCompoundSearchDescriptor alloc] initWithOperator:[csd searchOperator]];
                [ncsd setSearchDescriptors:remainingSD];
                return [set subsetUsingSearchDescriptor:ncsd];
            } else if([remainingSD count]==1){
                return [set subsetUsingSearchDescriptor:[remainingSD objectAtIndex:0]];
            }
            return set;
        }else if([csd searchOperator]==AMOrSearchOperator){
            AMCatalogue *subset = [[AMCatalogue alloc] init];
            for(AMSearchDescriptor *sd in [csd searchDescriptors]){
                AMCatalogue *set = [self subsetUsingSearchDescriptor:sd];
                [subset addCelestialObjectsFromCatalogue:set];
            }
            return subset;
        }
    }
    return nil;
}

- (NSUInteger) maximumObjectCountUsingSearchDescriptor:(AMSearchDescriptor*)searchDescriptor {
    if([searchDescriptor isKindOfClass:[AMScalarQuantitySearchDescriptor class]]){
        AMScalarQuantitySearchDescriptor *sqsd = (AMScalarQuantitySearchDescriptor*)searchDescriptor;
        AMScalarQuantityIndex *index = [indexes objectForKey:[[sqsd quantity] name]];
        NSRange range = [index rangeForObjectsIncludedInSearchDescriptor:sqsd];
        return range.length;
    }else if([searchDescriptor isKindOfClass:[AMCompoundSearchDescriptor class]]){
        AMCompoundSearchDescriptor *csd = (AMCompoundSearchDescriptor*)searchDescriptor;
        if([csd searchOperator]==AMAndSearchOperator){
            NSUInteger max = [objects count];
            for(AMSearchDescriptor *sd in [csd searchDescriptors]){
                NSUInteger mcnt = [self maximumObjectCountUsingSearchDescriptor:sd];
                if(mcnt<max) max = mcnt;
            }
            return max;
        }else if([csd searchOperator]==AMOrSearchOperator){
            NSUInteger max = 0;
            for(AMSearchDescriptor *sd in [csd searchDescriptors]){
                NSUInteger mcnt = [self maximumObjectCountUsingSearchDescriptor:sd];
                max+=mcnt;
            }
            return max;
        }
    }
    return 0;
}

- (NSArray*) fileDefinitions {
    return fileDefinitions;
}

- (void) addFileDefinition:(NSXMLElement*)fileDefinitionElement {
    [fileDefinitions addObject:fileDefinitionElement];
}

- (NSString *) description {
    NSString * str = [NSString stringWithFormat:@"CATALOGUE: %@ %ld objects\n%@",[self name],[objects count],[self catalogueDescription]];
    return str;
}
@end
