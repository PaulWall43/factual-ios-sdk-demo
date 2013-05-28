//
//  DetailView.h
//  TableSearch
//
//  Created by Ahad Rana on 1/31/12.
//  Copyright (c) 2012 Factual Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FactualSDK/FactualAPI.h>
#import <MapKit/MapKit.h>


@interface DetailView : UIViewController<UITableViewDelegate,UITableViewDataSource> {
  NSArray* _columns;
}

@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) MKMapView *mapView;
@property (nonatomic, retain) FactualRow *row;

-(id)initWithNibNameAndRow:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil row:(FactualRow*) row;
                                                                                          
@end
