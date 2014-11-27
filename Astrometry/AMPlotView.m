//
//  AMPlotView.m
//  Astrometry
//
//  Created by Don Willems on 25/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMPlotView.h"
#import "AMPlot.h"
#import "AMLayer.h"

@implementation AMPlotView

- (id) initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if(self){
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
    NSRect frame = [self frame];
    frame.origin.x +=40;
    frame.origin.y +=80;
    frame.size.width -=80;
    frame.size.height -=120;
    [[self plot] setViewRect:frame];
    NSArray *layers = [[self plot] layers];
    for(AMLayer *layer in layers){
        [layer drawRect:dirtyRect onPlot:[self plot] inView:self];
    }
}

@end
