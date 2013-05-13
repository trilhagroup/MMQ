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
#import "MMQGraphViewController.h"

#define ARQUIVO_X @"x.plist"
#define ARQUIVO_Y @"y.plist"

@implementation MMQViewController

@synthesize valuesX, valuesY, a, b;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - IO Methods

- (void)salvarDados {
    [NSKeyedArchiver archiveRootObject:self.valuesX toFile:[[NSHomeDirectory() stringByAppendingPathComponent: @"Documents"] stringByAppendingPathComponent:ARQUIVO_X]];
    [NSKeyedArchiver archiveRootObject:self.valuesY toFile:[[NSHomeDirectory() stringByAppendingPathComponent: @"Documents"] stringByAppendingPathComponent:ARQUIVO_Y]];
}

- (void)carregarDados {
    id root = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSHomeDirectory() stringByAppendingPathComponent: @"Documents"] stringByAppendingPathComponent:ARQUIVO_X]];
    if (root) {
        self.valuesX = root;
    } else {
        self.valuesX = [NSMutableArray array];
    }
    
    root = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSHomeDirectory() stringByAppendingPathComponent: @"Documents"] stringByAppendingPathComponent:ARQUIVO_Y]];
    if (root) {
        self.valuesY = root;
    } else {
        self.valuesY = [NSMutableArray array];
    }
}

#pragma mark - User Methods

- (IBAction) calcular {
    
    if ([valuesX count] == [valuesY count]) {
        float soma = 0.0;
        float soma2 = 0.0;
        
        // Cálculo do médio x
        soma = 0.0;
        for (int i=0; i<[valuesX count]; i++) {
            soma = soma + [[valuesX objectAtIndex:i] floatValue];
        }
        medioX = soma / [valuesX count];
        
        // Cálculo do médio y
        soma = 0.0;
        for (int i=0; i<[valuesY count]; i++) {
            soma = soma + [[valuesY objectAtIndex:i] floatValue];
        }
        medioY = soma / [valuesY count];
        
        // Cálculo de a
        soma = 0.0;
        soma2 = 0.0;
        for (int i=0; i<[valuesX count]; i++) {
            soma = soma + (([[valuesX objectAtIndex:i] floatValue] - medioX) * [[valuesY objectAtIndex:i] floatValue]);
            soma2 = soma2 + powf(([[valuesX objectAtIndex:i] floatValue] - medioX), 2.0);
        }
        a = soma / soma2;
        
        // Cálculo de b
        b = medioY - (a * medioX);
        
        // Cálculo de deltaY
        soma = 0.0;
        for (int i=0; i<[valuesX count]; i++) {
            soma = soma + powf(((a*[[valuesX objectAtIndex:i] floatValue]) + b - [[valuesY objectAtIndex:i] floatValue]), 2.0);
        }
        deltaY = sqrtf(soma / ([valuesX count] - 2));
        
        // Cálculo de deltaA
        soma2 = 0.0;
        for (int i=0; i<[valuesX count]; i++) {
            soma2 = soma2 + powf(([[valuesX objectAtIndex:i] floatValue] - medioX), 2.0);
        }
        deltaA = deltaY / sqrtf(soma2);
        
        // Cálculo de deltaB
        soma = 0.0;
        soma2 = 0.0;
        for (int i=0; i<[valuesX count]; i++) {
            soma = soma + powf([[valuesX objectAtIndex:i] floatValue], 2.0);
            soma2 = soma2 + powf(([[valuesX objectAtIndex:i] floatValue] - medioX), 2.0);
        }
        deltaB = sqrtf(soma / ([valuesX count] * soma2)) * deltaY;
        /*
        NSString * mensagem = [[NSString alloc] initWithFormat:@"a = %f\nb = %f\ndeltaA = %f\ndeltaB = %f\ndeltaY = %f\n", a, b, deltaA, deltaB, deltaY];
        
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Resultados" 
                              message: mensagem
                              delegate:self 
                              cancelButtonTitle:@"Ok" 
                              otherButtonTitles:nil];
        [alert show];
        */
        
        [menuTableView reloadData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Ops..." 
                              message: @"Digite um número igual de valores (X e Y)."
                              delegate:self 
                              cancelButtonTitle:@"Ok" 
                              otherButtonTitles:nil];
        [alert show];
    }
    

    
}

- (IBAction) adicionarPonto {
    // Adicionaremos valores padrão aos vetores
    [valuesX insertObject:[[NSNumber numberWithFloat:0.0] stringValue] atIndex:0];
    [valuesY insertObject:[[NSNumber numberWithFloat:0.0] stringValue] atIndex:0];
    
    [menuTableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationLeft];
    
    [self tableView:menuTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (IBAction) entrarModoEdicao {
    [menuTableView setEditing: ![menuTableView isEditing] animated:YES];
}

- (IBAction)atualizarTabela {
    [menuTableView reloadData];
}

- (IBAction) infoSobre {
	
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:NSLocalizedString(@"About", nil)
						  message: NSLocalizedString(@"Info", @"Este programa calcula os valores de a e b incluindo seus erros (deltas) pelo Método dos Mínimos Quadrados.\n\nDesenvolvedor: Pedro P. M. Góes\n\nVersão atual: 1.3\nRelease: Abril/2012\n\nAgora também disponível para Android!")
						  delegate:self 
						  cancelButtonTitle:@"Ok" 
						  otherButtonTitles:nil];
	[alert show];
	
}

- (IBAction)showGraph:(id)sender {
    [self calcular];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        MMQGraphViewController *mgvc = [[MMQGraphViewController alloc] initWithNibName:@"MMQGraphViewController" bundle:nil];
        mgvc.controller = self;
    
        [self.navigationController pushViewController:mgvc animated:YES];
    } else {
        [graphViewController reloadView];
    }
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self carregarDados];
    [self calcular];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(adicionarPonto)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(entrarModoEdicao)];
    self.navigationItem.title = NSLocalizedString(@"Data", nil);
    
    aboutButton.title = NSLocalizedString(@"About", nil);
    calculateButton.title = NSLocalizedString(@"Calculate!", nil);
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return ([valuesX count]);
    } else {
        return 5;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return NSLocalizedString(@"Points", nil);
    } else {
        return NSLocalizedString(@"Results", nil);
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
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
        celula.valorX.text = [valuesX objectAtIndex:indexPath.row];
        celula.valorY.text = [valuesY objectAtIndex:indexPath.row];  
        celula.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return celula;
    } else {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"a"];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%f", a];
                break;
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"b"];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%f", b];
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"Δa"];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%f", deltaA];
                break;
            case 3:
                cell.textLabel.text = [NSString stringWithFormat:@"Δb"];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%f", deltaB];
                break;
            case 4:
                cell.textLabel.text = [NSString stringWithFormat:@"Δy"];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%f", deltaY];
                break;
                
            default:
                break;
        }
        
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return NO;
    }
    return YES;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [valuesX removeObjectAtIndex:indexPath.row];
        [valuesY removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationRight];
    }
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return NO;
    }
    return YES;
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    if (destinationIndexPath.section != 1) {
        // Vamos substituir os valores em ambos os vetores X e Y
        id objeto = [valuesX objectAtIndex:(sourceIndexPath.row)];
        [valuesX removeObjectAtIndex:(sourceIndexPath.row)];
        [valuesX insertObject:objeto atIndex:(destinationIndexPath.row)];
        
        objeto = [valuesY objectAtIndex:(sourceIndexPath.row)];
        [valuesY removeObjectAtIndex:(sourceIndexPath.row)];
        [valuesY insertObject:objeto atIndex:(destinationIndexPath.row)];
    }
    
    [tableView reloadData];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        MMQPointDetailViewController *pdvc = [[MMQPointDetailViewController alloc] initWithNibName:@"MMQPointDetailViewController" bundle:nil];
        [self.navigationController pushViewController:pdvc animated:YES];
        
        pdvc.xTextField.text = [valuesX objectAtIndex:indexPath.row];
        pdvc.yTextField.text = [valuesY objectAtIndex:indexPath.row];
        pdvc.indexPath = indexPath;
        pdvc.controller = self;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:NSLocalizedString(@"Results", nil)
                              message: NSLocalizedString(@"ResultsInfo", @"Hit Calculate! to update the results table.")
                              delegate:self 
                              cancelButtonTitle:@"Ok" 
                              otherButtonTitles:nil];
        [alert show];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

@end
