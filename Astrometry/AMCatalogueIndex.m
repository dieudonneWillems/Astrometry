//
//  AMCatalogueIndex.m
//  Astrometry
//
//  Created by Don Willems on 24/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMCatalogueIndex.h"
#import "AMCelestialObject.h"
#import "AMCatalogueIndexEntry.h"

@interface AMCatalogueIndex (private)
- (NSUInteger) indexOfEntry:(AMCatalogueIndexEntry*)entry startIndex:(NSUInteger)start endIndex:(NSUInteger)end;
@end

@implementation AMCatalogueIndex

- (id) init {
    self = [super init];
    if(self){
        indexEntries = [NSMutableArray array];
    }
    return self;
}

- (void) addCelestialObject:(AMCelestialObject*)object {
    
}

- (AMCelestialObject*) celestialObjectAtIndex:(NSUInteger)index {
    AMCatalogueIndexEntry *entry = [indexEntries objectAtIndex:index];
    return [entry object];
}

- (NSArray*) celestialObjectsInRange:(NSRange)range {
    NSArray *array = [indexEntries subarrayWithRange:range];
    NSMutableArray *objects = [NSMutableArray array];
    for(AMCatalogueIndexEntry *entry in array){
        [objects addObject:[entry object]];
    }
    return objects;
}

- (void) insertCatalogueIndexEntry:(AMCatalogueIndexEntry*)entry {
    NSUInteger index = [self indexOfEntry:entry];
    [indexEntries insertObject:entry atIndex:index];
    //NSLog(@"Adding %@ at %ld",entry,index);
}

- (NSUInteger) indexOfEntry:(AMCatalogueIndexEntry*)entry {
    return [self indexOfEntry:entry startIndex:0 endIndex:[indexEntries count]];
}

- (NSUInteger) indexOfEntry:(AMCatalogueIndexEntry*)entry startIndex:(NSUInteger)start endIndex:(NSUInteger)end {
    if(end==start) return start;
    NSUInteger pos = (end-start)/2+start;
    AMCatalogueIndexEntry *pentry = [indexEntries objectAtIndex:pos];
    NSComparisonResult cres = [pentry compare:entry];
    if(cres==NSOrderedAscending) return [self indexOfEntry:entry startIndex:pos+1 endIndex:end];
    if(cres==NSOrderedDescending) return [self indexOfEntry:entry startIndex:start endIndex:pos];
    return pos;
}

@end
