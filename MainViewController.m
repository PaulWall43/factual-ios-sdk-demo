//
//  MainViewController.m
//  TableSearch
//
//  Created by Ahad Rana on 1/31/12.
//  Copyright (c) 2012 Factual Inc. All rights reserved.
//

#import "MainViewController.h"
#import "DetailView.h"
#import "QueryPreferences.h"
#import "CLLocation (Strings).h"
#import "AppDelegate.h"
#import "NewWebView.h"
#import "QueryResultCell.h"
#import <MapKit/MapKit.h>


@interface FactualPlaceAnnotation : MKPointAnnotation
@property (nonatomic) NSNumber *index;
@end

@implementation FactualPlaceAnnotation
@end

@implementation MainViewController

@synthesize savedSearchTerm=_savedSearchTerm, searchWasActive,searchBar=_searchBar,queryResult=_queryResult;


#pragma mark - 
#pragma mark Lifecycle methods



- (void)updateStatusBar:(boolean_t) inWaitState gpsStatusTxt:(NSString*)gpsStatus apiStatusTxt:(NSString*) apiStatusText {
  
  if (inWaitState) {
    [_indicatorView startAnimating];
    [self setToolbarItems:_queryActiveStateToolbarItems animated:NO];
  }
  else {
    if ([_indicatorView isAnimating]) { 
      [_indicatorView stopAnimating];
      [self setToolbarItems:_idleStateToolbarItems animated:NO];
    }
  }
  if (gpsStatus != nil) {
    [_gpsStatusTxt release];
    _gpsStatusTxt = [gpsStatus retain];
  }
  if (apiStatusText != nil) {
    [_apiStatusTxt release];
    _apiStatusTxt = [apiStatusText retain];
  }
  NSString* labelText = [NSString stringWithFormat:@"%@\n%@",_gpsStatusTxt,_apiStatusTxt];
  _statusLabel.text = labelText;
}


-(void) populateQueryDefaults { 
  [_prefs setValue:[NSNumber numberWithInt:0 ] forKey:PREFS_FACTUAL_TABLE];
                    
  [_prefs setValue:[NSNumber numberWithBool:YES ] forKey:PREFS_GEO_ENABLED];
  [_prefs setValue:[NSNumber numberWithBool:YES ] forKey:PREFS_TRACKING_ENABLED];
  [_prefs setValue:[NSNumber numberWithDouble:35.059] forKey:PREFS_LATITUDE];
  [_prefs setValue:[NSNumber numberWithDouble:-119.418] forKey:PREFS_LONGITUDE];
  [_prefs setValue:[NSNumber numberWithDouble:5000.0] forKey:PREFS_RADIUS];
  [_prefs setValue:[NSNumber numberWithDouble:0] forKey:PREFS_OFFSET];
  
  [_prefs setValue:[NSNumber numberWithBool:YES] forKey:PREFS_LOCALITY_FILTER_ENABLED];
  [_prefs setValue:@"country" forKey:PREFS_LOCALITY_FILTER_TYPE];
  [_prefs setValue:@"US" forKey:PREFS_LOCALITY_FILTER_TEXT];
 
  [_prefs setValue:[NSNumber numberWithBool:NO] forKey:PREFS_CATEGORY_FILTER_ENABLED];
  [_prefs setValue:@"Food & Beverage" forKey:PREFS_CATEGORY_FILTER_TYPE];
}

-(id)initWithNibName:(NSString*)name bundle:(NSBundle*)bundle;
{
  self = [super initWithNibName:name bundle:bundle];

  _prefs = [[NSMutableDictionary alloc] init];
  
  [self populateQueryDefaults];

  return self;
}


- (void) createTopToolbar { 

  //create a fake toolbar 
  UIToolbar* toolbar = [[UIToolbar alloc]init];
  // calculate metrics
  [toolbar sizeToFit];
  //Caclulate the height of the toolbar
  CGFloat toolbarHeight = [toolbar frame].size.height;
  //Get the bounds of the parent view
  CGRect viewBounds = self.parentViewController.view.bounds;
  //Get the width of the parent view,
  CGFloat rootViewWidth = CGRectGetWidth(viewBounds);
  // release fake toolbar 
  [toolbar release];
  // create serch bar ... 
  self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, rootViewWidth, toolbarHeight)] autorelease];
  _searchBar.backgroundColor = [UIColor whiteColor];
 // _searchBar.showsCancelButton = YES;
  _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
  _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
  // _searchBar.spellCheckingType = UITextSpellCheckingTypeNo;
  _searchBar.showsSearchResultsButton = YES;
  _searchBar.searchResultsButtonSelected = YES;
  _searchBar.delegate = self;
  // initialize with previous full text query 
  _searchBar.text = self.savedSearchTerm;
    
  // add it navigation controller
  self.navigationController.navigationBar.topItem.titleView = _searchBar;

}
- (void) newRowHandler
{
    NewWebView *webView = [[NewWebView alloc] init];
    [self.navigationController pushViewController:webView animated:YES];
}
- (void)createBottomToolbar { 
  /*
  UIImage* refreshImage = [UIImage imageNamed:@"01-refresh"];
  UIImage* settingsImage = [UIImage imageNamed:@"20-gear2"];
 
  _indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(3, 3, 25, 25)];
  _indicatorView.backgroundColor = [UIColor clearColor];
  _indicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
  
  _statusLabel = [[UILabel alloc]init];
  _statusLabel.font = [UIFont boldSystemFontOfSize:11];
  _statusLabel.backgroundColor = [UIColor clearColor];
  _statusLabel.textColor = [UIColor whiteColor];
  _statusLabel.frame = CGRectMake(25, 0, 170, 40);
  _statusLabel.text = @"some text\nand some more text!";
  _statusLabel.textAlignment = UITextAlignmentLeft;
  _statusLabel.lineBreakMode = UILineBreakModeClip;
  _statusLabel.adjustsFontSizeToFitWidth = NO;
  _statusLabel.numberOfLines = 2;

  _idleStateToolbarItems = [[NSArray arrayWithObjects:
                           
                           [[UIBarButtonItem alloc] initWithImage:refreshImage style:UIBarButtonItemStylePlain 
                                                                         target:self
                                                                         action:@selector(doQuery:)],
                           
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil],
                           
                           
                           [[UIBarButtonItem alloc] initWithCustomView:_statusLabel],
                           
                           [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(newRowHandler)],
                           
                           [[UIBarButtonItem alloc] initWithImage:settingsImage style:UIBarButtonItemStylePlain 
                                                                         target:self
                                                                         action:@selector(doEditPreferences:)],
   
                           nil] retain];
  
  [_idleStateToolbarItems makeObjectsPerformSelector:@selector(release)];
  
  _queryActiveStateToolbarItems = [[NSArray arrayWithObjects:
                                     
                                    [[UIBarButtonItem alloc] initWithCustomView:_indicatorView],

                                    
                                    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil],
                                     
                                     
                                    //[[UIBarButtonItem alloc] initWithCustomView:_statusLabel],
                                     
                                     
                                    nil] retain];
  
  [_queryActiveStateToolbarItems makeObjectsPerformSelector:@selector(release)];


  self.toolbarItems = _idleStateToolbarItems;
   */
    
    _indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(3, 3, 25, 25)];
    _indicatorView.backgroundColor = [UIColor clearColor];
    _indicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    
    _idleStateToolbarItems = [[NSArray arrayWithObjects:
                               [[UIBarButtonItem alloc] initWithTitle:@"Add A New Place" style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(newRowHandler)], nil
                               ] retain];
    
    [_idleStateToolbarItems makeObjectsPerformSelector:@selector(release)];
    
    _queryActiveStateToolbarItems = [[NSArray arrayWithObjects:
                                      
                                      [[UIBarButtonItem alloc] initWithCustomView:_indicatorView],
                                      [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil],
                                      
                                      nil] retain];
    [_queryActiveStateToolbarItems makeObjectsPerformSelector:@selector(release)];
    
    self.toolbarItems = _idleStateToolbarItems;
    
}


- (void) doEditPreferences:(id)sender {
    _refreshRequired = YES;
    QueryPreferences *prefsView = [[QueryPreferences alloc] initWithNibNameAndPropertyList:@"QueryPreferences" bundle:nil propertyList:_prefs];
    [self.navigationController pushViewController:prefsView animated:YES];
    [prefsView release];
}

- (void)mapView:(MKMapView *)mapView
didChangeUserTrackingMode:(MKUserTrackingMode)mode
       animated:(BOOL)animated
{
    NSLog(@"CHanging tracking mode");
     _locationOverride = nil;
     [self doQuery:nil];
}

- (void)viewDidLoad {	

  _gpsStatusTxt = @"";
  _apiStatusTxt = @"";
  
  [super viewDidLoad];
  
  [self createTopToolbar];
    
  CGRect viewBounds = self.view.bounds;
  CGFloat rootViewWidth = CGRectGetWidth(viewBounds);
  CGFloat rootViewHeight = CGRectGetHeight(viewBounds);
    double mapBottom = rootViewHeight/3;
  self.mapView = [[[MKMapView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, rootViewWidth, mapBottom)] autorelease];
    
  MKUserTrackingBarButtonItem *trackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
   // _locationOverride = [[CLLocation alloc]initWithLatitude:center.latitude longitude:center.longitude];
//    [self doQuery:nil];
    
    
  UIBarButtonItem* buttonItem =[[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain  target:self action:@selector(doEditPreferences:)];

  self.navigationItem.rightBarButtonItem = buttonItem;
  self.navigationItem.leftBarButtonItem = trackingButton;

  self.mapView.showsUserLocation = YES;
  self.mapView.userTrackingMode = MKUserTrackingModeFollow;
  self.mapView.delegate = self;
    
  [self.view addSubview:self.mapView];
    
    
    UIPanGestureRecognizer* panRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragMap:)];
    [panRec setDelegate:self];
    [self.mapView addGestureRecognizer:panRec];

    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, mapBottom, self.view.bounds.size.width, 1)];
    topLineView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:topLineView];

    
    /*
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAnim:)];
    [self.mapView addGestureRecognizer:panGesture];
    [panGesture release];
    
    */
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, mapBottom+1, rootViewWidth, rootViewHeight - mapBottom)];
  self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.view addSubview:self.tableView];
    
  [self createBottomToolbar];

    /*
  */
    
}


- (void) updateQueryLocation {
  [_queryLocation release];
  _queryLocation = nil;
  
  _locationEnabled = [[_prefs valueForKey:PREFS_GEO_ENABLED] boolValue];
  _trackingEnabled = [[_prefs valueForKey:PREFS_TRACKING_ENABLED] boolValue];

  BOOL gpsStale = NO;
  if (_locationEnabled) { 
    if (_trackingEnabled) { 
      gpsStale = YES;
     
        if (_locationOverride != nil) {
            _queryLocation = [_locationOverride copy];
        } else if ([AppDelegate getDelegate].currentLocation != nil) { 
            _queryLocation = [[AppDelegate getDelegate].currentLocation copy];
        }
        [_prefs setValue:[NSNumber numberWithDouble:_queryLocation.coordinate.latitude] forKey:PREFS_LATITUDE];
        [_prefs setValue:[NSNumber numberWithDouble:_queryLocation.coordinate.longitude] forKey:PREFS_LONGITUDE];
      gpsStale = NO;
    }
    //if location is still NULL, pick it up from prefs (if possible)
    if (_queryLocation == nil) { 
      CLLocationCoordinate2D coordinate = {
        [((NSNumber*)[_prefs valueForKey:PREFS_LATITUDE]) doubleValue],
        [((NSNumber*)[_prefs valueForKey:PREFS_LONGITUDE]) doubleValue]
      };
      _queryLocation = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    }
      

      
  }
  
  NSString* gpsStatus = nil;
  if (_queryLocation != nil) {
    NSString* coordStr = _queryLocation.localizedCoordinateString;
    NSString* accuracyStr = _queryLocation.localizedHorizontalAccuracyString;
    
    gpsStatus = [NSString stringWithFormat:@"%@ (+/-) %@",coordStr,
            (_trackingEnabled) ? 
            ((gpsStale) ? @"(Cached)" : accuracyStr) : @"(Cached)" ];
  }
  else {
    gpsStatus = @"(GPS OFF)";
  }
  
  [self updateStatusBar:YES gpsStatusTxt:gpsStatus apiStatusTxt:nil];
}


- (void)doQuery:(id) sender { 

  _refreshRequired = NO;
    
  if (!_mergeResults) {
    self.queryResult = nil;
  }
  
  [self.tableView reloadData];
  
  [self updateQueryLocation];
  
  FactualQuery* queryObject = [FactualQuery query];
  
    // set limit
  queryObject.offset = [[_prefs valueForKey:PREFS_OFFSET] integerValue];
  queryObject.limit = 20;
  
  if (_locationEnabled) { 
    // set geo location 
    CLLocationCoordinate2D coordinate = {
      [((NSNumber*)[_prefs valueForKey:PREFS_LATITUDE]) doubleValue],
      [((NSNumber*)[_prefs valueForKey:PREFS_LONGITUDE]) doubleValue]
    };
    
    // set geo filter 
    [queryObject setGeoFilter:coordinate 
               radiusInMeters:[((NSNumber*)[_prefs valueForKey:PREFS_RADIUS]) doubleValue]];
    
    
  }
  else { 
    // sort by relevance if full text available ... 
    if (self.savedSearchTerm != nil && self.savedSearchTerm.length != 0) {
      FactualSortCriteria* primarySort = [[[FactualSortCriteria alloc] initWithFieldName:@"$relevance" sortOrder:FactualSortOrder_Ascending] autorelease];
      // set the sort criteria 
      [queryObject setPrimarySortCriteria:primarySort];
    }
  }
  
  // full text term  
  if (self.savedSearchTerm != nil && self.savedSearchTerm.length != 0) { 
    [queryObject addFullTextQueryTerms:self.savedSearchTerm, nil];
  }
  
  // check if locality filter is on ... 
  if ([[_prefs valueForKey:PREFS_LOCALITY_FILTER_ENABLED] boolValue]) { 
    // see if locality value is present 
    NSString* localityFilterText = [_prefs valueForKey:PREFS_LOCALITY_FILTER_TEXT];
    if (localityFilterText.length != 0) { 
      [queryObject addRowFilter:[FactualRowFilter fieldName:
                                           [_prefs valueForKey:PREFS_LOCALITY_FILTER_TYPE] 
                                           equalTo:localityFilterText]];
    }
  }
  
  // check if category filter is on ... 
  if ([[_prefs valueForKey:PREFS_CATEGORY_FILTER_ENABLED] boolValue]) { 
    // see if locality value is present 
    NSString* categoryName = [_prefs valueForKey:PREFS_CATEGORY_FILTER_TYPE];
    if (categoryName.length != 0) { 
      [queryObject addRowFilter:[FactualRowFilter fieldName:@"category" beginsWith:categoryName]];
    }
  }
  
  // figure out table to use ... 
  NSString* tableName = [self currentTable];

  // mark start time
  _requestStartTime = [[NSDate date] timeIntervalSince1970];
  
  // start the request ... 
  _activeRequest = [[[AppDelegate getAPIObject] queryTable:tableName optionalQueryParams:queryObject withDelegate:self] retain];
  
}

-(NSString*) currentTable {
    int selectedTableIndex = [[_prefs valueForKey:PREFS_FACTUAL_TABLE] intValue];
    NSString* tableName = tableNames[selectedTableIndex];
    return tableName;
}

-(void) clearReferences { 
	[_prefs release];
  [_savedSearchTerm release];
  [_searchBar release];
  [_activeRequest release];
  [_prefs release];
  [_queryResult release];
  [_statusLabel release];
  [_indicatorView release];
  [_idleStateToolbarItems release];
  [_queryActiveStateToolbarItems release];
  [_gpsStatusTxt release];
  [_apiStatusTxt release];
  
  _prefs = nil;
  _savedSearchTerm = nil;
  _searchBar = nil;
  _activeRequest = nil;
  _prefs = nil;
  _queryResult= nil;
  _statusLabel = nil;
  _indicatorView = nil;
  _idleStateToolbarItems = nil;
  _queryActiveStateToolbarItems = nil;
  _gpsStatusTxt = nil;
  _apiStatusTxt = nil;
}

- (void)viewDidUnload
{
  [self clearReferences];
}


-(void) viewWillAppear:(BOOL)animated { 
  [self.navigationController setToolbarHidden:NO animated:animated];
  [self.navigationController setNavigationBarHidden:NO animated:animated];
	self.tableView.scrollEnabled = YES;
  if (_refreshRequired) {
    [_prefs setValue:0 forKey:PREFS_OFFSET];
    [self doQuery:nil];
  }
}

-(void) viewWillDisappear:(BOOL)animated { 
    // save the state of the search UI so that it can be restored if the view is re-created
  [self.navigationController setToolbarHidden:YES animated:animated];
  [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)dealloc
{
  [self clearReferences];
  
	[super dealloc];
}
#pragma mark -


#pragma mark UITableView data source and delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.queryResult != nil) { 
    FactualRow* row = [self.queryResult.rows objectAtIndex:indexPath.row];
    if (row != nil) { 
      DetailView *detailView = [[DetailView alloc] initWithNibNameAndRow:@"DetailView" bundle:nil row:row];
      
      [self.navigationController pushViewController:detailView animated:YES];
      [detailView release];
    }
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  int result=0;
  if (self.queryResult != nil) {
    result = [self.queryResult.rows count];
  }
  return result;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *kCellID = @"cellID";

	if (self.queryResult != nil) {
/*
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (cell == nil)
    {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    FactualRow* row = [self.queryResult.rows objectAtIndex:indexPath.row];
 
    cell.textLabel.text = [row valueForName:@"name"];
 
    return cell;
 */
        FactualRow* row = [self.queryResult.rows objectAtIndex:indexPath.row];
        
        static NSString *CellIdentifier = @"Cell";
        
        QueryResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            
            NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"QueryResultView" owner:nil options:nil];
            
            for (UIView *view in views) {
                if([view isKindOfClass:[UITableViewCell class]])
                {
                    cell = (QueryResultCell*)view;
                    UILabel *label;
                    label = (UILabel *)[cell viewWithTag:1];
                    label.text = [NSString stringWithFormat:@"%@", [row valueForName:@"name"]];
                    [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:12]];

                    label = (UILabel *)[cell viewWithTag:2];
                    NSArray *labels = [row valueForName:@"category_labels"];
                    if (labels != nil && [labels count] > 0) {
                        NSString *labelStr = [[labels objectAtIndex: 0] componentsJoinedByString:@" > "];
                        label.text = [NSString stringWithFormat:@"%@",labelStr];
                    } else {
                        label.text = @"No category";
                    }

                    label = (UILabel *)[cell viewWithTag:3];
                    label.text = [NSString stringWithFormat:@"%.1fm | %@", [[row valueForName:@"$distance"] doubleValue], [row valueForName:@"address"]];
                }
            }
        }
        return cell;
        
  }
  return nil;
}

#pragma mark -
#pragma mark FactualAPIDelegate methods

- (void)requestDidReceiveInitialResponse:(FactualAPIRequest *)request {
  if (request == _activeRequest) {
    [self updateStatusBar:YES gpsStatusTxt:nil apiStatusTxt:@"Recvd Response..."];
  }
  
}

- (void)requestDidReceiveData:(FactualAPIRequest *)request { 
  if (request == _activeRequest) {
    [self updateStatusBar:YES gpsStatusTxt:nil apiStatusTxt:@"Recvd Data..."];
  }  
}


-(void) requestComplete:(FactualAPIRequest *)request failedWithError:(NSError *)error {
  if (_activeRequest == request) {
    [_activeRequest release];
    _activeRequest = nil;
    UIAlertView* alertView = [[[UIAlertView alloc] 
     initWithTitle:@"Factual API Error" 
     message:[error localizedDescription] 
     delegate:self 
                               cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    
    [alertView show];
    
    
    NSLog(@"Active request failed with Error:%@", [error localizedDescription]);
    [self updateStatusBar:NO gpsStatusTxt:nil apiStatusTxt:[NSString stringWithFormat:@"Failed:%@",[error localizedDescription]]];
  }
}


-(void) requestComplete:(FactualAPIRequest *)request receivedQueryResult:(FactualQueryResult *)queryResultObj {
  if (_activeRequest == request) {
    NSLog(@"Active request Completed with row count:%d TableId:%@ RequestTableId:%@", [self.queryResult rowCount], self.queryResult.tableId,request.tableId);

  // get time now ... 
  NSTimeInterval timeNow = [[NSDate date] timeIntervalSince1970];
  // figure out delta 
  NSTimeInterval delta = timeNow - _requestStartTime;
    
  [self updateStatusBar:NO gpsStatusTxt:nil apiStatusTxt:[NSString stringWithFormat:@"Completed in: %.3f(s) Rows:%d/%d",delta,[queryResultObj rowCount],(int)[queryResultObj totalRows]]];

      if (_mergeResults) {
          int i;
          for (i = 0; i < [queryResultObj.rows count]; i++) {
              FactualRow* row = [queryResultObj.rows objectAtIndex:i];
              [self.queryResult.rows addObject: row];
          }
      } else {
          self.queryResult = queryResultObj;
      }
      _mergeResults = false;
      
    [_activeRequest release];
    _activeRequest = nil;

    // reload table view ..
    [self.tableView reloadData];
      
      NSMutableArray * annotationsToRemove = [ self.mapView.annotations mutableCopy ] ;
      [ annotationsToRemove removeObject:self.mapView.userLocation ] ;
      [ self.mapView removeAnnotations:annotationsToRemove ] ;

      int i;
      for (i = 0; i < [self.queryResult.rows count]; i++) {
          FactualRow* row = [self.queryResult.rows objectAtIndex:i];
          FactualPlaceAnnotation *point = [[FactualPlaceAnnotation alloc] init];
          CLLocationDegrees latitude = [[row valueForName:@"latitude"] doubleValue];
          CLLocationDegrees longitude = [[row valueForName:@"longitude"] doubleValue];
          CLLocationCoordinate2D coordinate;
          coordinate.latitude = latitude;
          coordinate.longitude = longitude;
          point.coordinate = coordinate;
          point.title = [row valueForName:@"name"];
          point.index = i;
          [self.mapView addAnnotation:point];
          //NSLog(@"HERE: %@",[row valueForName:@"latitude"] );
      }
      // Add an annotation
  }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        
        MKPinAnnotationView *annotationView =
        (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc]
                              initWithAnnotation:annotation
                              reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        // Create a UIButton object to add on the
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        [annotationView setRightCalloutAccessoryView:rightButton];
        
        return annotationView;
    }
    return nil; 
}

#pragma mark -

#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar { 
  if ([searchBar.text length] == 0) {
    searchBar.text = searchBar.text = @"\u200B";
  }
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
  if ([searchText length] == 0) {
    theSearchBar.text = @"\u200B";
  }
  else if ([searchText length] > 1) {
    if ([searchText characterAtIndex:0] == 0x200B) {
      [theSearchBar setText: [searchText substringFromIndex:1]];
    }
  }
}


- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar { 
  return YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBarObj {
  if ([searchBarObj.text length] >= 1 && [searchBarObj.text characterAtIndex:0] == 0x200B) {
    self.savedSearchTerm = [searchBarObj.text substringFromIndex:1];
  }
  else { 
    self.savedSearchTerm = searchBarObj.text;
  }
  
  if ([searchBarObj isFirstResponder]) { 
    [searchBarObj resignFirstResponder];
  }
  [self doQuery:nil];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBarObj { 
  searchBarObj.text = self.savedSearchTerm;
  if ([searchBarObj.text length] == 0) { 
    searchBarObj.text = @"\u200B";
  }
  
  if ([searchBarObj isFirstResponder]) { 
    [searchBarObj resignFirstResponder];
  }
}
#pragma mark -

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    /*
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    
    [_prefs setValue:[NSNumber numberWithDouble:location.latitude] forKey:PREFS_LATITUDE];
    [_prefs setValue:[NSNumber numberWithDouble: location.longitude] forKey:PREFS_LONGITUDE];
    region.span = span;
    region.center = location;
    [self.mapView setRegion:region animated:YES];
     */
}
- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    if([view.annotation isKindOfClass:[FactualPlaceAnnotation class]]) {
        FactualPlaceAnnotation *annotation = view.annotation;
        NSLog(@"The annotation tapped is: %@", annotation.title);
        FactualRow* row = [self.queryResult.rows objectAtIndex:annotation.index];
        //if (row != nil) {
        DetailView *detailView = [[DetailView alloc] initWithNibNameAndRow:@"DetailView" bundle:nil row:row];
        [self.navigationController pushViewController:detailView animated:YES];
        [detailView release];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if([view.annotation isKindOfClass:[FactualPlaceAnnotation class]]) {
        _ignoreLoadMore = true;
        FactualPlaceAnnotation *annotation = view.annotation;
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:annotation.index inSection:0]
                           animated:YES
                     scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_activeRequest == nil && indexPath.row == [_queryResult.rows count] - 1) {
        if (_ignoreLoadMore) {
            _ignoreLoadMore = false;
        } else {
            NSLog(@"Load more");
            NSNumber *offset = [_prefs valueForKey:PREFS_OFFSET];
            NSNumber *newOffset = [NSNumber numberWithInt:[offset intValue] + 20];
            [_prefs setValue:newOffset forKey:PREFS_OFFSET];
            _mergeResults = true;
            [self doQuery:nil];
        }
    }
}

/*

- (void)scrollViewDidScroll: (UIScrollView*)scroll {
    // UITableView only moves in one direction, y axis
    NSInteger currentOffset = scroll.contentOffset.y;
    NSInteger maximumOffset = scroll.contentSize.height - scroll.frame.size.height;
    
    // Change 10.0 to adjust the distance from bottom
    if (_activeRequest == nil && maximumOffset - currentOffset <= 10.0) {
        NSNumber *offset = [_prefs valueForKey:PREFS_OFFSET];
        NSNumber *newOffset = [NSNumber numberWithInt:[offset intValue] + 20];
        [_prefs setValue:newOffset forKey:PREFS_OFFSET];
        _mergeResults = true;
        [self doQuery:nil];
    }
}
 */
/*
-(void) panAnim:(UIPanGestureRecognizer*) gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        CLLocationCoordinate2D center = [self.mapView centerCoordinate];
        NSLog(@"HERE: %f", center.latitude);
        _locationOverride = [[CLLocation alloc]initWithLatitude:center.latitude longitude:center.longitude];
        [self doQuery:nil];
    }
}
*/
/*
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    CLLocationCoordinate2D center = [self.mapView centerCoordinate];
    NSLog(@"HERE: %f", center.latitude);
    _locationOverride = [[CLLocation alloc]initWithLatitude:center.latitude longitude:center.longitude];
    [self doQuery:nil];
}
*/

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)didDragMap:(UIGestureRecognizer*)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        NSLog(@"drag ended");

        CLLocationCoordinate2D center = [self.mapView centerCoordinate];
        NSLog(@"HERE: %f", center.latitude);
        _locationOverride = [[CLLocation alloc]initWithLatitude:center.latitude longitude:center.longitude];
        [self doQuery:nil];
        
    }
}


@end

