//
//  LatLngSelector.h
//  TableSearch
//
//  Created by Ahad Rana on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "QueryPreferences.h"

@interface LatLngSelector : UIViewController<MKMapViewDelegate> { 
    
  NSMutableDictionary* _propertyList;
  IBOutlet MKMapView* _mapView;
  MKCoordinateRegion  _activeQueryRegion;
  MKCircle* _activeOverlay;
}

-(id)initWithNibNameAndPropertyList:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil propertyList:(NSMutableDictionary *)propertyList;

@end
