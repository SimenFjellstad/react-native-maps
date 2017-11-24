//
// Created by Leland Richardson on 12/27/15.
// Copyright (c) 2015 Facebook. All rights reserved.
//

#import "RCTConvert+Heatmap.h"

#import <React/RCTConvert+CoreLocation.h>
#import "AIRGoogleMapCoordinate.h"
#import "AIRGoogleMapWeightedPoint.h"

@implementation RCTConvert (Heatmap)

// NOTE(lmr):
// This is a bit of a hack, but I'm using this class to simply wrap
// around a `CLLocationCoordinate2D`, since I was unable to figure out
// how to handle an array of structs like CLLocationCoordinate2D. Would love
// to get rid of this if someone can show me how...
+ (AIRGoogleMapCoordinate *)AIRGoogleMapCoordinate:(id)json
{
    AIRGoogleMapCoordinate *coord = [AIRGoogleMapCoordinate new];
    coord.coordinate = [self CLLocationCoordinate2D:json];
    return coord;
}

RCT_ARRAY_CONVERTER(AIRGoogleMapCoordinate)

+ (AIRGoogleMapWeightedPoint *)AIRGoogleMapWeightedPoint:(id)json
{
    AIRGoogleMapWeightedPoint *point = [AIRGoogleMapWeightedPoint new];
    point.coordinate = [self CLLocationCoordinate2D:json];
    point.weight     = [self double:json[@"weight"]];
    return point;
}

RCT_ARRAY_CONVERTER(AIRGoogleMapWeightedPoint)

@end
