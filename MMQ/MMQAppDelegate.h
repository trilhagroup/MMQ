//
//  MMQAppDelegate.h
//  MMQ
//
//  Created by Pedro Góes on 16/05/11.
//  Copyright 2011 pedrogoes.info. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMQViewController;

@interface MMQAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MMQViewController *viewController;

@end
