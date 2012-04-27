//
//  MMQGraphViewController.h
//  MMQ
//
//  Created by Pedro Góes on 25/04/12.
//  Copyright (c) 2012 pedrogoes.info. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
@class MMQViewController;

@interface MMQGraphViewController : UIViewController <CPTPlotDataSource, UIActionSheetDelegate, UISplitViewControllerDelegate> {
    IBOutlet MMQViewController *controller;
    IBOutlet CPTGraphHostingView *graphHostingView;
    CPTXYGraph *graph;
    CPTScatterPlot *plotGraph;
    
    NSArray *sortedValuesX;
    NSArray *sortedValuesY;
    
    UIBarButtonItem *actionButton;
    IBOutlet UIToolbar *toolbar;
    
    float lengthX, lengthY;
}

@property (strong) MMQViewController *controller;


- (void)reloadView;

@end
