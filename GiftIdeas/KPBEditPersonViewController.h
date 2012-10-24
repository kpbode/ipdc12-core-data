//
//  KPBEditPersonViewController.h
//  GiftIdeas
//
//  Created by Karl Bode on 11.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPBPerson.h"

@class KPBEditPersonViewController;

@protocol KPBEditPersonViewControllerDelegate <NSObject>

- (void)editPersonViewControllerDidCancel:(KPBEditPersonViewController *)editPersonViewController;
- (void)editPersonViewControllerDidSave:(KPBEditPersonViewController *)editPersonViewController;

@end

@interface KPBEditPersonViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *queryTextField;
@property (nonatomic, weak, readwrite) id<KPBEditPersonViewControllerDelegate> delegate;
@property (strong, nonatomic) KPBPerson *person;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)onCancel:(id)sender;
- (IBAction)onSave:(id)sender;

@end
