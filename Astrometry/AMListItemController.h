//
//  AMListItemController.h
//  Astrometry
//
//  Created by Don Willems on 26/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AMListItemController : NSObject {
    IBOutlet NSTableCellView *tableCellView;
    IBOutlet NSTextField *titleTF;
    NSView *infoPanelView;
}

- (void) setTitle:(NSString*)title;

- (NSTableCellView*) listItemTableCellView;

- (NSString*) listItemInfoPanelNibName;
- (NSString*) listItemTableCellViewNibName;

- (void) didLoadTableCellViewNib;
- (void) didLoadInfoPanelNib;

- (void) loadListTableCellView;
- (void) loadListItemInfoPanel;

@end
