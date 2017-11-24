#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AIRGoogleMapWeightedPoint : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) double weight;

@end
