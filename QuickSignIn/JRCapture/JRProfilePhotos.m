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


#import "JRProfilePhotos.h"

@implementation JRProfilePhotos
@synthesize profilePhotosId;
@synthesize primary;
@synthesize type;
@synthesize value;

- (id)init
{
    if ((self = [super init]))
    {
    }
    return self;
}

+ (id)profilePhotos
{
    return [[[JRProfilePhotos alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRProfilePhotos *profilePhotosCopy =
                [[JRProfilePhotos allocWithZone:zone] init];

    profilePhotosCopy.profilePhotosId = self.profilePhotosId;
    profilePhotosCopy.primary = self.primary;
    profilePhotosCopy.type = self.type;
    profilePhotosCopy.value = self.value;

    return profilePhotosCopy;
}

+ (id)profilePhotosObjectFromDictionary:(NSDictionary*)dictionary
{
    JRProfilePhotos *profilePhotos =
        [JRProfilePhotos profilePhotos];

    profilePhotos.profilePhotosId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    profilePhotos.primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];
    profilePhotos.type = [dictionary objectForKey:@"type"];
    profilePhotos.value = [dictionary objectForKey:@"value"];

    return profilePhotos;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (profilePhotosId)
        [dict setObject:[NSNumber numberWithInt:profilePhotosId] forKey:@"id"];

    if (primary)
        [dict setObject:[NSNumber numberWithBool:primary] forKey:@"primary"];

    if (type)
        [dict setObject:type forKey:@"type"];

    if (value)
        [dict setObject:value forKey:@"value"];

    return dict;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"profilePhotosId"])
        self.profilePhotosId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    if ([dictionary objectForKey:@"primary"])
        self.primary = [(NSNumber*)[dictionary objectForKey:@"primary"] boolValue];

    if ([dictionary objectForKey:@"type"])
        self.type = [dictionary objectForKey:@"type"];

    if ([dictionary objectForKey:@"value"])
        self.value = [dictionary objectForKey:@"value"];
}

- (void)dealloc
{
    [type release];
    [value release];

    [super dealloc];
}
@end