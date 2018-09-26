//
//  StreamingClient.h
//  Agora-client-side-AV-capturing-for-streaming-iOS
//
//  Created by GongYuhua on 2017/4/7.
//  Copyright © 2017 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSTimeInterval const YUVDataSendTimeInterval;

extern NSTimeInterval const PCMDataSendTimeInterval;
extern int const PCMDataSendLength;

@interface StreamingClient : NSObject
- (void)startStreaming;
- (void)stopStreaming;
- (void)sendYUVData:(unsigned char *)pYUVBuff dataLength:(unsigned int)length;
- (void)sendPCMData:(unsigned char*)pPCMData dataLength:(unsigned int)length;
@end
