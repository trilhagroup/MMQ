//
//  MMQViewController.h
//  MMQ
//
//  Created by Pedro Góes on 16/05/11.
//  Copyright 2011 pedrogoes.info. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMQViewController : UIViewController <UITextFieldDelegate> {
    UIButton * bCalcular;
    UITextField * tX;
    UITextField * tY;
    UITextView * tResultados;
    NSArray * valoresX;
    NSArray * valoresY;
    
    float medioX;
    float medioY;
    float a;
    float deltaA;
    float b;
    float deltaB;
    float deltaY;
}

@property (nonatomic, retain) IBOutlet UIButton * bCalcular;
@property (nonatomic, retain) IBOutlet UITextField * tX;
@property (nonatomic, retain) IBOutlet UITextField * tY;
@property (nonatomic, retain) IBOutlet UITextView * tResultados;
@property (nonatomic, retain) NSArray * valoresX;
@property (nonatomic, retain) NSArray * valoresY;

@property (nonatomic, assign) float medioX;
@property (nonatomic, assign) float medioY;
@property (nonatomic, assign) float a;
@property (nonatomic, assign) float deltaA;
@property (nonatomic, assign) float b;
@property (nonatomic, assign) float deltaB;
@property (nonatomic, assign) float deltaY;

- (IBAction) calcular;
- (IBAction) backgroundTap: (id) sender;
- (IBAction) infoSobre;

@end
