#import "AIRGoogleMapHeatmapManager.h"

#import <React/RCTBridge.h>
#import <React/RCTConvert.h>
#import "RCTConvert+MoreMapKit.h"
#import <React/RCTConvert+CoreLocation.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTViewManager.h>
#import <React/UIView+React.h>
#import "AIRGoogleMapHeatmap.h"
#import "Heatmap/GMUHeatmapTileLayer.h"
#import "Heatmap/GMUWeightedLatLng.h"
#import "Heatmap/GMUGradient.h"

@interface AIRGoogleMapHeatmapManager()

@end

@implementation AIRGoogleMapHeatmapManager

RCT_EXPORT_MODULE()
- (UIView *)view
{
    AIRGoogleMapHeatmap *heatmap = [AIRGoogleMapHeatmap new];
    return heatmap;
}

RCT_EXPORT_VIEW_PROPERTY(points, AIRGoogleMapWeightedPointArray)
RCT_EXPORT_VIEW_PROPERTY(radius, NSUInteger)
RCT_EXPORT_VIEW_PROPERTY(opacity, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(gradient, NSDictionary)


@end
