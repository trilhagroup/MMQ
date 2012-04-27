//
//  MMQGraphViewController.m
//  MMQ
//
//  Created by Pedro Góes on 25/04/12.
//  Copyright (c) 2012 pedrogoes.info. All rights reserved.
//

#import "MMQGraphViewController.h"

@interface MMQGraphViewController ()

@end

@implementation MMQGraphViewController

@synthesize controller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet:)];
    self.navigationItem.rightBarButtonItem = actionButton;
    
    [self sortArrays];
    
    graph = [[CPTXYGraph alloc] initWithFrame:self.view.bounds];
    
    CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.view;
    hostingView.hostedGraph = graph;
    graph.paddingLeft = 20.0;
    graph.paddingTop = 20.0;
    graph.paddingTop = 20.0;
    graph.paddingBottom = 20.0;
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    
    float lengthX = [self lengthFromArray:controller.valuesX];
    float lengthY = [self lengthFromArray:controller.valuesY];
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat([self minValueInArray:controller.valuesX] - 0.1 * lengthX) length:CPTDecimalFromFloat(lengthX)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat([self minValueInArray:controller.valuesY] - 0.1 * lengthY) length:CPTDecimalFromFloat(lengthY)];

    
    CPTMutableLineStyle *lineStyle = [CPTLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor blackColor];
    lineStyle.lineWidth = 2.0f;
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    
    axisSet.xAxis.majorIntervalLength = [[NSNumber numberWithFloat:lengthX / 5.0f] decimalValue];
    axisSet.xAxis.minorTicksPerInterval = 4;
    axisSet.xAxis.majorTickLineStyle = lineStyle;
    axisSet.xAxis.minorTickLineStyle = lineStyle;
    axisSet.xAxis.axisLineStyle = lineStyle;
    axisSet.xAxis.minorTickLength = 5.0f;
    axisSet.xAxis.majorTickLength = 7.0f;
    axisSet.xAxis.labelOffset = 3.0f;
    
    axisSet.yAxis.majorIntervalLength = [[NSNumber numberWithFloat:lengthY / 5.0f] decimalValue];
    axisSet.yAxis.minorTicksPerInterval = 4;
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTickLineStyle = lineStyle;
    axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.minorTickLength = 5.0f;
    axisSet.yAxis.majorTickLength = 7.0f;
    axisSet.yAxis.labelOffset = 3.0f;
    
    plotGraph = [[CPTScatterPlot alloc] initWithFrame:graph.defaultPlotSpace.graph.bounds];
    plotGraph.identifier = @"X Inverse Plot";
    ((CPTMutableLineStyle *)plotGraph.dataLineStyle).lineWidth = 1.0f;
    ((CPTMutableLineStyle *)plotGraph.dataLineStyle).lineColor = [CPTColor redColor];
    plotGraph.dataSource = self;
    [graph addPlot:plotGraph];
    
    CPTScatterPlot *plotPoint = [[CPTScatterPlot alloc] initWithFrame:graph.defaultPlotSpace.graph.bounds];
    plotPoint.identifier = @"X Inverse Plot";
    ((CPTMutableLineStyle *)plotPoint.dataLineStyle).lineWidth = 1.0f;
    ((CPTMutableLineStyle *)plotPoint.dataLineStyle).lineColor = [CPTColor blackColor];
    plotPoint.dataSource = self;
    [graph addPlot:plotPoint];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (YES);
}

- (void)reloadView {
    [graph setNeedsDisplay];
}

NSInteger intSort(id num1, id num2, void *context) {
    int v1 = [(NSString *)num1 floatValue];
    int v2 = [(NSString *)num2 floatValue];
    if (v1 < v2)
        return NSOrderedAscending;
    else if (v1 > v2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

- (void)sortArrays {
    sortedValuesX = [controller.valuesX sortedArrayUsingFunction:intSort context:NULL];
    sortedValuesY = [controller.valuesY sortedArrayUsingFunction:intSort context:NULL];
}

- (float)maxValueInArray:(NSMutableArray *)arr {
    
    float max = 0.0;
    
    for (int i=0; i<[arr count]; i++) {
        max = MAX(max, [[arr objectAtIndex:i] floatValue]);
    }
    
    return max;
}

- (float)minValueInArray:(NSMutableArray *)arr {
    
    float min = 0.0;
    
    for (int i=0; i<[arr count]; i++) {
        min = MIN(min, [[arr objectAtIndex:i] floatValue]);
    }
    
    return min;
}

- (float)lengthFromArray:(NSMutableArray *)arr  {
    return ([self maxValueInArray:arr] - [self minValueInArray:arr]);
}

- (IBAction)showActionSheet:(id)sender {
    // Mostra popover para o botão
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Ações", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancelar", nil) destructiveButtonTitle:nil otherButtonTitles: NSLocalizedString(@"Ler com outro app", nil), nil];
    [action showFromBarButtonItem:actionButton animated:YES];
}

#pragma mark - Graph Data Source

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [sortedValuesX count];
}


- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    
    if (fieldEnum == CPTScatterPlotFieldX) {
        return [NSNumber numberWithFloat:[[sortedValuesX objectAtIndex:index] floatValue]];
    } else {
        if (plot == plotGraph) {
            NSLog(@"%f yeah", ([[sortedValuesX objectAtIndex:index] floatValue] * controller.a + controller.b));
            return [NSNumber numberWithFloat:([[sortedValuesX objectAtIndex:index] floatValue] * controller.a + controller.b)];
        } else {
            NSLog(@"%f", [[sortedValuesY objectAtIndex:index] floatValue]);
            return [NSNumber numberWithFloat:[[sortedValuesY objectAtIndex:index] floatValue]];
        }
    }
}

#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        ((CPTMutableLineStyle *)plotGraph.dataLineStyle).lineColor = [CPTColor redColor];
        [graph setNeedsDisplay];
    }
}

#pragma mark -
#pragma mark Split View Controller support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
     barButtonItem.title = NSLocalizedString(@"Arquivos", nil);
     NSMutableArray *items = [[toolbar items] mutableCopy];
     [items insertObject:barButtonItem atIndex:0];
     [toolbar setItems:items animated:YES];

}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
     NSMutableArray *items = [[toolbar items] mutableCopy];
     [items removeObjectAtIndex:0];
     [toolbar setItems:items animated:YES];

}

@end
