//
//  AGAudioBuffer.m
//  Agora-client-side-AV-capturing-for-streaming-iOS
//
//  Created by GongYuhua on 2017/4/7.
//  Copyright © 2017年 Agora. All rights reserved.
//

#import "AGAudioBuffer.h"

@implementation AGAudioBuffer
- (instancetype)initWithBuffer:(void *)buffer
                        length:(int)length
{
    if (self = [super init]) {
        self.buffer = [AGAudioBuffer copy:buffer length:length];
        self.length = length;
    }
    return self;
}

+ (unsigned char *)copy:(void *)buffer length:(int)length
{
    unsigned char *copyingBuffer = malloc(length);
    memcpy(copyingBuffer, buffer, length);
    return copyingBuffer;
}

- (void)dealloc
{
    free(self.buffer);
}
@end
