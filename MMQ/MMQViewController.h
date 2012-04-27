//
//  MMQViewController.h
//  MMQ
//
//  Created by Pedro Góes on 16/05/11.
//  Copyright 2011 pedrogoes.info. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMQGraphViewController.h"


@interface MMQViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *tTabela;
    IBOutlet MMQGraphViewController *graphViewController;
    IBOutlet UIBarButtonItem *aboutButton;
    IBOutlet UIBarButtonItem *calculateButton;
    
    NSMutableArray *valuesX;
    NSMutableArray *valuesY;
    
    float medioX, medioY, a, deltaA, b, deltaB, deltaY;
}

@property (strong, nonatomic) NSMutableArray *valuesX;
@property (strong, nonatomic) NSMutableArray *valuesY;
@property (assign, nonatomic) float a;
@property (assign, nonatomic) float b;

- (void)salvarDados;
- (void)carregarDados;
- (IBAction)calcular;
- (IBAction)showGraph:(id)sender;
- (IBAction)adicionarPonto;
- (IBAction)entrarModoEdicao;
- (void)atualizarTabela;
- (IBAction)infoSobre;

@end
