//
//  AGVideoProcessing.h
//  Agora-client-side-AV-capturing-for-streaming-iOS
//
//  Created by GongYuhua on 2017/4/5.
//  Copyright © 2017 Agora.io All rights reserved.
//

@class AgoraRtcEngineKit;

@interface AGVideoProcessing : NSObject
+ (int)registerVideoPreprocessing:(AgoraRtcEngineKit*) kit;
+ (int)deregisterVideoPreprocessing:(AgoraRtcEngineKit*) kit;
@end
