//
//  KPBImageTransformer.m
//  GiftIdeas
//
//  Created by Karl Bode on 11.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBImageTransformer.h"

@implementation KPBImageTransformer

+ (Class)transformedValueClass
{
    return [UIImage class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return UIImageJPEGRepresentation(value, 1.f);
}

- (id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithData:value];
}

@end
