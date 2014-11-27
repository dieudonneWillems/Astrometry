//
//  AMLayerListDatasource.m
//  Astrometry
//
//  Created by Don Willems on 26/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMListDatasource.h"
#import "AMDocument.h"
#import "AMLayer.h"
#import "AMListItemController.h"
#import "AMPlot.h"

@interface AMListDatasource (private)
- (NSTableCellView *) createTableViewCellForListItem:(AMListItemController*)item;
@end

@implementation AMListDatasource

#pragma mark Datasource methods

- (id)outlineView:(NSOutlineView *)outlineView
            child:(NSInteger)index
           ofItem:(id)item {
    if(item==nil){
        NSInteger runningIndex = index;
        if(runningIndex==0) return @"Catalogues";
        runningIndex --;
        if(runningIndex<[[document catalogues] count]){
            return [[document catalogues] objectAtIndex:runningIndex];
        }
        runningIndex -= [[document catalogues] count];
        if(runningIndex==0) return @"Plots";
        runningIndex --;
        return [[document plots] objectAtIndex:runningIndex];
    }
    if([item isKindOfClass:[AMPlot class]]){
        return [[(AMPlot*)item layers] objectAtIndex:index];
    }
    return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView
   isItemExpandable:(id)item {
    if([item isKindOfClass:[AMPlot class]]){
        return ([[(AMPlot*)item layers] count]>0);
    }
    return NO;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView
  numberOfChildrenOfItem:(id)item {
    if(item==nil){
        return [[document catalogues] count]+[[document plots] count]+2;
    }
    if([item isKindOfClass:[AMPlot class]]){
        return [[(AMPlot*)item layers] count];
    }
    return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView
objectValueForTableColumn:(NSTableColumn *)tableColumn
           byItem:(id)item {
    return [item description];
}


#pragma mark Delegate methods 

- (NSView *)outlineView:(NSOutlineView *)outlineView
     viewForTableColumn:(NSTableColumn *)tableColumn
                   item:(id)item {
    NSTableCellView *tbc = nil;
    if ([self outlineView:outlineView isGroupItem:item]) {
        NSString *string = (NSString*)item;
        tbc = [itemCellViews objectForKey:string];
        if(!tbc){
            AMListItemController *contr = [[AMListItemController alloc] init];
            tbc = [contr listItemTableCellView];
            [contr setTitle:string];
            [itemCellViews setObject:tbc forKey:string];
        }
    } else if([item isKindOfClass:[AMListItemController class]]){
        tbc = [itemCellViews objectForKey:[item description]];
        if(!tbc){
            tbc = [item listItemTableCellView];
            [itemCellViews setObject:tbc forKey:[item description]];
        }
    }
    return tbc;
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView
     heightOfRowByItem:(id)item {
    NSTableCellView *tbc = nil;
    if([item isKindOfClass:[AMListItemController class]]){
        tbc = [itemCellViews objectForKey:[item description]];
        if(!tbc){
            tbc = [item listItemTableCellView];
            [itemCellViews setObject:tbc forKey:[item description]];
        }
    }
    if(tbc) return [tbc frame].size.height;
    return 24;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView
   shouldSelectItem:(id)item {
    return !([self outlineView:outlineView isGroupItem:item]);
}

- (BOOL)outlineView:(NSOutlineView *)outlineView
        isGroupItem:(id)item {
    if([item isKindOfClass:[NSString class]]){
        return YES;
    }
    return NO;
}

@end
