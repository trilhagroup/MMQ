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

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UINavigationController *navigationController;
@property (strong, nonatomic) IBOutlet UISplitViewController *splitViewController;
@property (strong, nonatomic) IBOutlet MMQViewController *viewController;

@end
