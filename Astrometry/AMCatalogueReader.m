//
//  AMCatalogueReader.m
//  Astrometry
//
//  Created by Don Willems on 22/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMCatalogueReader.h"
#import "AMCatalogue.h"
#import "AMTypes.h"
#import "AMMeasure.h"
#import "AMScalarMeasure.h"
#import "AMQuantity.h"
#import "AMCelestialObject.h"
#import "AMUnit.h"
#import "AMSphericalCoordinates.h"
#import "AMCoordinateSystem.h"
#import "AMCalculator.h"

@interface AMCatalogueReader (private)
- (void) readObjectsFromFile:(NSString*)file usingXMLDefinition:(NSArray*)elements intoCatalogue:(AMCatalogue*)catalogue error:(NSError**)error;
- (AMCelestialObject*) readObjectFromLine:(NSString*)line usingXMLDefinition:(NSArray*)elements error:(NSError**)error;
- (NSString*) dataFromLine:(NSString*)line startingAt:(NSUInteger)start endingAt:(NSUInteger)end;
- (NSString*) stringValueOffield:(NSXMLElement*)fieldElement fromLine:(NSString*)line ;
- (AMScalarMeasure*) measureFromField:(NSXMLElement*)fieldElement fromLine:(NSString*)line;
- (NSString*) stringValueOfElement:(NSXMLElement*)element fromLine:(NSString*)line;
- (AMSphericalCoordinates*) sphericalCoordinatesFromField:(NSXMLElement*)fieldElement fromLine:(NSString*)line;
- (void) findAllQuantitiesAndPropertyKeysIn:(NSXMLElement*)baseElement insertInto:(AMCatalogue*)catalogue;
@end

@implementation AMCatalogueReader


- (id) init {
    self = [super init];
    if(self){
        calculators = [NSMutableArray array];
    }
    return self;
}


- (void) addCalculator:(AMCalculator*)calculator {
    [calculators addObject:calculator];
}

- (void) removeCalculator:(AMCalculator*)calculator {
    [calculators removeObject:calculator];
}


- (AMCatalogue*) readCatalogueFromXMLFile:(NSString*)catalogueFile error:(NSError**)error {
    AMCatalogue *catalogue = [[AMCatalogue alloc] init];
    catalogueFile = [catalogueFile stringByExpandingTildeInPath];
    NSString *xmlString = [NSString stringWithContentsOfFile:catalogueFile encoding:NSUTF8StringEncoding error:error];
    if(*error) return nil;
    NSXMLDocument* xmlDoc;
    NSUInteger options = NSXMLNodePreserveWhitespace|NSXMLDocumentTidyXML;
    xmlDoc = [[NSXMLDocument alloc] initWithXMLString:xmlString
                                              options:options
                                                error:error];
    if(*error) return nil;
    NSXMLElement *root = [xmlDoc rootElement];
    [self findAllQuantitiesAndPropertyKeysIn:root insertInto:catalogue];
    NSArray *children = [root children];
    for(NSXMLNode *child in children){
        if([[child name] isEqualToString:@"name"]) [catalogue setName:[child stringValue]];
        if([[child name] isEqualToString:@"description"]) [catalogue setCatalogueDescription:[child stringValue]];
        if([[child name] isEqualToString:@"file"]){
            NSString *cfile = [[(NSXMLElement*)child attributeForName:@"src"] stringValue];
            cfile = [cfile stringByExpandingTildeInPath];
            NSArray *linees = [child nodesForXPath:@"line" error:error];
            NSXMLElement *linee = nil;
            if([linees count]>0){
                linee = [linees objectAtIndex:0];
                [self readObjectsFromFile:cfile usingXMLDefinition:[linee children] intoCatalogue:catalogue error:error];
                if(*error) return nil;
            }
        }
    }
    [catalogue index];
    return catalogue;
}

- (void) readObjectsFromFile:(NSString*)file usingXMLDefinition:(NSArray*)elements intoCatalogue:(AMCatalogue*)catalogue error:(NSError**)error{
    NSString *catfile = [NSString stringWithContentsOfFile:file encoding:NSASCIIStringEncoding error:error];
    if(*error) return;
    NSArray *lines = [catfile componentsSeparatedByString:@"\n"];
    for(NSString *line in lines){
        NSString *tline = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSError *objectError = nil;
        if([tline length]>0){
            AMCelestialObject* celestialobject = [self readObjectFromLine:line usingXMLDefinition:elements error:&objectError];
            for(AMCalculator *calculator in calculators){
                AMMeasure *calcmeas = [calculator calculateMeasureForCelestialObject:celestialobject];
                [celestialobject setMeasure:calcmeas];
                [catalogue addQuantity:[calcmeas quantity]];
            }
            [catalogue addCelestialObject:celestialobject];
        }
        if(objectError){
            NSLog(@"Could not read object from line:\n%@\nerror:%@",line,objectError);
        }
    }
}

- (AMCelestialObject*) readObjectFromLine:(NSString*)line usingXMLDefinition:(NSArray*)elements error:(NSError**)error {
    AMCelestialObject *object = [[AMCelestialObject alloc] init];
    for(NSXMLElement *element in elements){
        if([[element name] isEqualToString:@"parameter"]){
            NSString *key = nil;
            NSString *value = nil;
            for(NSXMLNode *node in [element children]){
                if([[node name] isEqualToString:@"key"]){
                    key = [node stringValue];
                }
                if([[node name] isEqualToString:@"value"]){
                    value = [self stringValueOfElement:(NSXMLElement*)node fromLine:line];
                }
            }
            if(value){
                [object setObjectProperty:value forKey:key];
            }
        }else if([[element name] isEqualToString:@"measure"]){
            AMMeasure *measure = [self measureFromField:element fromLine:line];
            [object setMeasure:measure];
        }else if([[element name] isEqualToString:@"spherical-coordinates"]){
            AMSphericalCoordinates *scmeasure = [self sphericalCoordinatesFromField:element fromLine:line];
            [object setMeasure:scmeasure];
            [object setMeasure:[scmeasure longitude]];
            [object setMeasure:[scmeasure latitude]];
            if([scmeasure distance]) [object setMeasure:[scmeasure distance]];
        }
    }
    //NSLog(@"Read %@",object);
    return object;
}

- (AMSphericalCoordinates*) sphericalCoordinatesFromField:(NSXMLElement*)fieldElement fromLine:(NSString*)line {
    NSArray *children = [fieldElement children];
    AMScalarMeasure *longitude = nil;
    AMScalarMeasure *latitude = nil;
    AMScalarMeasure *distance = nil;
    AMCoordinateSystem *system = nil;
    AMCoordinateSystemType type;
    NSDate *equinox = nil;
    NSDate *epoch = nil;
    for(NSXMLNode *child in children){
        if([child isKindOfClass:[NSXMLElement class]]){
            NSXMLElement *element = (NSXMLElement*)child;
            if([[element name] isEqualToString:@"coordinate-system"]){
                NSString *stype = [[element attributeForName:@"type"] stringValue];
                if([stype isEqualToString:@"Equatorial"]){
                    type = AMEquatortialCoordinateSystem;
                }else if([stype isEqualToString:@"Galactic"]){
                    type = AMGalacticCoordinateSystem;
                }
                // Read Epoch and Equinox
            }else if([[element name] isEqualToString:@"longitude"]){
                longitude = [self measureFromField:element fromLine:line];
            }else if([[element name] isEqualToString:@"latitude"]){
                latitude = [self measureFromField:element fromLine:line];
            }else if([[element name] isEqualToString:@"distance"]){
                distance = [self measureFromField:element fromLine:line];
            }
        }
    }
    system = [[AMCoordinateSystem alloc] initWithType:AMEquatortialCoordinateSystem inEquinox:equinox onEpoch:epoch];
    AMSphericalCoordinates *scord = [[AMSphericalCoordinates alloc] initWithCoordinateLongitude:longitude latitude:latitude andDistance:distance inCoordinateSystem:system];
    return scord;
}

- (AMScalarMeasure*) measureFromField:(NSXMLElement*)fieldElement fromLine:(NSString*)line {
    AMQuantity *quantity = NULL;
    double value = 0;
    double positiveError = 0;
    double negativeError = 0;
    AMUnit *unit = NULL;
    NSArray *children = [fieldElement children];
    for(NSXMLNode *child in children){
        if([child isKindOfClass:[NSXMLElement class]]){
            if([[child name] isEqualToString:@"quantity"]){
                NSString *qname = [self stringValueOfElement:(NSXMLElement*)child fromLine:line];
                quantity = [AMQuantity quantityWithName:qname];
            }else if([[child name] isEqualToString:@"value"]){
                value = [[self stringValueOfElement:(NSXMLElement*)child fromLine:line] doubleValue];
            }else if([[child name] isEqualToString:@"error"]){
                double error = [[self stringValueOfElement:(NSXMLElement*)child fromLine:line] doubleValue];
                positiveError = error;
                negativeError = error;
            }else if([[child name] isEqualToString:@"positive-error"]){
                positiveError = [[self stringValueOfElement:(NSXMLElement*)child fromLine:line] doubleValue];
            }else if([[child name] isEqualToString:@"negative-error"]){
                negativeError = [[self stringValueOfElement:(NSXMLElement*)child fromLine:line] doubleValue];
            }else if([[child name] isEqualToString:@"unit"]){
                NSString *uname = [self stringValueOfElement:(NSXMLElement*)child fromLine:line];
                unit = [AMUnit unitWithName:uname];
            }
        }
    }
    AMScalarMeasure *measure = [[AMScalarMeasure alloc] initWithQuantity:quantity numericalValue:value positiveError:positiveError negativeError:negativeError andUnit:unit];
    return measure;
}

- (NSString*) stringValueOfElement:(NSXMLElement*)element fromLine:(NSString*)line {
    NSMutableString *value = nil;
    NSArray *children = [element children];
    for(NSXMLNode *cn in children){
        if([cn isKindOfClass:[NSXMLElement class]]){
            if([[cn name] isEqualToString:@"field"]){
                NSString *field = [self stringValueOffield:(NSXMLElement*)cn fromLine:line];
                if(field) {
                    if(!value) value = [NSMutableString string];
                    [value appendString:field];
                }
            }else{
                if(!value) value = [NSMutableString string];
                [value appendString:[cn stringValue]];
            }
        }else{
            if(!value) value = [NSMutableString string];
            [value appendString:[cn stringValue]];
        }
    }
    return value;
}

- (NSString*) stringValueOffield:(NSXMLElement*)fieldElement fromLine:(NSString*)line {
    NSUInteger start = [[[fieldElement attributeForName:@"start"] stringValue] integerValue];
    NSUInteger end = [[[fieldElement attributeForName:@"end"] stringValue] integerValue];
    NSString *string = [self dataFromLine:line startingAt:start endingAt:end];
    NSString *trim = [[fieldElement attributeForName:@"trim"] stringValue];
    if([trim isEqualToString:@"yes"] || [trim isEqualToString:@"true"]) string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return string;
}

- (NSString*) dataFromLine:(NSString*)line startingAt:(NSUInteger)start endingAt:(NSUInteger)end {
    if([line length]<end) return nil;
    return [line substringWithRange:NSMakeRange(start-1, end-start+1)];
}

- (void) findAllQuantitiesAndPropertyKeysIn:(NSXMLElement*)baseElement insertInto:(AMCatalogue*)catalogue {
    NSArray *children = [baseElement children];
    for(NSXMLNode *node in children){
        if([node isKindOfClass:[NSXMLElement class]]){
            NSXMLElement *element = (NSXMLElement*)node;
            if([[element name] isEqualToString:@"quantity"]){
                [catalogue addQuantity:[AMQuantity quantityWithName:[element stringValue]]];
            }else if([[element name] isEqualToString:@"parameter"]){
                NSArray *keyes = [element elementsForName:@"key"];
                for(NSXMLElement *keye in keyes){
                    [catalogue addPropertyKey:[keye stringValue]];
                }
            }else {
                [self findAllQuantitiesAndPropertyKeysIn:element insertInto:catalogue];
            }
        }
    }
}

@end
