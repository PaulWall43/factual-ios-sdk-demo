//
//  QueryPreferences.h
//  TableSearch
//
//  Created by Ahad Rana on 1/29/12.
//  Copyright 2012 Factual Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const PREFS_FACTUAL_TABLE;
extern NSString * const PLACES_TABLE_DESC;
extern NSString * const RESTAURANTS_TABLE_DESC;

extern NSString * const PREFS_GEO_ENABLED;
extern NSString * const PREFS_TRACKING_ENABLED;
extern NSString * const PREFS_LATITUDE;
extern NSString * const PREFS_LONGITUDE;
extern NSString * const PREFS_RADIUS;
extern NSString * const PREFS_OFFSET;

extern NSString * const PREFS_LOCALITY_FILTER_ENABLED;
extern NSString * const PREFS_LOCALITY_FILTER_TYPE;
extern NSString * const PREFS_LOCALITY_FILTER_TEXT;

extern NSString * const PREFS_CATEGORY_FILTER_ENABLED;
extern NSString * const PREFS_CATEGORY_FILTER_TYPE;
extern NSString* tableNames[];


@interface QueryPreferences : UITableViewController<UIPickerViewDataSource,UIPickerViewDelegate> { 

  IBOutlet UITableViewCell* localityCell;
  IBOutlet UITableViewCell* geoCell;
  IBOutlet UITableViewCell* categoryCell;
  
  IBOutlet UISwitch*           localitySwitch;
  IBOutlet UISegmentedControl* localitySegCtrl;
  IBOutlet UITextField*        localityFilter;

  IBOutlet UISwitch*         geoSwitch;
  IBOutlet UISwitch*         locationTrackSwitch;
  IBOutlet UITextField*      latFld;
  IBOutlet UITextField*      lngFld;
  IBOutlet UIButton*         mapItButton;
  IBOutlet UISlider*         radiusSlider;
  IBOutlet UILabel*          radiusLabel;
    
  
  IBOutlet UISwitch*         categorySwitch;
  IBOutlet UIPickerView*     categoryPicker;

  NSMutableDictionary* _propertyList;
  NSDictionary* _localityFieldToId;
  NSDictionary* _categoryToId;
}

@property (nonatomic, retain) IBOutlet UITableViewCell* localityCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* geoCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* categoryCell;
@property (nonatomic, retain) IBOutlet UISwitch* localitySwitch;
@property (nonatomic, retain) IBOutlet UISegmentedControl* localitySegCtrl;
@property (nonatomic, retain) IBOutlet UITextField* localityFilter;
@property (nonatomic, retain) IBOutlet UISwitch* geoSwitch;
@property (nonatomic, retain) IBOutlet UISwitch* locationTrackSwitch;
@property (nonatomic, retain) IBOutlet UITextField* latFld;
@property (nonatomic, retain) IBOutlet UITextField* lngFld;
@property (nonatomic, retain) IBOutlet UIButton* mapItButton;
@property (nonatomic, retain) IBOutlet UISlider* radiusSlider;
@property (nonatomic, retain) IBOutlet UISwitch* categorySwitch;
@property (nonatomic, retain) IBOutlet UIPickerView* categoryPicker;
@property (nonatomic, retain) IBOutlet UILabel* radiusLabel;

-(id)initWithNibNameAndPropertyList:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil propertyList:(NSMutableDictionary*) propertyList;
-(IBAction) onMapLatLng:(id) sender;
-(IBAction) onLatitudeChanged:(id) sender;
-(IBAction) onLongitudeChanged:(id) sender;
-(IBAction) onRadiusChanged:(id)sender;
-(IBAction) onGeoEnabledStateChanged:(id)sender;
-(IBAction) onTrackingEnabledStateChanged:(id)sender;
-(IBAction) onLocalitySearchEnabled:(id)sender;
-(IBAction) onLocalityTypeChanged:(id)sender;
-(IBAction) onLocalityFilterTextChanged:(id)sender;
-(IBAction) onCategorySearchEnabled:(id)sender;

@end
