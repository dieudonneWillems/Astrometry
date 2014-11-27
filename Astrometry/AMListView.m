//
//  AMListView.m
//  Astrometry
//
//  Created by Don Willems on 26/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMListView.h"

@implementation AMListView

- (NSRect)frameOfOutlineCellAtRow:(NSInteger)row {
    NSRect sfr = [super frameOfOutlineCellAtRow:row];
    sfr.size.height = 12;
    return sfr;
}

- (NSRect)frameOfCellAtColumn:(NSInteger)column row:(NSInteger)row {
    NSRect superFrame = [super frameOfCellAtColumn:column row:row];
    NSUInteger level = [self levelForRow:row];
    if(level>0){
        NSRect nrect= superFrame;
        nrect.origin.x += level*[self indentationPerLevel];
        nrect.size.width -=level*[self indentationPerLevel];
        return nrect;
    }
    /*
    if (column == 0) {
        return NSMakeRect(0, superFrame.origin.y, [self bounds].size.width, superFrame.size.height);
    }
     */
    return superFrame;
}
@end
