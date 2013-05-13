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

@synthesize xTextField, yTextField, indexPath, controller, firstResponder;

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
    NSString * temp = [NSString stringWithFormat:@"%@", xTextField.text];
    xTextField.text = yTextField.text;
    yTextField.text = temp;
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
    [controller.valuesX replaceObjectAtIndex:indexPath.row withObject:[xTextField.text stringByReplacingOccurrencesOfString:@"," withString:@"."]];
    [controller.valuesY replaceObjectAtIndex:indexPath.row withObject:[yTextField.text stringByReplacingOccurrencesOfString:@"," withString:@"."]];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        // Do add a negative option
        UIView *inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.superview.frame.size.width, 42.0)];
        inputAccessoryView.backgroundColor = [UIColor grayColor];
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancelButton.frame = CGRectMake(215.0, 7.5, 100.0, 27.0);
        [cancelButton setTitle: NSLocalizedString(@"Negative", nil) forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(negativarValor) forControlEvents:UIControlEventTouchUpInside];
        [inputAccessoryView addSubview:cancelButton];
        
        xTextField.inputAccessoryView = inputAccessoryView;
        yTextField.inputAccessoryView = inputAccessoryView;
        
        
        xTextField.keyboardType = UIKeyboardTypeDecimalPad;
        yTextField.keyboardType = UIKeyboardTypeDecimalPad;
    } else {
        xTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        yTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    
    [instructionLabel setText:NSLocalizedString(@"Define X and Y values of the point:", @"Defina os valores X e Y do ponto:")];
    [invertButton setTitle:NSLocalizedString(@"Invert Values", @"Inverter Valores") forState:UIControlStateNormal];
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
