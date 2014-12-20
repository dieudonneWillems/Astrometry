//
//  AMCatalogueViewController.m
//  Astrometry
//
//  Created by Don Willems on 18/12/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMCatalogueViewController.h"
#import "AMCatalogue.h"

@interface AMCatalogueViewController ()

@end

@implementation AMCatalogueViewController

- (id) initWithCatalogue:(AMCatalogue*)catalogue {
    self = [super init];
    if(self){
        [self setCatalogue:catalogue];
    }
    return self;
}

- (void) awakeFromNib {
    NSLog(@"Catalogue: %@",[[self catalogue] name]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Loaded Catalogue list item view");
}

@end
