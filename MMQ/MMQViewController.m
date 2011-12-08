//
//  MMQViewController.m
//  MMQ
//
//  Created by Pedro Góes on 16/05/11.
//  Copyright 2011 pedrogoes.info. All rights reserved.
//

#import "MMQViewController.h"
#import "MMQPointCell.h"
#import "MMQPointDetailViewController.h"

#define ARQUIVO_X @"x.plist"
#define ARQUIVO_Y @"y.plist"

@implementation MMQViewController

@synthesize valoresX, valoresY;

- (void)dealloc
{
    [valoresX release];
    [valoresY release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - IO Methods

- (void)salvarDados {
    [NSKeyedArchiver archiveRootObject:self.valoresX toFile:[[NSHomeDirectory() stringByAppendingPathComponent: @"Documents"] stringByAppendingPathComponent:ARQUIVO_X]];
    [NSKeyedArchiver archiveRootObject:self.valoresY toFile:[[NSHomeDirectory() stringByAppendingPathComponent: @"Documents"] stringByAppendingPathComponent:ARQUIVO_Y]];
}

- (void)carregarDados {
    id root = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSHomeDirectory() stringByAppendingPathComponent: @"Documents"] stringByAppendingPathComponent:ARQUIVO_X]];
    if (root) {
        self.valoresX = root;
    } else {
        self.valoresX = [NSMutableArray array];
    }
    
    root = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSHomeDirectory() stringByAppendingPathComponent: @"Documents"] stringByAppendingPathComponent:ARQUIVO_Y]];
    if (root) {
        self.valoresY = root;
    } else {
        self.valoresY = [NSMutableArray array];
    }
}

#pragma mark - User Methods

- (IBAction) calcular {
    
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
        
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Resultados" 
                              message: mensagem
                              delegate:self 
                              cancelButtonTitle:@"Ok" 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
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

- (IBAction) adicionarPonto {
    // Adicionaremos valores padrão aos vetores
    [valoresX insertObject:[[NSNumber numberWithFloat:0.0] stringValue] atIndex:0];
    [valoresY insertObject:[[NSNumber numberWithFloat:0.0] stringValue] atIndex:0];
    
    [tTabela insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationLeft];                                 
}

- (IBAction) entrarModoEdicao {
    [tTabela setEditing: ![tTabela isEditing] animated:YES];
}

- (void)atualizarTabela {
    [tTabela reloadData];
}

- (IBAction) infoSobre {
	
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"Sobre" 
						  message: @"Este programa calcula os valores de a e b incluindo seus erros (deltas) pelo Método dos Mínimos Quadrados.\n\nDesenvolvedor: Pedro P. M. Góes\n\nVersão atual: 1.1\nRelease: Novembro/2011\n"
						  delegate:self 
						  cancelButtonTitle:@"Ok" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self carregarDados];
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(adicionarPonto)] autorelease];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(entrarModoEdicao)] autorelease];
    self.navigationItem.title = @"MMQ";
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Podemos retornar a quantidade do vetor X ou Y (que DEVEM ter o mesmo número de elementos)
    return ([valoresX count]);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString * CustomCellIdentifier = @"CustomCellIdentifier";
    MMQPointCell * celula = (MMQPointCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
    
	if (celula == nil) {
		NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"MMQPointCell" owner:self options:nil];
		for (id oneObject in nib) {
			if ([oneObject isKindOfClass:[MMQPointCell class]]) {
				celula = (MMQPointCell *)oneObject;
			}
		}
	}
	
	// Construindo a célula
    celula.valorX.text = [valoresX objectAtIndex:indexPath.row];
    celula.valorY.text = [valoresY objectAtIndex:indexPath.row];  
    celula.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return celula;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [valoresX removeObjectAtIndex:indexPath.row];
        [valoresY removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationRight];
    }
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    // Vamos substituir os valores em ambos os vetores X e Y
    id objeto = [[valoresX objectAtIndex:(destinationIndexPath.row)] retain];
    [valoresX removeObjectAtIndex:(destinationIndexPath.row)];
    [valoresX insertObject:objeto atIndex:(sourceIndexPath.row)];
    [objeto release];
    
    objeto = [[valoresY objectAtIndex:(destinationIndexPath.row)] retain];
    [valoresY removeObjectAtIndex:(destinationIndexPath.row)];
    [valoresY insertObject:objeto atIndex:(sourceIndexPath.row)];
    [objeto release];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MMQPointDetailViewController *pdvc = [[MMQPointDetailViewController alloc] initWithNibName:@"MMQPointDetailViewController" bundle:nil];
    [self.navigationController pushViewController:pdvc animated:YES];
    
    pdvc.tX.text = [valoresX objectAtIndex:indexPath.row];
    pdvc.tY.text = [valoresY objectAtIndex:indexPath.row];
    pdvc.indexPath = indexPath;
    pdvc.controller = self;
    
    [pdvc release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

@end
