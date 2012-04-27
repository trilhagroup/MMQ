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
    IBOutlet UITextField *tX;
    IBOutlet UITextField *tY;
    NSIndexPath *indexPath;
    MMQViewController *controller;
    
    id firstResponder;
}

@property (strong, nonatomic) UITextField *tX;
@property (strong, nonatomic) UITextField *tY;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong) MMQViewController *controller;

@property (strong) id firstResponder;

- (IBAction)inverterValores;
- (void)negativarValor;
- (IBAction)backgroundTap;
- (void)salvarCampos;

@end
