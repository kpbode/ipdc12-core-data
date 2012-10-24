//
//  KPBPersonListViewController.m
//  GiftIdeas
//
//  Created by Karl Bode on 11.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBPersonListViewController.h"
#import "KPBEditPersonViewController.h"
#import "KPBAuctionListViewController.h"

@interface KPBPersonListViewController () <KPBEditPersonViewControllerDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readwrite) NSFetchedResultsController *fetchedResultsController;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation KPBPersonListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSError *fetchError = nil;
    if (![self.fetchedResultsController performFetch:&fetchError]) {
        NSLog(@"failed to fetch persons");
    } else {
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([@"OnAddPerson" isEqualToString:segue.identifier]) {
        KPBEditPersonViewController *editPersonViewController = (KPBEditPersonViewController *) segue.destinationViewController;
        editPersonViewController.delegate = self;
        
        // create a new managedObjectContext which is a child of the current
        NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc]
                                                        initWithConcurrencyType:NSMainQueueConcurrencyType];
        managedObjectContext.parentContext = self.managedObjectContext;
        
        NSEntityDescription *personEntity = [NSEntityDescription entityForName:@"Person"
                                                        inManagedObjectContext:managedObjectContext];
        KPBPerson *person = [[KPBPerson alloc] initWithEntity:personEntity
                               insertIntoManagedObjectContext:managedObjectContext];
        
        person.name = @"Default Name";
        
        NSManagedObjectContext *moc = self.managedObjectContext;
        
        [moc performBlockAndWait:^{
            
        }];
        
        editPersonViewController.person = person;
        editPersonViewController.managedObjectContext = managedObjectContext;
        
    } else if ([@"OnEditPerson" isEqualToString:segue.identifier]) {
        KPBEditPersonViewController *editPersonViewController = (KPBEditPersonViewController *) segue.destinationViewController;
        editPersonViewController.delegate = self;
        
        UITableViewCell *cell = (UITableViewCell *) sender;
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:cell];
        
        KPBPerson *person = [self.fetchedResultsController objectAtIndexPath:selectedIndexPath];
        
        editPersonViewController.person = person;
        editPersonViewController.managedObjectContext = self.managedObjectContext;
        
    } else if ([@"OnViewAuctions" isEqualToString:segue.identifier]) {
        
        KPBAuctionListViewController *auctionListViewController = (KPBAuctionListViewController *) segue.destinationViewController;
        
        UITableViewCell *cell = (UITableViewCell *) sender;
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:cell];
        
        KPBPerson *person = [self.fetchedResultsController objectAtIndexPath:selectedIndexPath];
        
        auctionListViewController.person = person;
        auctionListViewController.managedObjectContext = self.managedObjectContext;
    }
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PersonCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    KPBPerson *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = person.name;
    cell.detailTextLabel.text = person.query;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        KPBPerson *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:person];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark KPBEditPersonViewController

- (void)editPersonViewControllerDidCancel:(KPBEditPersonViewController *)editPersonViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editPersonViewControllerDidSave:(KPBEditPersonViewController *)editPersonViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        //return;
        
        NSManagedObjectContext *managedObjectContext = editPersonViewController.managedObjectContext;
        NSError *saveError = nil;
        if (![managedObjectContext save:&saveError]) {
            NSLog(@"failed to save person: %@", saveError);
        }
        
    }];
}

#pragma mark Lazy Properties

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) return _fetchedResultsController;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:self.managedObjectContext
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:nil];
    
    fetchedResultsController.delegate = self;
    self.fetchedResultsController = fetchedResultsController;
    
    return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        default:
            break;
    }
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
