//
//  AMMeasure.h
//  Astrometry
//
//  Created by Don Willems on 23/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMQuantity;

@interface AMMeasure : NSObject

- (id) initWithQuantity:(AMQuantity*)quantity;

@property (readonly) AMQuantity* quantity;

@end
