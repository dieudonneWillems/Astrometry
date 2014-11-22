//
//  AMPropertyKeyStack.h
//  Astrometry
//
//  Created by Don Willems on 22/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMTypes.h"

@interface AMPropertyKeyStack : NSObject {
    AMPropertyKey **properties;
    NSUInteger nProperties;
}

+ (AMPropertyKeyStack*) sharedPropertyKeyStack;

- (AMPropertyKey*) propertyWihtKeyName:(NSString*)keyName;
- (void) addPropertyKey:(AMPropertyKey*)key;
@end
