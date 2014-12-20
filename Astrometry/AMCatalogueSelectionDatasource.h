//
//  AMCatalogueSelectionDatasource.h
//  Astrometry
//
//  Created by Don Willems on 17/12/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AMCatalogueSelectionDatasource : NSObject <NSTableViewDataSource,NSTableViewDelegate> {
    NSMutableDictionary *viewcontrollers;
    NSMutableDictionary *views;
}

@end
