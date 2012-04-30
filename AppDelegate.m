//
//  AppDelegate.m
//  TableSearch
//
//  Created by Ahad Rana on 1/31/12.
//  Copyright (c) 2012 Factual Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate;

@synthesize window, navController;
@synthesize apiObject=_apiObject;
@synthesize currentLocation=_currentLocation;

- (void)dealloc
{
  [mainViewController release];
	[navController release];
  [window release];
  [super dealloc];
}

- (void) initializeLocationManager { 
  _locationManager = [[CLLocationManager alloc]init];
  _locationManager.delegate = self;
  _locationManager.desiredAccuracy =kCLLocationAccuracyBest;
  _locationManager.distanceFilter = 60.0f; // update every 200ft
  [_locationManager startUpdatingLocation];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
  #error Please specify your API Key and Secret to build the project.
  // initialize the factual api object ... 
  _apiObject = [[FactualAPI alloc] initWithAPIKey:@"" secret:@""];
	
	// Create and configure the main view controller.
	mainViewController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
  
  // initialize location manager ... 
	[self initializeLocationManager];

	// Add create and configure the navigation controller.
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
	self.navController = navigationController;

	[navigationController release];
	
	// Configure and display the window.
	[window addSubview:navController.view];
	[window makeKeyAndVisible];
}

+(FactualAPI*) getAPIObject {
  UIApplication* app = [UIApplication sharedApplication];
  return ((AppDelegate*)app.delegate).apiObject;
}

+(AppDelegate*) getDelegate {
  UIApplication* app = [UIApplication sharedApplication];
  return ((AppDelegate*)app.delegate);
}

-(void)applicationWillEnterForeground:(UIApplication *)application { 
  [_locationManager startUpdatingLocation];
}

-(void)applicationWillResignActive:(UIApplication *)application { 
  [_locationManager stopUpdatingLocation];
}

#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
  
  [_currentLocation release];
  _currentLocation = [newLocation copy];
}


#pragma mark -


@end
