//
//  Auction.h
//  GiftIdeas
//
//  Created by Karl Bode on 11.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface KPBAuction : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSManagedObject *person;
@property (nonatomic, retain) NSString * serverId;

@end
