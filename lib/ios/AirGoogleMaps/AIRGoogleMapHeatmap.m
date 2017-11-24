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
    [self generateHeatmapItems];
  }
  return self;
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
  _heatmap.opacity = 1.0;
  NSLog(@"%@", opacity);

  [_heatmap clearTileCache];
}

/*
 public void setGradient(ReadableMap gradient) {
 ReadableArray rawColors = gradient.getArray("colors");
 ReadableArray rawValues = gradient.getArray("values");
 int[] colors = new int[rawColors.size()];
 float[] values = new float[rawColors.size()];
 for (int i = 0; i < rawColors.size(); i++) {
 colors[i] = Color.parseColor(rawColors.getString(i));
 values[i] = ((float) rawValues.getDouble(i));
 }
 
 this.gradient = new Gradient(colors, values);
 if (heatmapTileProvider != null) {
 heatmapTileProvider.setGradient(this.gradient);
 refreshMap();
 }
 }
 */
- (UIColor *)colorFromHexString:(NSString *)hexString {
  unsigned rgbValue = 0;
  NSScanner *scanner = [NSScanner scannerWithString:hexString];
  [scanner setScanLocation:1]; // bypass '#' character
  [scanner scanHexInt:&rgbValue];
  return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
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



#pragma mark Private

- (void)generateHeatmapItems {
  const double extent = 0.2;
  NSMutableArray<GMUWeightedLatLng *> *items = [NSMutableArray arrayWithCapacity:150];
  for (int index = 0; index < 150; ++index) {
    double lat = 37.78825 + extent * [self randomScale];
    double lng = -122.4324 + extent * [self randomScale];
    GMUWeightedLatLng *item =
    [[GMUWeightedLatLng alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lng)
                                        intensity:1.0];
    items[index] = item;
  }
  _heatmap.weightedData = items;
}

// Returns a random value between -1.0 and 1.0.
- (double)randomScale {
  return (double)arc4random() / UINT32_MAX * 2.0 - 1.0;
}



@end
