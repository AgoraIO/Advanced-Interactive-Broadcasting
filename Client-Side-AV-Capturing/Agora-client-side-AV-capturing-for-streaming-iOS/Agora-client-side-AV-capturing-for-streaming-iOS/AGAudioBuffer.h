//
//  AGAudioBuffer.h
//  Agora-client-side-AV-capturing-for-streaming-iOS
//
//  Created by GongYuhua on 2017/4/7.
//  Copyright © 2017年 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGAudioBuffer : NSObject
@property (assign, nonatomic) void *buffer;
@property (assign, nonatomic) int length;

- (instancetype)initWithBuffer:(void *)buffer
                        length:(int)length;
+ (unsigned char *)copy:(void *)buffer length:(int)length;
@end
