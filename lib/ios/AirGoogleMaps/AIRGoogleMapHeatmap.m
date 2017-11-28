#import "AIRGoogleMapHeatmap.h"

#import <GoogleMaps/GoogleMaps.h>
#import "Heatmap/GMUHeatmapTileLayer.h"
#import "Heatmap/GMUWeightedLatLng.h"
#import "Heatmap/GMUGradient.h"

@implementation AIRGoogleMapHeatmap

- (instancetype)init
{
  if (self = [super init]) {
    _heatmap = [[GMUHeatmapTileLayer alloc] init];
  }
  return self;
}

- (void)initiate{
    _heatmap.map = _map;
}

- (void)setRadius:(NSUInteger)radius {
   if (radius > 50){
    _radius = 50;
    _heatmap.radius = 50;
   }
   else if (radius < 10){
    _radius = 10;
    _heatmap.radius = 10;
  }
  else {
    _radius = radius;
    _heatmap.radius = radius;
  }
  [_heatmap clearTileCache];
}

- (void)setPoints:(NSArray<AIRGoogleMapWeightedPoint *> *)points {
 NSMutableArray<GMUWeightedLatLng *> *output = [NSMutableArray arrayWithCapacity:[points count]];
  
  for(int i = 0; i < [points count]; i++){
    GMUWeightedLatLng *point = [[GMUWeightedLatLng alloc] initWithCoordinate: points[i].coordinate intensity:points[i].weight];
    [output addObject:point];
  }
  _heatmap.weightedData = output;
  [_heatmap clearTileCache];
}


- (void)setOpacity:(NSNumber *) opacity {
  _opacity = opacity;
  _heatmap.opacity = [opacity floatValue];
  NSLog(@"%@", opacity);

  [_heatmap clearTileCache];
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
  unsigned rgbValue = 0;
  NSScanner *scanner = [NSScanner scannerWithString:hexString];
  [scanner setScanLocation:1]; // bypass '#' character
  [scanner scanHexInt:&rgbValue];
  int alpha = ((rgbValue & 0xFF000000) >> 24) / 255.0;
  int red = ((rgbValue & 0xFF0000) >> 16) / 255.0;
  int green = ((rgbValue & 0xFF00) >> 8) / 255.0;
  int blue = (rgbValue & 0xFF)/255.0;
  return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)setGradient:(NSDictionary *)gradient {
  NSArray<NSString *> *rawColors = gradient[@"colors"];
  NSArray<NSNumber *> *rawValues = gradient[@"values"];
  NSMutableArray<UIColor *> *colors = [NSMutableArray arrayWithCapacity:[rawColors count]];
  NSMutableArray<NSNumber *> *values = [NSMutableArray arrayWithCapacity:[rawValues count]];
  for(int i = 0; i < [rawColors count]; i++){
    [colors addObject:[self colorFromHexString:rawColors[i]]];
    [values addObject:rawValues[i]];
    NSLog(@"COLOR ENTRY:");
    NSLog(@"%@", rawColors[i]);
    NSLog(@"%@", rawValues[i]);
    NSLog(@"%@", colors[i]);
    NSLog(@"%@", values[i]);
  }
  GMUGradient *gmuGradient =[[GMUGradient alloc] initWithColors:colors
                                                   startPoints:values
                                                  colorMapSize:1000];
  _heatmap.gradient = gmuGradient;
  [_heatmap clearTileCache];
}

@end
