//
//  JRCaptureData.m
//  SimpleCaptureDemo
//
//  Created by Lilli Szafranski on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "JRCaptureInternal.h"

@interface JRCaptureObject (Internal)
//- (NSDictionary *)toUpdateDictionary;
//- (NSDictionary *)toReplaceDictionary;
//- (void)updateFromDictionary:(NSDictionary*)dictionary;
//- (void)replaceFromDictionary:(NSDictionary*)dictionary;
@end

@implementation JRCaptureObject
@synthesize captureObjectPath;
@synthesize dirtyPropertySet;
@synthesize dirtyArraySet;
@synthesize canBeUpdatedOrReplaced;

- (id)init
{
    if ((self = [super init]))
    {
        dirtyPropertySet = [[NSMutableSet alloc] init];
        dirtyArraySet    = [[NSMutableSet alloc] init];
    }
    return self;
}

- (id)copyWithZone:(NSZone*)zone
{
    JRCaptureObject *objectCopy =
                [[JRCaptureObject allocWithZone:zone] init];

    for (NSString *dirtyProperty in [self.dirtyPropertySet allObjects])
        [objectCopy.dirtyPropertySet addObject:dirtyProperty];

    objectCopy.captureObjectPath = self.captureObjectPath;

    return objectCopy;
}

- (void)updateCaptureObjectDidFailWithResult:(NSString *)result context:(NSObject *)context
{
    DLog(@"");

    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    //NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    if ([delegate respondsToSelector:@selector(updateCaptureObject:didFailWithResult:context:)])
        [delegate updateCaptureObject:captureObject didFailWithResult:result context:callerContext];
}

- (void)updateCaptureObjectDidSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    DLog(@"");

    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    NSDictionary *resultDictionary = [result objectFromJSONString];

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        [self updateCaptureObjectDidFailWithResult:result context:context];

    if (![resultDictionary objectForKey:@"result"])
        [self updateCaptureObjectDidFailWithResult:result context:context];

    [captureObject updateFromDictionary:[resultDictionary objectForKey:@"result"] withPath:capturePath];
    [captureObject.dirtyPropertySet removeAllObjects];

    if ([delegate respondsToSelector:@selector(updateCaptureObject:didSucceedWithResult:context:)])
        [delegate updateCaptureObject:captureObject didSucceedWithResult:result context:callerContext];
}

- (void)replaceCaptureObjectDidFailWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    //NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    if ([delegate respondsToSelector:@selector(replaceCaptureObject:didFailWithResult:context:)])
        [delegate replaceCaptureObject:captureObject didFailWithResult:result context:callerContext];
}

- (void)replaceCaptureObjectDidSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    NSDictionary *resultDictionary = [result objectFromJSONString];

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        [self replaceCaptureObjectDidFailWithResult:result context:context];

    if (![resultDictionary objectForKey:@"result"])
        [self replaceCaptureObjectDidFailWithResult:result context:context];

    [captureObject replaceFromDictionary:[resultDictionary objectForKey:@"result"] withPath:capturePath];
    [captureObject.dirtyPropertySet removeAllObjects];

    if ([delegate respondsToSelector:@selector(replaceCaptureObject:didSucceedWithResult:context:)])
        [delegate replaceCaptureObject:captureObject didSucceedWithResult:result context:callerContext];
}

- (void)replaceCaptureArrayDidFailWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSString        *arrayName     = [myContext objectForKey:@"arrayName"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    if ([delegate respondsToSelector:@selector(replaceArrayNamed:onCaptureObject:didFailWithResult:context:)])
        [delegate replaceArrayNamed:arrayName onCaptureObject:captureObject didFailWithResult:result context:callerContext];
}

- (void)replaceCaptureArrayDidSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    NSDictionary    *myContext     = (NSDictionary *)context;
    JRCaptureObject *captureObject = [myContext objectForKey:@"captureObject"];
    NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    NSString        *arrayName     = [myContext objectForKey:@"arrayName"];
    NSString        *elementType   = [myContext objectForKey:@"elementType"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];

    id<JRCaptureObjectDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    NSDictionary *resultDictionary = [result objectFromJSONString];

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        [self replaceCaptureObjectDidFailWithResult:result context:context];

    if (![resultDictionary objectForKey:@"result"])
        [self replaceCaptureObjectDidFailWithResult:result context:context];

    NSString *capitalizedName =
                        [arrayName stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                           withString:[[arrayName substringToIndex:1] capitalizedString]];

    SEL setNewArrayInParentSelector =
                NSSelectorFromString([NSString stringWithFormat:@"set%@:", capitalizedName]);

    NSArray *resultsArray = [resultDictionary objectForKey:@"result"];
    NSArray *newArray;
    if (elementType)/* Then it's a simple array */
    {
        SEL arrayOfObjectsFromArrayOfDictionariesSelector =
                @selector(arrayOfStringPluralElementsFromStringPluralDictionariesWithType:andPath:);

        newArray = [resultsArray performSelector:arrayOfObjectsFromArrayOfDictionariesSelector
                                      withObject:elementType
                                      withObject:capturePath];
    }
    else
    {
        SEL arrayOfObjectsFromArrayOfDictionariesSelector = NSSelectorFromString(
                [NSString stringWithFormat:@"arrayOf%@ObjectsFrom%@DictionariesWithPath:", capitalizedName, capitalizedName]);

        newArray = [resultsArray performSelector:arrayOfObjectsFromArrayOfDictionariesSelector
                                      withObject:capturePath];
    }

    [captureObject performSelector:setNewArrayInParentSelector withObject:newArray];
    [captureObject.dirtyArraySet removeObject:arrayName];

    if ([delegate respondsToSelector:@selector(replaceArray:named:onCaptureObject:didSucceedWithResult:context:)])
        [delegate replaceArray:newArray named:arrayName onCaptureObject:captureObject didSucceedWithResult:result context:callerContext];
}

- (NSDictionary *)toDictionary
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];

    return nil; // TODO: What's the better way to raise the exception in a method w a return?
}

- (NSDictionary *)toUpdateDictionary
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];

    return nil; // TODO: What's the better way to raise the exception in a method w a return?
}

- (NSDictionary *)toReplaceDictionary
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];

    return nil; // TODO: What's the better way to raise the exception in a method w a return?
}

- (NSDictionary*)objectProperties
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];

    return nil; // TODO: What's the better way to raise the exception in a method w a return?
}

- (void)updateFromDictionary:(NSDictionary *)dictionary withPath:(NSString *)capturePath
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (void)replaceFromDictionary:(NSDictionary *)dictionary withPath:(NSString *)capturePath
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

//- (void)updateObjectOnCaptureForDelegate:(id <JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
//{
//    [NSException raise:NSInternalInconsistencyException
//                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
//}
//
//- (void)replaceObjectOnCaptureForDelegate:(id <JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
//{
//    [NSException raise:NSInternalInconsistencyException
//                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
//}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     self.captureObjectPath, @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    if (!self.canBeUpdatedOrReplaced)
    {
        [self updateCaptureObjectDidFailWithResult:
                      @"{\"stat\":\"fail\",\"message\":\"This object or its parent is an element of an array, and the array needs to be replaced on Capture first\""
                                           context:newContext];

        return;
    }

    if ([dirtyArraySet count])
    {
        [self updateCaptureObjectDidFailWithResult:
                      [NSString stringWithFormat:@"{\"stat\":\"fail\",\"message\":\"The following arrays needs to be replaced on Capture first:%@",
                                [[dirtyArraySet allObjects] description]]
                                           context:newContext];

        return;
    }

    [JRCaptureInterface updateCaptureObject:[self toUpdateDictionary]
                                     //withId:[self.captureUserId integerValue]
                                     atPath:self.captureObjectPath
                                  withToken:[JRCaptureData accessToken]
                                forDelegate:self
                                withContext:newContext];
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     self.captureObjectPath, @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    if (!self.canBeUpdatedOrReplaced)
    {
        [self updateCaptureObjectDidFailWithResult:
                      @"{\"stat\":\"fail\",\"message\":\"This object or its parent is an element of an array, and the array needs to be replaced on Capture first\""
                                           context:newContext];

        return;
    }

    [JRCaptureInterface replaceCaptureObject:[self toReplaceDictionary]
                                      //withId:[self.captureUserId integerValue]
                                      atPath:self.captureObjectPath
                                   withToken:[JRCaptureData accessToken]
                                 forDelegate:self
                                 withContext:newContext];
}

- (void)replaceArrayOnCapture:(NSArray *)array named:(NSString *)arrayName
                  forDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSString *captureArrayPath = [NSString stringWithFormat:@"%@/%@", self.captureObjectPath, arrayName];
    NSString *capitalizedName  =
                    [arrayName stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                       withString:[[arrayName substringToIndex:1] capitalizedString]];

    SEL arrayOfObjectsToArrayOfDictionariesSelector = NSSelectorFromString(
            [NSString stringWithFormat:@"arrayOf%@ReplaceDictionariesFrom%@Objects", capitalizedName, capitalizedName]);

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     arrayName, @"arrayName",
                                                     self.captureObjectPath, @"capturePath",
                                                     [NSNumber numberWithBool:NO], @"isSimpleArray",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface replaceCaptureArray:[array performSelector:arrayOfObjectsToArrayOfDictionariesSelector]
                                     atPath:captureArrayPath
                                  withToken:[JRCaptureData accessToken]
                                forDelegate:self
                                withContext:newContext];
}

- (void)replaceSimpleArrayOnCapture:(NSArray *)array ofType:(NSString *)elementType named:(NSString *)arrayName
                        forDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSString *captureArrayPath = [NSString stringWithFormat:@"%@/%@", self.captureObjectPath, arrayName];

    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     arrayName, @"arrayName",
                                                     elementType, @"elementType",
                                                     self.captureObjectPath, @"capturePath",
                                                     [NSNumber numberWithBool:YES], @"isSimpleArray",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface replaceCaptureArray:[array arrayOfStringPluralReplaceDictionariesFromStringPluralElements]
                                     atPath:captureArrayPath
                                  withToken:[JRCaptureData accessToken]
                                forDelegate:self
                                withContext:newContext];
}

- (void)dealloc
{
    [captureObjectPath release];
    [dirtyPropertySet release];
    [dirtyArraySet release];

    [super dealloc];
}
@end

@implementation JRStringPluralElement
{
    NSNumber   *_elementId;
    NSString   *_value;
}
@synthesize type = _type;
@dynamic    elementId;
@dynamic    value;

- (NSNumber *)elementId
{
    return _elementId;
}

- (void)setElementId:(NSNumber *)newElementId
{
    [self.dirtyPropertySet addObject:@"elementId"];
    _elementId = [newElementId copy];
}

- (NSString *)value
{
    return _value;
}

- (void)setValue:(NSString *)newValue
{
    [self.dirtyPropertySet addObject:@"value"];
    _value = [newValue copy];
}

- (id)initWithType:(NSString *)elementType
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/";
        _type = elementType;
    }
    return self;
}

+ (id)stringElementWithType:(NSString *)elementType
{
    return [[[JRStringPluralElement alloc] initWithType:elementType] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRStringPluralElement *stringElementCopy =
                [[JRStringPluralElement allocWithZone:zone] initWithType:self.type];

    stringElementCopy.captureObjectPath = self.captureObjectPath;

    stringElementCopy.elementId = self.elementId;
    stringElementCopy.value     = self.value;

    [stringElementCopy.dirtyPropertySet removeAllObjects];
    [stringElementCopy.dirtyPropertySet setSet:self.dirtyPropertySet];

    return stringElementCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.elementId ? [NSNumber numberWithInteger:[self.elementId integerValue]] : [NSNull null])
             forKey:@"id"];

    if (self.value && self.value != [NSNull null])
        [dict setObject:self.value forKey:self.type];
    else
        [dict setObject:[NSNull null] forKey:self.type];

    return dict;
}

+ (id)stringElementFromDictionary:(NSDictionary*)dictionary withType:(NSString *)elementType andPath:(NSString *)capturePath
{
    JRStringPluralElement *stringElement =
        [JRStringPluralElement stringElementWithType:elementType];

    stringElement.captureObjectPath = [NSString stringWithFormat:@"%@#%d", capturePath, [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    stringElement.elementId =
        [dictionary objectForKey:@"id"] != [NSNull null] ?
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    stringElement.value =
            [dictionary objectForKey:elementType] != [NSNull null] ?
            [dictionary objectForKey:elementType] : nil;

    [stringElement.dirtyPropertySet removeAllObjects];

    return stringElement;
}

+ (id)stringElementFromString:(NSString*)valueString withType:(NSString *)elementType
{
    JRStringPluralElement *stringElement =
        [JRStringPluralElement stringElementWithType:elementType];

    stringElement.value = valueString;

    [stringElement.dirtyPropertySet removeAllObjects];

    return stringElement;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    self.captureObjectPath = [NSString stringWithFormat:@"%@#%d", capturePath, [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    if ([dictionary objectForKey:@"id"])
        self.elementId =
            [dictionary objectForKey:@"id"] != [NSNull null] ?
            [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    if ([dictionary objectForKey:_type])
        self.value =
            [dictionary objectForKey:_type] != [NSNull null] ?
            [dictionary objectForKey:_type] : nil;
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    self.captureObjectPath = [NSString stringWithFormat:@"%@#%d", capturePath, [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.elementId =
        [dictionary objectForKey:@"id"] != [NSNull null] ?
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    self.value =
        [dictionary objectForKey:_type] != [NSNull null] ?
        [dictionary objectForKey:_type] : nil;
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

//    if ([self.dirtyPropertySet containsObject:@"elementId"])
//        [dict setObject:[NSNumber numberWithInt:self.elementId] forKey:@"id"];

    if ([self.dirtyPropertySet containsObject:@"value"])
        [dict setObject:(self.value ? self.value : [NSNull null]) forKey:self.type];

    return dict;
}

- (void)updateObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     self.captureObjectPath, @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface updateCaptureObject:[self toUpdateDictionary]
//                                     withId:[self.elementId integerValue]
                                     atPath:self.captureObjectPath
                                  withToken:[JRCaptureData accessToken]
                                forDelegate:self
                                withContext:newContext];
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

//    [dict setObject:[NSNumber numberWithInt:self.elementId] forKey:@"id"];
    [dict setObject:(self.value ? self.value : [NSNull null]) forKey:self.type];

    return dict;
}

- (void)replaceObjectOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     self, @"captureObject",
                                                     self.captureObjectPath, @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureInterface replaceCaptureObject:[self toReplaceDictionary]
//                                      withId:[self.elementId integerValue]
                                      atPath:self.captureObjectPath
                                   withToken:[JRCaptureData accessToken]
                                 forDelegate:self
                                 withContext:newContext];
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"JRObjectId" forKey:@"elementId"];
    [dict setObject:@"NSString" forKey:@"type"];
    [dict setObject:@"NSString" forKey:@"value"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_value release];
    [_type release];
    [_elementId release];

    [super dealloc];
}
@end

@implementation NSArray (JRStringPluralElement)
- (NSArray*)arrayOfStringPluralDictionariesFromStringPluralElements
{
    DLog(@"");
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRStringPluralElement class]])
            [filteredDictionaryArray addObject:[(JRStringPluralElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray *)arrayOfStringPluralUpdateDictionariesFromStringPluralElements
{
    DLog(@"");
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRStringPluralElement class]])
            [filteredDictionaryArray addObject:[(JRStringPluralElement*)object toUpdateDictionary]];

    return filteredDictionaryArray;
}

- (NSArray *)arrayOfStringPluralReplaceDictionariesFromStringPluralElements
{
    DLog(@"");
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRStringPluralElement class]])
            [filteredDictionaryArray addObject:[(JRStringPluralElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfStringPluralElementsFromStringPluralDictionariesWithType:(NSString *)elementType andPath:(NSString *)capturePath
{
    DLog(@"");
    NSMutableArray *filteredPluralArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPluralArray addObject:[JRStringPluralElement stringElementFromDictionary:(NSDictionary*)dictionary
                                                                                     withType:elementType
                                                                                      andPath:capturePath]];

    return filteredPluralArray;
}

//- (NSArray*)arrayOfStringPluralElementsFromArrayOfStringsWithType:(NSString *)elementType
//{
//    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
//    for (NSString *valueString in self)
//        if ([valueString isKindOfClass:[NSString class]])
//            [filteredDictionaryArray addObject:[JRStringPluralElement stringElementFromString:valueString
//                                                                                     withType:elementType]];
//
//    return filteredDictionaryArray;
//}

- (NSArray*)copyArrayOfStringPluralElementsWithType:(NSString *)elementType
{
    DLog(@"");
    NSMutableArray *filteredArrayCopy = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[NSString class]])
            [filteredArrayCopy addObject:[JRStringPluralElement stringElementFromString:(NSString *)object
                                                                               withType:elementType]];
        else if ([object isKindOfClass:[JRStringPluralElement class]]) // TODO: Copy or not???
            [filteredArrayCopy addObject:[[(JRStringPluralElement *)object copy] autorelease]];

    return [filteredArrayCopy retain];
}
@end

@interface JRCaptureData ()
@property (nonatomic, copy) NSString *captureApidDomain;
@property (nonatomic, copy) NSString *captureUIDomain;
@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, copy) NSString *entityTypeName;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *creationToken;
@end

@implementation JRCaptureData
static JRCaptureData *singleton = nil;

@synthesize clientId;
@synthesize entityTypeName;
@synthesize captureApidDomain;
@synthesize captureUIDomain;
@synthesize accessToken;
@synthesize creationToken;

- (JRCaptureData *)init
{
    if ((self = [super init])) { }

    return self;
}

+ (id)captureDataInstance
{
    if (singleton == nil) {
        singleton = [((JRCaptureData*)[super allocWithZone:NULL]) init];
    }

    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self captureDataInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release { }

- (id)autorelease
{
    return self;
}

+ (NSString *)captureMobileEndpointUrl
{
    JRCaptureData *captureDataInstance = [JRCaptureData captureDataInstance];
    return [NSString stringWithFormat:@"%@/oauth/mobile_signin?client_id=%@&redirect_uri=https://example.com",
                     captureDataInstance.captureUIDomain, captureDataInstance.clientId];
}

+ (void)setCaptureApiDomain:(NSString *)newCaptureApidDomain captureUIDomain:(NSString *)newCaptureUIDomain
                   clientId:(NSString *)newClientId andEntityTypeName:(NSString *)newEntityTypeName
{
    JRCaptureData *captureDataInstance    = [JRCaptureData captureDataInstance];
    captureDataInstance.captureApidDomain = newCaptureApidDomain;
    captureDataInstance.captureUIDomain   = newCaptureUIDomain;
    captureDataInstance.clientId          = newClientId;
    captureDataInstance.entityTypeName    = newEntityTypeName;
}

+ (void)setAccessToken:(NSString *)newAccessToken
{
    JRCaptureData *captureDataInstance = [JRCaptureData captureDataInstance];
    captureDataInstance.accessToken    = newAccessToken;
}

+ (void)setCreationToken:(NSString *)newCreationToken
{
    JRCaptureData *captureDataInstance = [JRCaptureData captureDataInstance];
    captureDataInstance.creationToken  = newCreationToken;
}

+ (NSString *)accessToken
{
    return [[JRCaptureData captureDataInstance] accessToken];
}

+ (NSString *)creationToken
{
    return [[JRCaptureData captureDataInstance] creationToken];
}

+ (NSString *)captureApidDomain
{
    return [[JRCaptureData captureDataInstance] captureApidDomain];
}

+ (NSString *)captureUIDomain
{
    return [[JRCaptureData captureDataInstance] captureUIDomain];
}

+ (NSString *)clientId
{
    return [[JRCaptureData captureDataInstance] clientId];
}

+ (NSString *)entityTypeName
{
    return [[JRCaptureData captureDataInstance] entityTypeName];
}

- (void)dealloc
{
    [clientId release];
    [entityTypeName release];
    [captureApidDomain release];
    [captureUIDomain release];
    [accessToken release];
    [creationToken release];
    [super dealloc];
}
@end