//
//  MMQPointDetailViewController.m
//  MMQ
//
//  Created by Pedro Góes on 05/12/11.
//  Copyright (c) 2011 pedrogoes.info. All rights reserved.
//

#import "MMQPointDetailViewController.h"
#import "MMQViewController.h"


@implementation MMQPointDetailViewController

@synthesize tX, tY, indexPath, controller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [tX release];
    [tY release];
    [indexPath release];
    [super dealloc];
}

#pragma mark - User Methods

- (IBAction)inverterValores {
    NSString * temp = [NSString stringWithFormat:@"%@", tX.text];
    tX.text = tY.text;
    tY.text = temp;
}

- (IBAction)backgroundTap {
    [tX resignFirstResponder];
    [tY resignFirstResponder];
}

- (void)salvarCampos {
    [controller.valoresX replaceObjectAtIndex:indexPath.row withObject:tX.text];
    [controller.valoresY replaceObjectAtIndex:indexPath.row withObject:tY.text];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tX.keyboardType = UIKeyboardTypeDecimalPad;
    tY.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self salvarCampos];
    
    [controller atualizarTabela];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.4 animations:^{
        [self.view setFrame:CGRectMake(0.0, -81.0, self.view.frame.size.width, self.view.frame.size.height)];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.4 animations:^{
        [self.view setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    }];
}

@end
