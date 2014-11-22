//
//  AMPropertyKeyStack.m
//  Astrometry
//
//  Created by Don Willems on 22/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMPropertyKeyStack.h"
#import "AMFunctions.h"

static AMPropertyKeyStack *__sharedPropertyKeyStack;

@interface AMPropertyKeyStack (private)
- (NSUInteger) indexOfPropertyKeyWithKeyName:(const char*)keyName startIndex:(NSUInteger)start endIndex:(NSUInteger)end;
@end

@implementation AMPropertyKeyStack

+ (AMPropertyKeyStack*) sharedPropertyKeyStack {
    if(!__sharedPropertyKeyStack){
        __sharedPropertyKeyStack = [[AMPropertyKeyStack alloc] init];
    }
    return __sharedPropertyKeyStack;
}

- (id) init {
    self = [super init];
    if(self){
        nProperties = 0;
        properties = NULL;
    }
    return self;
}

- (AMPropertyKey*) propertyWihtKeyName:(NSString*)keyName {
    NSUInteger index = [self indexOfPropertyKeyWithKeyName:[keyName cStringUsingEncoding:NSUTF8StringEncoding] startIndex:0 endIndex:nProperties];
    if(index>= nProperties || strcmp(properties[index]->key,[keyName cStringUsingEncoding:NSUTF8StringEncoding])!=0){
        [self addPropertyKey:AMCreatePropertyKey(keyName)];
    }
    return properties[index];
}

- (void) addPropertyKey:(AMPropertyKey*)key {
    NSUInteger index = [self indexOfPropertyKeyWithKeyName:key->key startIndex:0 endIndex:nProperties];
    if(!properties || index==nProperties || strcmp(key->key,properties[index]->key)!=0) {
        nProperties = nProperties+1;
        if(nProperties==1) properties = (AMPropertyKey**)malloc(sizeof(AMPropertyKey*));
        else properties = (AMPropertyKey**)realloc(properties, sizeof(nProperties*sizeof(AMPropertyKey*)));
        NSUInteger tc;
        for(tc = nProperties-1;tc>index;tc--){
            properties[tc] = properties[tc-1];
        }
        properties[index] = key;
    }
}

- (NSUInteger) indexOfPropertyKeyWithKeyName:(const char*)keyName startIndex:(NSUInteger)start endIndex:(NSUInteger)end {
    if(start==end) return start;
    NSUInteger pos = start + (end - start)/2;
    if(pos>=nProperties) return nProperties;
    int cmp = strcmp(keyName, properties[pos]->key);
    if(cmp<0) return [self indexOfPropertyKeyWithKeyName:keyName startIndex:start endIndex:pos];
    if(cmp>0) return [self indexOfPropertyKeyWithKeyName:keyName startIndex:pos+1 endIndex:end];
    return pos;
}

@end
