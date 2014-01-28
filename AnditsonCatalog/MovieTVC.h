//
//  MovieTVC.h
//  AnditsonCatalog
//
//  Created by Gregory Hart on 1/25/14.
//  Copyright (c) 2014 Gregory Hart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface MovieTVC : CoreDataTableViewController

@property (nonatomic,strong) UIManagedDocument *movieDatabase;

@end
