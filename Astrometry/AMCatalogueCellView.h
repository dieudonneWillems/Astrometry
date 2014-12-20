//
//  AMCatalogueCellView.h
//  Astrometry
//
//  Created by Don Willems on 18/12/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AMCatalogue;

@interface AMCatalogueCellView : NSTableCellView {
    AMCatalogue *catalogue;
    NSImage *icon;
}

- (void) setCatalogue:(AMCatalogue*)catalogue;
- (NSSize) preferredSize;
@end
