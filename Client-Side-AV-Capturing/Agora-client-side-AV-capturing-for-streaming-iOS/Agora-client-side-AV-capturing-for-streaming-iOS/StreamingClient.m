//
//  StreamingClient.m
//  Agora-client-side-AV-capturing-for-streaming-iOS
//
//  Created by GongYuhua on 2017/4/7.
//  Copyright © 2017 Agora. All rights reserved.
//

#import "StreamingClient.h"

NSTimeInterval const YUVDataSendTimeInterval = 0.05;
NSTimeInterval const PCMDataSendTimeInterval = 0.01;
int const PCMDataSendLength = 2048;

@implementation StreamingClient
- (instancetype)init
{
    if (self = [super init]) {
        //init your streaming settings
    }
    return self;
}

- (void)startStreaming
{
    //start your streaming
}

- (void)stopStreaming
{
    //stop your streaming
}

- (void)sendYUVData:(unsigned char *)pYUVBuff dataLength:(unsigned int)length
{
    //send video data
}

- (void)sendPCMData:(unsigned char*)pPCMData dataLength:(unsigned int)length
{
    //send audio data
}
@end
