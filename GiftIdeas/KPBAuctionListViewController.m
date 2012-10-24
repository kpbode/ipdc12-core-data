//
//  KPBAuctionListViewController.m
//  GiftIdeas
//
//  Created by Karl Bode on 11.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBAuctionListViewController.h"
#import "KPBAuction.h"

@interface KPBAuctionListViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readwrite) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong, readwrite) NSOperationQueue *operationQueue;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (void)onRefreshAuctions:(id)sender;

@end

@implementation KPBAuctionListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.refreshControl addTarget:self action:@selector(onRefreshAuctions:) forControlEvents:UIControlEventValueChanged];

    NSError *fetchError = nil;
    if ([self.fetchedResultsController performFetch:&fetchError]) {
        [self.tableView reloadData];
    } else {
        NSLog(@"failed to fetch auctios: %@", fetchError);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
    static NSString *CellIdentifier = @"AuctionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    KPBAuction *auction = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = auction.title;
    cell.detailTextLabel.text = auction.subtitle;
    cell.imageView.image = auction.image;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark Lazy Properties

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) return _fetchedResultsController;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Auction"];
    fetchRequest.predicate = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"person"]
                                                                rightExpression:[NSExpression expressionForConstantValue:self.person]
                                                                       modifier:NSDirectPredicateModifier
                                                                           type:NSEqualToPredicateOperatorType
                                                                        options:0];
    
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
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

- (void)onRefreshAuctions:(id)sender
{
    [self.refreshControl beginRefreshing];
    
    NSString *query = [self.person.query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *eBayAppName = @"PUT YOUR EBAY API KEY HERE";
    
    NSString *urlString = [NSString stringWithFormat:@"http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=%@&GLOBAL-ID=EBAY-DE&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&keywords=%@&paginationInput.entriesPerPage=50", eBayAppName, query];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpUrlResponse = (NSHTTPURLResponse *) response;
            
            NSLog(@"statusCode: %i", httpUrlResponse.statusCode);
            
        }
        
        NSError *jsonError = nil;
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (object == nil) {
            NSLog(@"failed to read json response: %@", jsonError);
        } else {
            
            
            
            NSDictionary *jsonObject = (NSDictionary *) object;
            
            // oh, oh
            NSArray *itemDictionaries = jsonObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"item"];
            
            if ([itemDictionaries count] == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Results"
                                                                        message:@"Sorry, there are no auctions matching your ideas"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    
                    [alertView show];
                });
            }
            
            NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
            managedObjectContext.parentContext = self.managedObjectContext;
            KPBPerson *person = (KPBPerson *) [managedObjectContext objectWithID:self.person.objectID];

            
            for (NSDictionary *itemDictionary in itemDictionaries) {
                
                NSString *title = itemDictionary[@"title"][0];
                NSString *subtitle = itemDictionary[@"subtitle"][0];
                NSString *imageUrl = itemDictionary[@"galleryURL"][0];
                NSString *itemUrl = itemDictionary[@"viewItemURL"][0];
                NSString *itemId = itemDictionary[@"itemId"][0];
                
                NSURLRequest *getImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
                NSURLResponse *getImageResponse = nil;
                NSError *getImageError = nil;
                
                NSData *imageData = [NSURLConnection sendSynchronousRequest:getImageRequest returningResponse:&getImageResponse error:&getImageError];
                
                KPBAuction *auction = [NSEntityDescription insertNewObjectForEntityForName:@"Auction"   inManagedObjectContext:managedObjectContext];
                auction.title = title;
                auction.subtitle = subtitle;
                auction.image = [UIImage imageWithData:imageData];
                auction.url = itemUrl;
                auction.person = person;
                auction.serverId = itemId;
                
            }
            
            NSError *saveError = nil;
            if (![managedObjectContext save:&saveError]) {
                NSLog(@"failed to save after insert: %@", saveError);
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
        });
        
    }];
}

@end
