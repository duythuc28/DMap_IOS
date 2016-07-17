# HSClusterMapView
[![Version](https://img.shields.io/cocoapods/v/HSClusterMapView.svg?style=flat)](http://cocoadocs.org/docsets/HSClusterMapView)
[![License](https://img.shields.io/cocoapods/l/HSClusterMapView.svg?style=flat)](http://cocoadocs.org/docsets/HSClusterMapView)
[![Platform](https://img.shields.io/cocoapods/p/HSClusterMapView.svg?style=flat)](http://cocoadocs.org/docsets/HSClusterMapView)

## Description
HSClusterMapView is a subclass of GMSMapView (Google iOS SDK Map) which clusters groups of GMSMarkers and replaces them with a single GMSMarker, enabling the developer to generate a custom UIImage for each cluster marker on the fly. 

Also included is a GMSMapView subclass, HSMapView, which will keep track of the markers on the GMSMapView for the developer. This is unlike the stock GMSMapView, which forces the developer to keep the GMSMarker objects they want to show on the map in data structure external to GMSMapView.

HSClusterMapView and HSMapView aim to provide more cohesive and full featured interfaces to work with the Google Maps for iOS SDK.

## Example
![alt tag](https://www.github.com/hotschedules/HSClusterMapView/raw/master/example.gif)  

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Basic Usage
An instance of HSClusterMapView should be created with the initializer:
```obj-c
- (instancetype)initWithFrame:(CGRect)frame renderer:(id<HSClusterRenderer>)renderer;
```
where renderer is responsible for generating a UIImage for each cluster which is shown on the map. Then, call:
```obj-c
- (void)addMarker:(GMSMarker *)marker;
```
to add markers to the map and call:
```obj-c
- (void)cluster;
```
to perform the clustering.
    
**YOU DO NOT NEED TO SET GMSMarker's "map" property when using HSClusterMapView or HSMapView!**


## Further Usage
HSClusterMapView has customizable parameters such as:
```obj-c
@property CLLocationDistance clusterSize;
@property NSUInteger minimumMarkerCountPerCluster;
@property BOOL clusteringEnabled;
```


HSMapView is the parent class of HSClusterMapView and has helpful methods GMSMapView does not such as:
```obj-c
- (void)addMarker:(GMSMarker *)marker;
- (void)addMarkers:(NSArray *)markers;
- (void)removeMarker:(GMSMarker *)marker;
- (void)removeMarkers:(NSArray *)markers;
```
and additional properties:
```obj-c
@property MKCoordinateSpan visibleSpan;
@property CGFloat visibleRadiusInMiles;
@property NSArray *displayedMarkers;
```

## Documentation
HSClusterMapView, HSMapView and their associated classes are fully documented [here on CocoaDocs](http://cocoadocs.org/docsets/HSClusterMapView).

## Installation
HSClusterMapView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "HSClusterMapView"
```

## License
HSClusterMapView is available under the MIT license. See the LICENSE file for more info.
