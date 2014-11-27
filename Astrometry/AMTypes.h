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

typedef enum {
    AMEquatortialCoordinateSystem,
    AMGalacticCoordinateSystem,
    AMElipticCoordinateSystem,
    AMHorizontalCoordinateSytem,
    AMLocalCoordinateSystem
} AMCoordinateSystemType;


FOUNDATION_EXPORT NSString *const AMIdentifierPropertyKey;

#endif
