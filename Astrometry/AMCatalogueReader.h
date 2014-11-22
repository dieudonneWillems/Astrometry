//
//  AMCatalogueReader.h
//  Astrometry
//
//  Created by Don Willems on 22/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMCatalogue;

@interface AMCatalogueReader : NSObject

+ (AMCatalogue*) readCatalogueFromXMLFile:(NSString*)catalogueFile error:(NSError**)error;
@end
