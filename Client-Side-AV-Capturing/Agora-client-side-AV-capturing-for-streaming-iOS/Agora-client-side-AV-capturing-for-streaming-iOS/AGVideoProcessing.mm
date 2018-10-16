//
//  AGVideoProcessing.mm
//  Agora-client-side-AV-capturing-for-streaming-iOS
//
//  Created by GongYuhua on 2017/4/5.
//  Copyright © 2017 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AGVideoProcessing.h"

#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import <AgoraRtcEngineKit//IAgoraRtcEngine.h>
#import <AgoraRtcEngineKit/IAgoraMediaEngine.h>
#import <string.h>

#import "LivePusher.h"

class AgoraAudioFrameObserver : public agora::media::IAudioFrameObserver
{
public:
    virtual bool onRecordAudioFrame(AudioFrame& audioFrame) override
    {
        return true;
    }
    virtual bool onPlaybackAudioFrame(AudioFrame& audioFrame) override
    {
        return true;
    }
    
    virtual bool onMixedAudioFrame(AudioFrame& audioFrame) override {
        [LivePusher addAudioBuffer:audioFrame.buffer length:audioFrame.bytesPerSample * audioFrame.samples];
        return true;
    }
    virtual bool onPlaybackAudioFrameBeforeMixing(unsigned int uid, AudioFrame& audioFrame) override
    {
        return true;
    }
};

class AgoraVideoFrameObserver : public agora::media::IVideoFrameObserver
{
public:
    virtual bool onCaptureVideoFrame(VideoFrame& videoFrame) override
    {
        [LivePusher addLocalYBuffer:videoFrame.yBuffer
                            uBuffer:videoFrame.uBuffer
                            vBuffer:videoFrame.vBuffer
                            yStride:videoFrame.yStride
                            uStride:videoFrame.uStride
                            vStride:videoFrame.vStride
                              width:videoFrame.width
                             height:videoFrame.height
                           rotation:videoFrame.rotation];
        return true;
    }
    virtual bool onRenderVideoFrame(unsigned int uid, VideoFrame& videoFrame) override
    {
        [LivePusher addRemoteOfUId:(unsigned int)uid
                           yBuffer:videoFrame.yBuffer
                             uBuffer:videoFrame.uBuffer
                             vBuffer:videoFrame.vBuffer
                             yStride:videoFrame.yStride
                             uStride:videoFrame.uStride
                             vStride:videoFrame.vStride
                               width:videoFrame.width
                              height:videoFrame.height
                          rotation:videoFrame.rotation];
        return true;
    }
};

static AgoraAudioFrameObserver s_audioFrameObserver;
static AgoraVideoFrameObserver s_videoFrameObserver;


@implementation AGVideoProcessing
+ (int) registerVideoPreprocessing: (AgoraRtcEngineKit*) kit
{
    if (!kit) {
        return -1;
    }
    
    agora::rtc::IRtcEngine* rtc_engine = (agora::rtc::IRtcEngine*)kit.getNativeHandle;
    agora::util::AutoPtr<agora::media::IMediaEngine> mediaEngine;
    mediaEngine.queryInterface(rtc_engine, agora::AGORA_IID_MEDIA_ENGINE);
    if (mediaEngine)
    {
        mediaEngine->registerAudioFrameObserver(&s_audioFrameObserver);
        mediaEngine->registerVideoFrameObserver(&s_videoFrameObserver);
    }
    
    [LivePusher start];
    return 0;
}

+ (int) deregisterVideoPreprocessing: (AgoraRtcEngineKit*) kit
{
    if (!kit) {
        return -1;
    }
    
    agora::rtc::IRtcEngine* rtc_engine = (agora::rtc::IRtcEngine*)kit.getNativeHandle;
    agora::util::AutoPtr<agora::media::IMediaEngine> mediaEngine;
    mediaEngine.queryInterface(rtc_engine, agora::AGORA_IID_MEDIA_ENGINE);
    if (mediaEngine)
    {
        mediaEngine->registerAudioFrameObserver(NULL);
        mediaEngine->registerVideoFrameObserver(NULL);
    }
    
    [LivePusher stop];
    return 0;
}
@end
