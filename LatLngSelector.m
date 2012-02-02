//
//  LatLngSelector.m
//  TableSearch
//
//  Created by Ahad Rana on 1/31/12.
//  Copyright (c) 2012 Factual Inc. All rights reserved.
//

#import "LatLngSelector.h"

@implementation LatLngSelector

- (id)initWithNibNameAndPropertyList:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil propertyList:
  (NSMutableDictionary *)propertyList { 

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      _propertyList = propertyList;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void) updateOverlay { 
  if (_activeOverlay != nil) { 
    [_mapView removeOverlay:_activeOverlay];
    [_activeOverlay release];
  }
  
  // get radius 
  double radius = [((NSNumber*)[_propertyList objectForKey:PREFS_RADIUS]) doubleValue];
  
  //add circle with appropriate radius 
  _activeOverlay = [[MKCircle circleWithCenterCoordinate:_activeQueryRegion.center radius:radius] retain];
  [_mapView addOverlay:_activeOverlay];
}

-(void) updateQueryLocation:(CLLocationCoordinate2D) centerPoint radius:(double) radius { 
  // make a region  ... 
  _activeQueryRegion = MKCoordinateRegionMakeWithDistance(centerPoint,radius*2,radius*2);

  MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:_activeQueryRegion];
  // update map view 
  [_mapView setRegion:adjustedRegion animated:YES];
  
  // update overlay 
  [self updateOverlay];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
  if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
    return;

  // convert to lat/lng
  CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];    
  CLLocationCoordinate2D touchMapCoordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
  // get desired query radius
  double radius = [((NSNumber*)[_propertyList objectForKey:PREFS_RADIUS]) doubleValue];
  
  // update query location ... 
  [self updateQueryLocation:touchMapCoordinate radius:radius];
}



-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay 
{
  MKCircleView* circleView = [[[MKCircleView alloc] initWithOverlay:overlay] autorelease];
  circleView.fillColor = [[UIColor alloc]initWithRed:0.0 green:0.0 blue:255.0 alpha:.20];
  return circleView;
}


- (void)viewDidLoad
{
  [super viewDidLoad];

  // add gesture recognizer 
  UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
  lpgr.minimumPressDuration = 1.0;  //user must hold for 1 second
  [_mapView addGestureRecognizer:lpgr];
  [lpgr release];
    

  // make a location 
  CLLocationCoordinate2D location = CLLocationCoordinate2DMake(
                                                               [((NSNumber*)[_propertyList objectForKey:PREFS_LATITUDE]) doubleValue],
                                                               [((NSNumber*)[_propertyList objectForKey:PREFS_LONGITUDE]) doubleValue]);                       
  // get radius 
  double radius = [((NSNumber*)[_propertyList objectForKey:PREFS_RADIUS]) doubleValue];
  
  // update location annotation 
  [self updateQueryLocation:location radius:radius];
 
}


- (void)viewDidUnload
{
  
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
  
  // update location ... 
  [_propertyList setValue:[NSNumber numberWithDouble:_activeQueryRegion.center.latitude] forKey:PREFS_LATITUDE];
  [_propertyList setValue:[NSNumber numberWithDouble:_activeQueryRegion.center.longitude] forKey:PREFS_LONGITUDE];
  
  
  [_activeOverlay release];
  [_mapView release];
  
  [super dealloc];
}
@end
