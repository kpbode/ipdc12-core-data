//
//  KPBAuctionListViewController.h
//  GiftIdeas
//
//  Created by Karl Bode on 11.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPBPerson.h"

@interface KPBAuctionListViewController : UITableViewController

@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readwrite) KPBPerson *person;

@end
