//
//  QueryPreferences.m
//  TableSearch
//
//  Created by Ahad Rana on 1/29/12.
//  Copyright 2012 Factual Inc. All rights reserved.
//

#import "QueryPreferences.h"
#import "LatLngSelector.h"

NSString * const PREFS_FACTUAL_TABLE = @"factual_table";
NSString * const SANDBOX_TABLE_DESC = @"US POI Sandbox";
NSString * const PLACES_TABLE_DESC = @"Places";
NSString * const RESTAURANTS_TABLE_DESC = @"US Restaurants";


NSString * const PREFS_GEO_ENABLED = @"enable_geo";
NSString * const PREFS_TRACKING_ENABLED = @"enable_track";
NSString * const PREFS_LATITUDE = @"lat";
NSString * const PREFS_LONGITUDE = @"lng";
NSString * const PREFS_RADIUS = @"radius";
NSString * const PREFS_OFFSET = @"offset";

NSString * const PREFS_LOCALITY_FILTER_ENABLED = @"enable_locality";
NSString * const PREFS_LOCALITY_FILTER_TYPE = @"locality_type";
NSString * const PREFS_LOCALITY_FILTER_TEXT = @"locality_filter";

NSString * const PREFS_CATEGORY_FILTER_ENABLED = @"enable_category";
NSString * const PREFS_CATEGORY_FILTER_TYPE = @"category_filter";

static NSString* localityFields[] = {
  @"locality",
  @"region",
  @"country",
  @"postcode"
};

static NSString* topLevelCategories[] = { 
  @"Arts, Entertainment & Nightlife",
  @"Automotive",
  @"Business & Professional Services",
  @"Community & Government",
  @"Education",
  @"Food & Beverage",
  @"Health & Medicine",
  @"Legal & Financial",
  @"Personal Care & Services",
  @"Real Estate & Home Improvement",
  @"Shopping",
  @"Sports & Recreation ",
  @"Travel & Tourism"
};

NSString* tableNames[] = {
    @"places",
    @"us-sandbox"
};

@implementation QueryPreferences
@synthesize localityCell,geoCell,categoryCell,localitySwitch,localitySegCtrl,localityFilter,geoSwitch,latFld,lngFld,mapItButton,radiusSlider,categorySwitch,categoryPicker,radiusLabel,locationTrackSwitch;



-(id)initWithNibNameAndPropertyList:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil propertyList:(NSMutableDictionary *)propertyList { 
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) { 
    self->_propertyList = propertyList;
  }
  
  int localityFieldCount = sizeof(localityFields)/sizeof(NSString*);
  
  NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] initWithCapacity:localityFieldCount];
  int i;
  for (i=0;i<localityFieldCount;++i) { 
    [dictionary setValue:[NSNumber numberWithInt:i] forKey:localityFields[i]];
  }
  
  _localityFieldToId = dictionary;
  
  int topLevelCategoryCount = sizeof(topLevelCategories)/sizeof(NSString*);

  dictionary = [[NSMutableDictionary alloc] initWithCapacity:topLevelCategoryCount];
  for (i=0;i<topLevelCategoryCount;++i) { 
    [dictionary setValue:[NSNumber numberWithInt:i] forKey:topLevelCategories[i]];
  }
  
  _categoryToId = dictionary;
  
  return self;
}


- (void) releaseReferences { 
  [localityCell release];
  [geoCell release];
  [categoryCell release];
  [localitySwitch release];
  [localitySegCtrl release];
  [localityFilter release];
  [geoSwitch release];
  [latFld release];
  [lngFld release];
  [mapItButton release];
  [radiusSlider release];
  [categorySwitch release];
  [categoryPicker release];
  [radiusLabel release];
  [locationTrackSwitch release];
  [_localityFieldToId release];
  [_categoryToId release];

  localityCell = nil;
  geoCell = nil;
  categoryCell = nil;
  localitySwitch = nil;
  localitySegCtrl = nil;
  localityFilter = nil;
  geoSwitch = nil;
  latFld = nil;
  lngFld = nil;
  mapItButton = nil;
  radiusSlider = nil;
  categorySwitch = nil;
  categoryPicker = nil;
  radiusLabel = nil;
  locationTrackSwitch = nil;
  _localityFieldToId = nil;
  _categoryToId = nil;
}


- (void)dealloc {
  
  [self releaseReferences];
    
  [super dealloc];
}


- (void)didReceiveMemoryWarning
{
  [self releaseReferences];

  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

-(void) toggleGeoEnabledState { 
  BOOL isEnabled = [[_propertyList valueForKey:PREFS_GEO_ENABLED] boolValue];
  BOOL isTrackingEnabled = [[_propertyList valueForKey:PREFS_TRACKING_ENABLED] boolValue];
  geoSwitch.on = isEnabled;
  locationTrackSwitch.on = (isEnabled && isTrackingEnabled);
  latFld.enabled = (isEnabled && !isTrackingEnabled);
  lngFld.enabled = (isEnabled  && !isTrackingEnabled);
  mapItButton.enabled = (isEnabled  && !isTrackingEnabled);
  radiusSlider.enabled = isEnabled;
  radiusLabel.enabled = isEnabled;
}

-(void) toggleLocalityEnabledState { 
  BOOL isEnabled = [[_propertyList valueForKey:PREFS_LOCALITY_FILTER_ENABLED] boolValue];
  localitySwitch.on = isEnabled;
  localitySegCtrl.enabled = isEnabled;
  localityFilter.enabled = isEnabled;
}

-(void) populateLocalityView { 
  [self toggleLocalityEnabledState];
  localitySegCtrl.selectedSegmentIndex = [[_localityFieldToId objectForKey:[_propertyList valueForKey:PREFS_LOCALITY_FILTER_TYPE]] intValue];
  localityFilter.text = [_propertyList valueForKey:PREFS_LOCALITY_FILTER_TEXT];
}

-(void) populateGeoView {
  
  [self toggleGeoEnabledState];
  
  NSNumber* latitude  = [_propertyList valueForKey:PREFS_LATITUDE];
  NSNumber* longitude = [_propertyList valueForKey:PREFS_LONGITUDE];
  NSNumber* radius    = [_propertyList valueForKey:PREFS_RADIUS];
  
  locationTrackSwitch.on = [[_propertyList valueForKey:PREFS_TRACKING_ENABLED] boolValue];
  latFld.text = [NSString stringWithFormat:@"%.5f",[latitude doubleValue]];
  lngFld.text = [NSString stringWithFormat:@"%.5f",[longitude doubleValue]];
  radiusSlider.value = [radius floatValue];
  radiusLabel.text = [NSString stringWithFormat:@"%.0fm",[radius floatValue]];
  
  
}

-(void) toggleCategoryEnabledState { 
  BOOL isEnabled = [[_propertyList valueForKey:PREFS_CATEGORY_FILTER_ENABLED] boolValue];
  categorySwitch.on = isEnabled;
  categoryPicker.userInteractionEnabled = isEnabled;
}

-(void) populateCategoryView { 
  
  [self toggleCategoryEnabledState];
  
  int selectionIndex = [[_categoryToId objectForKey:[_propertyList valueForKey:PREFS_CATEGORY_FILTER_TYPE]] intValue];
  [categoryPicker selectRow:selectionIndex inComponent:0 animated:NO];
}

-(void) populateControls { 
  [self populateGeoView];
  [self populateLocalityView];
  [self populateCategoryView];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [self populateControls];
  [super viewWillAppear:animated];
  int selectedTableIndex = [[_propertyList valueForKey:PREFS_FACTUAL_TABLE] intValue];
  [self.tableView selectRowAtIndexPath: [NSIndexPath indexPathForRow:selectedTableIndex inSection:0] animated:NO 
                        scrollPosition:UITableViewScrollPositionNone];
  
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (section == 0) { 
    return 2;
  }
  else { 
    return 1;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *kTableSelectorCellID = @"tableSelCellID";

  if (indexPath.section == 0) { 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableSelectorCellID];
    if (cell == nil)
    {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableSelectorCellID] autorelease];
      cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    int selectedTableIndex = [[_propertyList valueForKey:PREFS_FACTUAL_TABLE] intValue];
      
    cell.accessoryType = UITableViewCellAccessoryNone;

    cell.textLabel.text = tableNames[indexPath.row];
    if (selectedTableIndex == indexPath.row)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
      /*
    if (indexPath.row == 0) { 
      cell.textLabel.text = @"places";
      if (selectedTableIndex == 0) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
      }
    } else if (indexPath.row == 1) {
          cell.textLabel.text = @"restaurants";
          if (selectedTableIndex == 1) {
              cell.accessoryType = UITableViewCellAccessoryCheckmark;
          }
    } else if (indexPath.row == 2) {
          cell.textLabel.text = @"global";
          if (selectedTableIndex == 2) {
              cell.accessoryType = UITableViewCellAccessoryCheckmark;
          }
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"us-sandbox";
        if (selectedTableIndex == 3) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
       */
      
    return cell;
  }
  else if (indexPath.section == 1) { 
    return geoCell;
  }
  else if (indexPath.section == 2) { 
    return localityCell;
  }
  else if (indexPath.section == 3) { 
    return categoryCell;
  }
  return nil; 
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
  if (indexPath.section == 0) { 
    return 40;
  }
  else if (indexPath.section == 1) { 
    return geoCell.frame.size.height;
  }
  else if (indexPath.section == 2) { 
    return localityCell.frame.size.height;
  }
  else if (indexPath.section == 3) { 
    return categoryCell.frame.size.height;
  }
  return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
  if (section == 0) { 
    return @"Table";
  }
  else if (section == 1) { 
    return @"Geo";
  }
  else if (section == 2) { 
    return @"Locality";
  }
  else if (section == 3) { 
    return @"Category";
  }
  return nil;
}

#pragma mark - UIPickerViewDelegate 
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
  
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component { 
  return sizeof(topLevelCategories) / sizeof(NSString*);
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { 
  return topLevelCategories[row];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 0) {
    [_propertyList setValue:[NSNumber numberWithInteger:indexPath.row] forKey:PREFS_FACTUAL_TABLE];

    [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].accessoryType = 
      (indexPath.row == 0) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].accessoryType = 
      (indexPath.row == 1) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

  }
}

-(IBAction) onMapLatLng:(id) sender { 
  LatLngSelector *latLngView = [[[LatLngSelector alloc] initWithNibNameAndPropertyList:@"LatLngSelector" bundle:nil propertyList:_propertyList] autorelease];
  [self.navigationController pushViewController:latLngView animated:YES];
}

-(IBAction) onLatitudeChanged:(id) sender { 
  NSString* latValue = latFld.text;
  double latAsDbl = [latValue doubleValue];
  if (latAsDbl < -90.0 || latAsDbl > 90.0) { 
    latAsDbl=0.0;
  }
  [_propertyList setValue:[NSNumber numberWithDouble:latAsDbl] forKey:PREFS_LATITUDE];
  latFld.text = [NSString stringWithFormat:@"%.5f",latAsDbl];
}

-(IBAction) onLongitudeChanged:(id) sender { 
  NSString* lngValue = lngFld.text;
  double lngAsDbl = [lngValue doubleValue];
  if (lngAsDbl < -180.0 || lngAsDbl > 180.0) { 
    lngAsDbl=0.0;
  }
  [_propertyList setValue:[NSNumber numberWithDouble:lngAsDbl] forKey:PREFS_LONGITUDE];
  lngFld.text = [NSString stringWithFormat:@"%.5f",lngAsDbl];
}

-(IBAction)onRadiusChanged:(id)sender {
  radiusLabel.text = [NSString stringWithFormat:@"%.0f (m)",radiusSlider.value];
  [_propertyList setValue:[NSNumber numberWithDouble:(double)radiusSlider.value] forKey:PREFS_RADIUS];
}

-(IBAction) onGeoEnabledStateChanged:(id)sender { 
  [_propertyList setValue:[NSNumber numberWithBool:geoSwitch.on] forKey:PREFS_GEO_ENABLED];
  [self toggleGeoEnabledState];
}

-(IBAction) onTrackingEnabledStateChanged:(id)sender { 
  [_propertyList setValue:[NSNumber numberWithBool:locationTrackSwitch.on] forKey:PREFS_TRACKING_ENABLED];
  [self toggleGeoEnabledState];

}

-(IBAction) onLocalitySearchEnabled:(id)sender { 
  [_propertyList setValue:[NSNumber numberWithBool:localitySwitch.on] forKey:PREFS_LOCALITY_FILTER_ENABLED];
  [self toggleLocalityEnabledState];
}

-(IBAction) onLocalityTypeChanged:(id)sender { 
  NSString* fieldType = localityFields[localitySegCtrl.selectedSegmentIndex];
  [_propertyList setValue:fieldType forKey:PREFS_LOCALITY_FILTER_TYPE];
}

-(IBAction) onLocalityFilterTextChanged:(id)sender { 
  [_propertyList setValue:localityFilter.text forKey:PREFS_LOCALITY_FILTER_TEXT];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component { 
  [_propertyList setValue:topLevelCategories[row] forKey:PREFS_CATEGORY_FILTER_TYPE];
}

-(IBAction) onCategorySearchEnabled:(id)sender { 
  [_propertyList setValue:[NSNumber numberWithBool:categorySwitch.on] forKey:PREFS_CATEGORY_FILTER_ENABLED];
  [self toggleCategoryEnabledState];
}

@end
