//
//  KPBEditPersonViewController.m
//  GiftIdeas
//
//  Created by Karl Bode on 11.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBEditPersonViewController.h"

@interface KPBEditPersonViewController ()

@end

@implementation KPBEditPersonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.nameTextField.text = self.person.name;
    self.queryTextField.text = self.person.query;
    
    [self.nameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(id)sender {
    [self.delegate editPersonViewControllerDidCancel:self];
}

- (IBAction)onSave:(id)sender {
    
    self.person.name = self.nameTextField.text;
    self.person.query = self.queryTextField.text;
    
    [self.delegate editPersonViewControllerDidSave:self];
}
@end
