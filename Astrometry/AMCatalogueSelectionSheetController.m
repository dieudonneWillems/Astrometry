//
//  AMCatalogueSelectionSheetController.m
//  Astrometry
//
//  Created by Don Willems on 14/12/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMCatalogueSelectionSheetController.h"
#import "AMCatalogue.h"
#import "AMCatalogueReader.h"
#import "AMColourIndexCalculator.h"
#import "AMQuantity.h"
#import "AMCatalogueSelectionDatasource.h"

@interface AMCatalogueSelectionSheetController (private)
- (void) scrollViewContentBoundsDidChange:(NSNotification*)notification;
@end

@implementation AMCatalogueSelectionSheetController

- (void) awakeFromNib {
    catReader = [[AMCatalogueReader alloc] init];
    [catReader addCalculator:[[AMColourIndexCalculator alloc] initWithColourIndex:[AMQuantity quantityWithName:@"Colour index B-R"] magnitudeQuantities:[AMQuantity quantityWithName:@"B magnitude"] and:[AMQuantity quantityWithName:@"R magnitude"]]];
    catalogues = [NSMutableArray array];
    [catalogues addObjectsFromArray:[catReader cataloguesFromFolder:@"~/Development/Astrometry/Astrometry/"]];
    NSLog(@"Catalogues: %@",catalogues);
 //   [catalogueList setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleNone];
    [catalogueList reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewContentBoundsDidChange:) name:nil object:catalogueList];
    catalogueSelectionDatasource = (AMCatalogueSelectionDatasource*)[catalogueList dataSource];
    mode = 1;
    [previousButton setEnabled:NO];
}

- (AMCatalogue*) selectedCatalogue {
    NSString *catname = [[catalogueList dataSource] tableView:catalogueList objectValueForTableColumn:nil row:[catalogueList selectedRow]];
    return [AMCatalogue catalogueForName:catname];
}

- (void)scrollViewContentBoundsDidChange:(NSNotification*)notification {
    NSRange visibleRows = [catalogueList rowsInRect:catalogueList.bounds];
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0];
    [catalogueList noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndexesInRange:visibleRows]];
    [NSAnimationContext endGrouping];
}

- (NSWindow*) sheetWindow {
    return sheetWindow;
}

- (NSModalResponse) returnCodeWhenClickedOnButton:(id)sender {
    if([sender isEqualTo:okButton]) return NSModalResponseOK;
    if([sender isEqualTo:cancelButton]) return NSModalResponseCancel;
    return NSModalResponseAbort;
}

- (IBAction) previousViewRequested:(id)sender {
    NSView *currentview = placeholderView;
    NSView *prevView = placeholderView;
    if(mode==2){
        prevView = catalogueSelectionView;
        currentview = catalogueRestrictionsView;
    }
    NSRect frame = [catalogueContentView frame];
    frame.origin = NSZeroPoint;
    mode--;
    if(mode<2){
        [okButton setTitle:@"Next"];
        
    }
    if(mode==1)[previousButton setEnabled:NO];
    [catalogueContentView replaceSubview:currentview with:prevView];
    [prevView setFrame:frame];
    //[prevView setBounds:bounds];
    [prevView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
}

- (IBAction) nextViewRequested:(id)sender {
    if(mode==2) {
        [self closeCatalogueSelectionSheet:sender];
        return;
    }
    NSView *currentview = placeholderView;
    NSView *nextView = placeholderView;
    if(mode==1){
        currentview = catalogueSelectionView;
        nextView = catalogueRestrictionsView;
    }
    NSRect frame = [catalogueContentView frame];
    frame.origin = NSZeroPoint;
    mode++;
    if(mode==2) [okButton setTitle:@"Finish"];
    [previousButton setEnabled:YES];
    [catalogueContentView replaceSubview:currentview with:nextView];
    [nextView setFrame:frame];
    //[nextView setBounds:bounds];
    [nextView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
}

- (IBAction) closeCatalogueSelectionSheet:(id)sender {
    NSModalResponse returncode;
    NSLog(@"Should close catalogue selection sheet.");
    returncode = [self returnCodeWhenClickedOnButton:sender];
    NSWindow *window = nil;
    if([sheetWindow isSheet]){
        NSArray *windows = [NSApp windows];
        for(NSWindow *win in windows){
            if(win!=sheetWindow){
                if([win attachedSheet]==sheetWindow){
                    window = win;
                    break;
                }
            }
        }
    }
    if(window) [window endSheet:sheetWindow returnCode:returncode];
}
@end
