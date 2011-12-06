//
//  MMQPointCell.h
//  MMQ
//
//  Created by Pedro Góes on 05/12/11.
//  Copyright (c) 2011 pedrogoes.info. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMQPointCell : UITableViewCell {
    IBOutlet UILabel *valorX;
    IBOutlet UILabel *valorY;
}

@property (nonatomic, retain) UILabel *valorX;
@property (nonatomic, retain) UILabel *valorY;

@end
