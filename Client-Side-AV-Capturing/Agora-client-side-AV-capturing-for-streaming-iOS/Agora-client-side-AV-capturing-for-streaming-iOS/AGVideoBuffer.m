//
//  AGVideoBuffer.m
//  Agora-client-side-AV-capturing-for-streaming-iOS
//
//  Created by GongYuhua on 2017/4/7.
//  Copyright © 2017年 Agora. All rights reserved.
//

#import "AGVideoBuffer.h"

@implementation AGVideoBuffer
- (instancetype)initWithUId:(unsigned int)uid
                    yBuffer:(void *)yBuffer
                    uBuffer:(void *)uBuffer
                    vBuffer:(void *)vBuffer
                    yStride:(int)yStride
                    uStride:(int)uStride
                    vStride:(int)vStride
                      width:(int)width
                     height:(int)height
                   rotation:(int)rotation
{
    if (self = [super init]) {
        self.uid = uid;
        [self updateWithYBuffer:yBuffer uBuffer:uBuffer vBuffer:vBuffer yStride:yStride uStride:uStride vStride:vStride width:width height:height rotation:rotation];
    }
    return self;
}

- (void)updateWithYBuffer:(void *)yBuffer
                  uBuffer:(void *)uBuffer
                  vBuffer:(void *)vBuffer
                  yStride:(int)yStride
                  uStride:(int)uStride
                  vStride:(int)vStride
                    width:(int)width
                   height:(int)height
                 rotation:(int)rotation
{
    free(self.yBuffer);
    free(self.uBuffer);
    free(self.vBuffer);
    self.yBuffer = [AGVideoBuffer copy:yBuffer size:yStride * height];
    self.uBuffer = [AGVideoBuffer copy:uBuffer size:uStride * height / 2];
    self.vBuffer = [AGVideoBuffer copy:vBuffer size:vStride * height / 2];
    self.yStride = yStride;
    self.uStride = uStride;
    self.vStride = vStride;
    self.width = width;
    self.height = height;
    self.rotation = rotation;
}

+ (unsigned char *)copy:(void *)buffer size:(int)size
{
    unsigned char *copyingBuffer = malloc(size);
    memcpy(copyingBuffer, buffer, size);
    return copyingBuffer;
}

- (unsigned char *)yuvData
{
    int ysize = self.yStride * self.height;
    int usize = self.uStride * self.height / 2;
    int vsize = self.vStride * self.height / 2;
    unsigned char *temp = malloc(ysize + usize + vsize);
    
    memcpy(temp, self.yBuffer, ysize);
    memcpy(temp + ysize, self.uBuffer, usize);
    memcpy(temp + ysize + usize, self.vBuffer, vsize);
    
    return temp;
}

- (void)dealloc
{
    free(self.yBuffer);
    free(self.uBuffer);
    free(self.vBuffer);
}
@end
