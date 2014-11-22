//
//  AMTypes.h
//  Astrometry
//
//  Created by Don Willems on 20/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#ifndef Astrometry_AMTypes_h
#define Astrometry_AMTypes_h

struct __unit__;

typedef enum __unittypes__{
    AMSingularUnit,
    AMUnitMultipleOrSubMultiple,
    AMUnitMultiplication,
    AMUnitDivision,
    AMUnitExponentiation,
    AMIntervalScale,
    AMRatioScale,
    AMOrdinalScale
} AMUnitType;

typedef struct {
    AMUnitType type;
    double factor; // factor or exponent in unit exponentiation
    double offset;
    struct __unit__ *unit1; // definition unit or term1 in multiplication, or numerator in division,
                            // or base unit in exponentiation.
    struct __unit__ *unit2; // term2 unit in multiplication or denominator in division.
} AMUnitDefinition;

typedef struct __unit__{
    char *name;
    char *symbol;
    AMUnitDefinition definition;
} AMUnit;

typedef struct {
    char *name;
    char *symbol;
} AMQuantity;

typedef struct {
    AMQuantity *quantity;
    double numericalValue;
    double positiveError;
    double negativeError;
    AMUnit *unit;
} AMMeasure;

typedef enum {
    AMEquatortialCoordinateSystem,
    AMGalacticCoordinateSystem,
    AMElipticCoordinateSystem,
    AMHorizontalCoordinateSytem
} AMCoordinateSystem;

typedef struct {
    AMCoordinateSystem coordinateSystem;
    AMMeasure *longitude;
    AMMeasure *latitude;
    AMMeasure *distance;
} AMSphericalCoordinates;

typedef struct {
    char *key;
} AMPropertyKey;

typedef struct {
    AMPropertyKey *key;
    char *value;
} AMStringProperty;

typedef struct {
    AMSphericalCoordinates *position;
    AMMeasure **measures;
    AMStringProperty **properties;
    int nmeasures;
    int nproperties;
} AMCelestialObject;

typedef struct {
    AMCoordinateSystem coordinateSystem;
    double minLongitude;
    double maxLongitude;
    double minLatitude;
    double maxLatitude;
    AMCelestialObject *objects;
    AMUnit *unit;
} AMCelestialArea;

typedef struct {
    AMQuantity *quantity;
    double *numericalValues;
    AMCelestialObject *objects;
    AMUnit *unit;
} AMMeasureIndex;

#endif
