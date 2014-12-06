//
//  Document.m
//  Astrometry
//
//  Created by Don Willems on 25/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMDocument.h"

#import "AMCatalogue.h"
#import "AMLayer.h"
#import "AMPlot.h"
#import "AMPlotView.h"
#import "AMAstrometricMap.h"
#import "AMMapGridLayer.h"
#import "AMListDatasource.h"
#import "AMListView.h"
#import "AMMollweideMapProjection.h"

@interface AMDocument ()

@end

@implementation AMDocument

- (instancetype)init {
    self = [super init];
    if (self) {
        catalogues = [NSMutableArray array];
        plots = [NSMutableArray array];
    }
    return self;
}

- (NSArray*) catalogues {
    return catalogues;
}

- (void) addCatalogueWithName:(NSString*)name {
    [self addCatalogue:[AMCatalogue catalogueForName:name]];
}

- (void) addCatalogue:(AMCatalogue*)catalogue {
    if(catalogue){
        [catalogues addObject:catalogue];
        [itemList reloadData];
    }
}

- (void) addPlot:(AMPlot*)plot {
    [plots addObject:plot];
    [plotview setPlot:plot];
    [itemList reloadData];
}

- (void) removePlot:(AMPlot*)plot {
    [plots removeObject:plot];
    [itemList reloadData];
}

- (NSArray*) plots {
    return plots;
}

- (AMPlot*) selectedPlot {
    return selectedPlot;
}

- (void) setSelectedPlot:(AMPlot *)plot {
    selectedPlot = plot;
    [plotview setPlot:selectedPlot];
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
    AMAstrometricMap *plot = [[AMAstrometricMap alloc] init];
    //[plot setMapProjection:[[AMMollweideMapProjection alloc] init]];
    [self addPlot:plot];
    [plot setScale:250];
    [plot setUseRectangularViewPort:YES];
    [plot addLayer:[[AMMapGridLayer alloc] init]];
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"AMDocument";
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    return YES;
}

@end
