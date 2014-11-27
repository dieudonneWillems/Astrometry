//
//  AMLayerListDatasource.h
//  Astrometry
//
//  Created by Don Willems on 26/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AMDocument;

@interface AMListDatasource : NSObject <NSOutlineViewDataSource,NSOutlineViewDelegate> {
    IBOutlet AMDocument *document;
    NSMutableDictionary *itemCellViews;
}

@end
