

#import <UIKit/UIKit.h>
#import <FactualSDK/FactualAPI.h>


@interface DetailView : UITableViewController {
  NSArray* _columns;
}

@property (nonatomic, retain) FactualRow *row;

-(id)initWithNibNameAndRow:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil row:(FactualRow*) row;
                                                                                          
@end
