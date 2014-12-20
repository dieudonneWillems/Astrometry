//
//  AMCatalogueSelectionDatasource.m
//  Astrometry
//
//  Created by Don Willems on 17/12/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMCatalogueSelectionDatasource.h"
#import "AMCatalogue.h"
#import "AMCatalogueViewController.h"
#import "AMCatalogueCellView.h"

@interface AMCatalogueSelectionDatasource (private)
- (void) scrollViewContentBoundsDidChange:(NSNotification*)notification;
@end
@implementation AMCatalogueSelectionDatasource

- (void) awakeFromNib {
}



- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    return [[AMCatalogue catalogues] count];
}

- (id) tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    return [[AMCatalogue catalogues] objectAtIndex:rowIndex];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if(!views){
        views = [NSMutableDictionary dictionary];
        viewcontrollers = [NSMutableDictionary dictionary];
    }
    NSString *catname = [[AMCatalogue catalogues] objectAtIndex:row];
    AMCatalogueCellView *view = [views objectForKey:catname];
    if(!view){
        AMCatalogue *catalogue = [AMCatalogue catalogueForName:catname];
        AMCatalogueViewController *vc = [[AMCatalogueViewController alloc] initWithCatalogue:catalogue];
        [[NSBundle mainBundle] loadNibNamed:@"AMCatalogueViewController" owner:vc topLevelObjects:nil];
        [viewcontrollers setObject:vc forKey:catname];
        view = (AMCatalogueCellView*) [vc view];
        [view setCatalogue:catalogue];
        [views setObject:view forKey:catname];
    }
    return view;
}


- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    AMCatalogueCellView *view = (AMCatalogueCellView*)[self tableView:tableView viewForTableColumn:nil row:row];
    CGFloat height = [view preferredSize].height;
    return height;
}

@end
