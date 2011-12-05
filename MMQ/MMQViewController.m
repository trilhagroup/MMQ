//
//  MMQViewController.m
//  MMQ
//
//  Created by Pedro Góes on 16/05/11.
//  Copyright 2011 pedrogoes.info. All rights reserved.
//

#import "MMQViewController.h"

@implementation MMQViewController

@synthesize bCalcular, tX, tY, tResultados, valoresX, valoresY;
@synthesize medioX, medioY, a, deltaA, b, deltaB, deltaY;

- (void)dealloc
{
    [bCalcular release];
    [tX release];
    [tY release];
    [valoresX release];
    [valoresY release];
    [tResultados release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction) calcular {
    self.valoresX = [self.tX.text componentsSeparatedByString:@" "];
    self.valoresY = [self.tY.text componentsSeparatedByString:@" "];
    
    if ([valoresX count] == [valoresY count]) {
        float soma = 0.0;
        float soma2 = 0.0;
        
        // Cálculo do médio x
        soma = 0.0;
        for (int i=0; i<[valoresX count]; i++) {
            soma = soma + [[valoresX objectAtIndex:i] floatValue];
        }
        medioX = soma / [valoresX count];
        
        // Cálculo do médio y
        soma = 0.0;
        for (int i=0; i<[valoresY count]; i++) {
            soma = soma + [[valoresY objectAtIndex:i] floatValue];
        }
        medioY = soma / [valoresY count];
        
        // Cálculo de a
        soma = 0.0;
        soma2 = 0.0;
        for (int i=0; i<[valoresX count]; i++) {
            soma = soma + (([[valoresX objectAtIndex:i] floatValue] - medioX) * [[valoresY objectAtIndex:i] floatValue]);
            soma2 = soma2 + powf(([[valoresX objectAtIndex:i] floatValue] - medioX), 2.0);
        }
        a = soma / soma2;
        
        // Cálculo de b
        b = medioY - (a * medioX);
        
        // Cálculo de deltaY
        soma = 0.0;
        for (int i=0; i<[valoresX count]; i++) {
            soma = soma + powf(((a*[[valoresX objectAtIndex:i] floatValue]) + b - [[valoresY objectAtIndex:i] floatValue]), 2.0);
        }
        deltaY = sqrtf(soma / ([valoresX count] - 2));
        
        // Cálculo de deltaA
        soma2 = 0.0;
        for (int i=0; i<[valoresX count]; i++) {
            soma2 = soma2 + powf(([[valoresX objectAtIndex:i] floatValue] - medioX), 2.0);
        }
        deltaA = deltaY / sqrtf(soma2);
        
        // Cálculo de deltaB
        soma = 0.0;
        soma2 = 0.0;
        for (int i=0; i<[valoresX count]; i++) {
            soma = soma + powf([[valoresX objectAtIndex:i] floatValue], 2.0);
            soma2 = soma2 + powf(([[valoresX objectAtIndex:i] floatValue] - medioX), 2.0);
        }
        deltaB = sqrtf(soma / ([valoresX count] * soma2)) * deltaY;
        
        NSString * mensagem = [[NSString alloc] initWithFormat:@"a = %f\nb = %f\ndeltaA = %f\ndeltaB = %f\ndeltaY = %f\n", a, b, deltaA, deltaB, deltaY];
        self.tResultados.text = mensagem;
        [mensagem release];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Ops..." 
                              message: @"Digite um número igual de valores (X e Y)."
                              delegate:self 
                              cancelButtonTitle:@"Ok" 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    

    
}

- (IBAction) backgroundTap: (id) sender {
    [self.tX resignFirstResponder];
    [self.tY resignFirstResponder];
}

- (IBAction) infoSobre {
	
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"Sobre" 
						  message: @"Este programa calcula os valores de a e b incluindo seus erros (deltas) pelo Método dos Mínimos Quadrados.\n\nDesenvolvedor: Pedro P. M. Góes\n\nVersão atual: 1.0\nRelease: Maio/2011\n"
						  delegate:self 
						  cancelButtonTitle:@"Ok" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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

#pragma mark -
#pragma mark UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

@end
