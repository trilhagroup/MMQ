//
//  MMQPointDetailViewController.h
//  MMQ
//
//  Created by Pedro Góes on 05/12/11.
//  Copyright (c) 2011 pedrogoes.info. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMQViewController;

@interface MMQPointDetailViewController : UIViewController <UITextFieldDelegate> {
    IBOutlet UILabel *instructionLabel;
    IBOutlet UITextField *xTextField;
    IBOutlet UITextField *yTextField;
    IBOutlet UIButton *invertButton;
    NSIndexPath *indexPath;
    MMQViewController *controller;
    
    id firstResponder;
}

@property (strong, nonatomic) UITextField *xTextField;
@property (strong, nonatomic) UITextField *yTextField;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong) MMQViewController *controller;

@property (strong) id firstResponder;

- (IBAction)inverterValores;
- (void)negativarValor;
- (IBAction)backgroundTap;
- (void)salvarCampos;

@end
