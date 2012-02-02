//
//  DetailView.h
//  TableSearch
//
//  Created by Ahad Rana on 1/31/12.
//  Copyright (c) 2012 Factual Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FactualSDK/FactualAPI.h>


@interface DetailView : UITableViewController {
  NSArray* _columns;
}

@property (nonatomic, retain) FactualRow *row;

-(id)initWithNibNameAndRow:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil row:(FactualRow*) row;
                                                                                          
@end
