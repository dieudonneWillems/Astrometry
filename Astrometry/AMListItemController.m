//
//  AMListItemController.m
//  Astrometry
//
//  Created by Don Willems on 26/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMListItemController.h"

@implementation AMListItemController

- (void) setTitle:(NSString*)title {
    NSLog(@"Setting title '%@' on %@ with view %@",title,titleTF,tableCellView);
    [titleTF setStringValue:[title uppercaseString]];
}

- (NSTableCellView*) listItemTableCellView {
    if(!tableCellView) [self loadListTableCellView];
    return tableCellView;
}

- (NSString*) listItemInfoPanelNibName {
    return nil;
}

- (NSString*) listItemTableCellViewNibName {
    return @"AMDefaultListItemViewController";
}

- (void) didLoadTableCellViewNib {
    
}

- (void) didLoadInfoPanelNib {
    
}

- (void) loadListTableCellView {
    NSArray *topviews = nil;
    [[NSBundle mainBundle] loadNibNamed:[self listItemTableCellViewNibName] owner:self topLevelObjects:&topviews];
    [self didLoadTableCellViewNib];
}

- (void) loadListItemInfoPanel {
    NSArray *topviews = nil;
    [[NSBundle mainBundle] loadNibNamed:[self listItemInfoPanelNibName] owner:self topLevelObjects:&topviews];
    [self didLoadInfoPanelNib];
}

@end
