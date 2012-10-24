//
//  KPBMigrateQueryToSearchKeywordsPolicy.m
//  GiftIdeas
//
//  Created by Karl Bode on 11.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBMigrateQueryToSearchKeywordsPolicy.h"
#import "KPBPerson.h"
#import "KPBSearchKeyword.h"

@implementation KPBMigrateQueryToSearchKeywordsPolicy

- (BOOL)beginEntityMapping:(NSEntityMapping *)mapping manager:(NSMigrationManager *)manager error:(NSError *__autoreleasing *)error
{
    NSLog(@"beginEntityMapping");
    return YES;
}

- (BOOL)createDestinationInstancesForSourceInstance:(NSManagedObject *)sInstance entityMapping:(NSEntityMapping *)mapping manager:(NSMigrationManager *)manager error:(NSError *__autoreleasing *)error
{
    NSLog(@"createDestinationInstancesForSourceInstance");
  
    KPBPerson *sourcePerson = (KPBPerson *) sInstance;
    
    // create the new instance
    NSEntityDescription *personEntity = [NSEntityDescription entityForName:@"Person"
                                                    inManagedObjectContext:manager.destinationContext];
    
    // copy properties to new instance
    KPBPerson *destinationPerson = [[KPBPerson alloc] initWithEntity:personEntity
                                      insertIntoManagedObjectContext:manager.destinationContext];
    
    destinationPerson.name = sourcePerson.name;
    destinationPerson.query = sourcePerson.query;
    
    // tell the manager that this is the new instance
    [manager associateSourceInstance:sourcePerson withDestinationInstance:destinationPerson forEntityMapping:mapping];
    
    return YES;
}

- (BOOL)endInstanceCreationForEntityMapping:(NSEntityMapping *)mapping manager:(NSMigrationManager *)manager error:(NSError *__autoreleasing *)error
{
    NSLog(@"endInstanceCreationForEntityMapping");
    
    return YES;
}

- (BOOL)createRelationshipsForDestinationInstance:(NSManagedObject *)dInstance entityMapping:(NSEntityMapping *)mapping manager:(NSMigrationManager *)manager error:(NSError *__autoreleasing *)error
{
    NSLog(@"createRelationshipsForDestinationInstance");
    
    KPBPerson *person = (KPBPerson *) dInstance;
    
    // split the name into keywords
    NSArray *keywordStrings = [person.query componentsSeparatedByString:@" "];
    
    for (NSString *keywordString in keywordStrings) {
        
        // create a new keyword entity in the destination context
        KPBSearchKeyword *keyword = [NSEntityDescription insertNewObjectForEntityForName:@"SearchKeyword"
                                                                  inManagedObjectContext:manager.destinationContext];
        keyword.term = keywordString;
        // set the relation
        keyword.person = person;
    }
    
    return YES;
}

- (BOOL)endRelationshipCreationForEntityMapping:(NSEntityMapping *)mapping manager:(NSMigrationManager *)manager error:(NSError *__autoreleasing *)error
{
    NSLog(@"endRelationshipCreationForEntityMapping");
    return YES;
}

- (BOOL)performCustomValidationForEntityMapping:(NSEntityMapping *)mapping manager:(NSMigrationManager *)manager error:(NSError *__autoreleasing *)error
{
    return YES;
}

- (BOOL)endEntityMapping:(NSEntityMapping *)mapping manager:(NSMigrationManager *)manager error:(NSError *__autoreleasing *)error
{
    NSLog(@"end EntityMapping");
    return YES;
}

@end
