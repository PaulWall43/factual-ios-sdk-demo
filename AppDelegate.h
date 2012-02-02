//
//  AppDelegate.h
//  TableSearch
//
//  Created by Ahad Rana on 1/31/12.
//  Copyright (c) 2012 Factual Inc. All rights reserved.
//

#import <FactualSDK/FactualAPI.h>
#import "MainViewController.h"

@interface AppDelegate : NSObject <UIApplicationDelegate,CLLocationManagerDelegate>
{
	UIWindow *window;
	UINavigationController	*navController;
  MainViewController* mainViewController;
  FactualAPI* _apiObject;
  CLLocationManager *_locationManager;
  CLLocation* _currentLocation;


}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, readonly) FactualAPI* apiObject;
@property (nonatomic, readonly) CLLocation* currentLocation;

+(FactualAPI*) getAPIObject;
+(AppDelegate*) getDelegate;

@end
