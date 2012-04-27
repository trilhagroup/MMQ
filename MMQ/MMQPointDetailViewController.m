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

@synthesize tX, tY, indexPath, controller, firstResponder;

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


#pragma mark - User Methods

- (IBAction)inverterValores {
    NSString * temp = [NSString stringWithFormat:@"%@", tX.text];
    tX.text = tY.text;
    tY.text = temp;
}

- (void)negativarValor{
    NSString *nova = [((UITextField *)firstResponder).text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if ([nova isEqualToString:((UITextField *)firstResponder).text]) {
        nova = [((UITextField *)firstResponder).text stringByReplacingCharactersInRange:NSMakeRange(0, 0) withString:@"-"];
    }
    
    [((UITextField *)firstResponder) setText:nova];
}

- (IBAction)backgroundTap {
    [((UITextField *)firstResponder) resignFirstResponder];
}

- (void)salvarCampos {
    [controller.valuesX replaceObjectAtIndex:indexPath.row withObject:[tX.text stringByReplacingOccurrencesOfString:@"," withString:@"."]];
    [controller.valuesY replaceObjectAtIndex:indexPath.row withObject:[tY.text stringByReplacingOccurrencesOfString:@"," withString:@"."]];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tX.keyboardType = UIKeyboardTypeDecimalPad;
    tY.keyboardType = UIKeyboardTypeDecimalPad;
    
    UIView *inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 42.0)];
    inputAccessoryView.backgroundColor = [UIColor grayColor];
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake(215.0, 7.5, 100.0, 27.0);
    [cancelButton setTitle: @"Negativo" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(negativarValor) forControlEvents:UIControlEventTouchUpInside];
    [inputAccessoryView addSubview:cancelButton];
    
    tX.inputAccessoryView = inputAccessoryView;
    tY.inputAccessoryView = inputAccessoryView;
    
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
    
    firstResponder = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.4 animations:^{
        [self.view setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    }];
    
    // Importante liberar textField para não provocar problemas na cadeia de eventos
    firstResponder = nil;
}

@end
