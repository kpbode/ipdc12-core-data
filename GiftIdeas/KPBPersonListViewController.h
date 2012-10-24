//
//  KPBPersonListViewController.h
//  GiftIdeas
//
//  Created by Karl Bode on 11.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KPBPersonListViewController : UITableViewController

@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;

@end
