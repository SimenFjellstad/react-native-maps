//
//  AIRMapHeatmap.h
//  AirMaps
//
//  Created by Jean-Richard Lai on 5/10/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <React/RCTComponent.h>
#import <React/RCTView.h>
#import "AIRGoogleMap.h"
#import "Heatmap/GMUHeatmapTileLayer.h"
#import "Heatmap/GMUWeightedLatLng.h"
#import "Heatmap/GMUGradient.h"

#import "RCTConvert+MoreMapKit.h"
#import "AIRGoogleMapWeightedPoint.h"

@interface AIRGoogleMapHeatmap: UIView

@property (nonatomic, weak) AIRGoogleMap *map;
@property (nonatomic, strong) GMUHeatmapTileLayer *heatmap;
@property (nonatomic, strong) NSArray<AIRGoogleMapWeightedPoint *> *points;
@property (nonatomic, assign) NSDictionary *gradient;
@property (nonatomic, assign) NSNumber *opacity;
@property (nonatomic, assign) NSUInteger radius;

@end

