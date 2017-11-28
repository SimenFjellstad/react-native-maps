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
- (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
  NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
  NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
  unsigned hexComponent;
  [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
  return hexComponent / 255.0;
}
- (UIColor *) colorWithHexString: (NSString *) hexString {
  NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
  CGFloat alpha, red, blue, green;
  switch ([colorString length]) {
    case 3: // #RGB
      alpha = 1.0f;
      red   = [self colorComponentFrom: colorString start: 0 length: 1];
      green = [self colorComponentFrom: colorString start: 1 length: 1];
      blue  = [self colorComponentFrom: colorString start: 2 length: 1];
      break;
    case 4: // #ARGB
      alpha = [self colorComponentFrom: colorString start: 0 length: 1];
      red   = [self colorComponentFrom: colorString start: 1 length: 1];
      green = [self colorComponentFrom: colorString start: 2 length: 1];
      blue  = [self colorComponentFrom: colorString start: 3 length: 1];
      break;
    case 6: // #RRGGBB
      alpha = 1.0f;
      red   = [self colorComponentFrom: colorString start: 0 length: 2];
      green = [self colorComponentFrom: colorString start: 2 length: 2];
      blue  = [self colorComponentFrom: colorString start: 4 length: 2];
      break;
    case 8: // #AARRGGBB
      alpha = [self colorComponentFrom: colorString start: 0 length: 2];
      red   = [self colorComponentFrom: colorString start: 2 length: 2];
      green = [self colorComponentFrom: colorString start: 4 length: 2];
      blue  = [self colorComponentFrom: colorString start: 6 length: 2];
      break;
    default:
      [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
      break;
  }
  return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

- (void)setGradient:(NSDictionary *)gradient {
  NSArray<NSString *> *rawColors = gradient[@"colors"];
  NSArray<NSNumber *> *rawValues = gradient[@"values"];
  NSMutableArray<UIColor *> *colors = [NSMutableArray arrayWithCapacity:[rawColors count]];
  NSMutableArray<NSNumber *> *values = [NSMutableArray arrayWithCapacity:[rawValues count]];
  for(int i = 0; i < [rawColors count]; i++){
    [colors addObject:[self colorWithHexString:rawColors[i]]];
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
