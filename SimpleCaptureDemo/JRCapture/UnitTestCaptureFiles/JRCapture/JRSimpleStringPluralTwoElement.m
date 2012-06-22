/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation and/or
   other materials provided with the distribution.
 * Neither the name of the Janrain, Inc. nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


#import "JRSimpleStringPluralTwoElement.h"

@interface JRSimpleStringPluralTwoElement ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRSimpleStringPluralTwoElement
{
    NSString *_simpleTypeTwo;
}
@dynamic simpleTypeTwo;
@synthesize canBeUpdatedOrReplaced;

- (NSString *)simpleTypeTwo
{
    return _simpleTypeTwo;
}

- (void)setSimpleTypeTwo:(NSString *)newSimpleTypeTwo
{
    [self.dirtyPropertySet addObject:@"simpleTypeTwo"];

    [_simpleTypeTwo autorelease];
    _simpleTypeTwo = [newSimpleTypeTwo copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOrReplaced = NO;


        [self.dirtyPropertySet setSet:[NSMutableSet setWithObjects:@"simpleTypeTwo", nil]];
    }
    return self;
}

+ (id)simpleStringPluralTwoElement
{
    return [[[JRSimpleStringPluralTwoElement alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRSimpleStringPluralTwoElement *simpleStringPluralTwoElementCopy = (JRSimpleStringPluralTwoElement *)[super copyWithZone:zone];

    simpleStringPluralTwoElementCopy.simpleTypeTwo = self.simpleTypeTwo;

    return simpleStringPluralTwoElementCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.simpleTypeTwo ? self.simpleTypeTwo : [NSNull null])
             forKey:@"simpleTypeTwo"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)simpleStringPluralTwoElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JRSimpleStringPluralTwoElement *simpleStringPluralTwoElement = [JRSimpleStringPluralTwoElement simpleStringPluralTwoElement];

    simpleStringPluralTwoElement.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"simpleStringPluralTwo", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
// TODO: Is this safe to assume?
    simpleStringPluralTwoElement.canBeUpdatedOrReplaced = YES;

    simpleStringPluralTwoElement.simpleTypeTwo =
        [dictionary objectForKey:@"simpleTypeTwo"] != [NSNull null] ? 
        [dictionary objectForKey:@"simpleTypeTwo"] : nil;

    [simpleStringPluralTwoElement.dirtyPropertySet removeAllObjects];
    [simpleStringPluralTwoElement.dirtyArraySet removeAllObjects];
    
    return simpleStringPluralTwoElement;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"simpleStringPluralTwo", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    if ([dictionary objectForKey:@"simpleTypeTwo"])
        self.simpleTypeTwo = [dictionary objectForKey:@"simpleTypeTwo"] != [NSNull null] ? 
            [dictionary objectForKey:@"simpleTypeTwo"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"simpleStringPluralTwo", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.simpleTypeTwo =
        [dictionary objectForKey:@"simpleTypeTwo"] != [NSNull null] ? 
        [dictionary objectForKey:@"simpleTypeTwo"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"simpleTypeTwo"])
        [dict setObject:(self.simpleTypeTwo ? self.simpleTypeTwo : [NSNull null]) forKey:@"simpleTypeTwo"];

    return dict;
}

- (NSDictionary *)toReplaceDictionaryIncludingArrays:(BOOL)includingArrays
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.simpleTypeTwo ? self.simpleTypeTwo : [NSNull null]) forKey:@"simpleTypeTwo"];

    return dict;
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToSimpleStringPluralTwoElement:(JRSimpleStringPluralTwoElement *)otherSimpleStringPluralTwoElement
{
    if (!self.simpleTypeTwo && !otherSimpleStringPluralTwoElement.simpleTypeTwo) /* Keep going... */;
    else if ((self.simpleTypeTwo == nil) ^ (otherSimpleStringPluralTwoElement.simpleTypeTwo == nil)) return NO; // xor
    else if (![self.simpleTypeTwo isEqualToString:otherSimpleStringPluralTwoElement.simpleTypeTwo]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"NSString" forKey:@"simpleTypeTwo"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_simpleTypeTwo release];

    [super dealloc];
}
@end