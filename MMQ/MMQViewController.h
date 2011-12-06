//
//  MMQViewController.h
//  MMQ
//
//  Created by Pedro Góes on 16/05/11.
//  Copyright 2011 pedrogoes.info. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMQViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView * tTabela;
    NSMutableArray * valoresX;
    NSMutableArray * valoresY;
    
    float medioX, medioY, a, deltaA, b, deltaB, deltaY;
}

@property (nonatomic, retain) NSMutableArray * valoresX;
@property (nonatomic, retain) NSMutableArray * valoresY;


- (void)salvarDados;
- (void)carregarDados;
- (IBAction)calcular;
- (IBAction)adicionarPonto;
- (IBAction)entrarModoEdicao;
- (void)atualizarTabela;
- (IBAction)infoSobre;

@end
