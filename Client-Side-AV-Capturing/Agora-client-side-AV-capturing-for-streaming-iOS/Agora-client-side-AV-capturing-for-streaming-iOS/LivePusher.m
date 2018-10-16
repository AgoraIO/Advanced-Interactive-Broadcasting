//
//  LivePusher.m
//  Agora-client-side-AV-capturing-for-streaming-iOS
//
//  Created by GongYuhua on 2017/4/5.
//  Copyright © 2017 Agora. All rights reserved.
//

#import "LivePusher.h"
#import "libyuv.h"
#import "AGVideoBuffer.h"
#import "AGAudioBuffer.h"
#import "StreamingClient.h"

@interface LivePusher ()
@property (strong, nonatomic) StreamingClient *client;
@property (assign, nonatomic) BOOL isPushing;

@property (strong, nonatomic) AGVideoBuffer *localVideoBuffer;
@property (strong, nonatomic) NSMutableArray *remoteVideoBuffers;
@property (strong, nonatomic) dispatch_source_t videoPublishTimer;

@property (strong, nonatomic) NSMutableArray *mixedAudioBuffers;
@property (assign, nonatomic) void *mixedAudioBuffer;
@property (assign, nonatomic) int mixedAudioBufferLength;
@property (strong, nonatomic) dispatch_source_t audioPublishTimer;
@end

@implementation LivePusher
+ (LivePusher *)sharedPusher
{
    static LivePusher *sharedPusher = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPusher = [[LivePusher alloc] init];
    });
    return sharedPusher;
}

+ (dispatch_queue_t)sharedQueue
{
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("io.agora.PushRTMPQueue", NULL);
    });
    
    return queue;
}

- (StreamingClient *)client
{
    if (!_client) {
        _client = [[StreamingClient alloc] init];
    }
    return _client;
}

- (NSMutableArray *)remoteVideoBuffers
{
    if (!_remoteVideoBuffers) {
        _remoteVideoBuffers = [[NSMutableArray alloc] init];
    }
    return _remoteVideoBuffers;
}

- (NSMutableArray *)mixedAudioBuffers
{
    if (!_mixedAudioBuffers) {
        _mixedAudioBuffers = [[NSMutableArray alloc] init];
    }
    return _mixedAudioBuffers;
}

#pragma mark -
+ (void)start
{
    [[self sharedPusher] start];
}

+ (void)stop
{
    [[self sharedPusher] stop];
}

- (void)start
{
    if (self.isPushing) {
        return;
    }
    
    [self.client startStreaming];
    self.isPushing = YES;
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, [LivePusher sharedQueue]);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, YUVDataSendTimeInterval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(timer, ^{
        [weakSelf mergeVideoToPush];
    });
    dispatch_resume(timer);
    self.videoPublishTimer = timer;
    
    dispatch_source_t timer2 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, [LivePusher sharedQueue]);
    dispatch_source_set_timer(timer2, DISPATCH_TIME_NOW, PCMDataSendTimeInterval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer2, ^{
        [weakSelf mergeAudioToPush];
    });
    dispatch_resume(timer2);
    self.audioPublishTimer = timer2;
}

- (void)stop
{
    if (!self.isPushing) {
        return;
    }
    
    self.videoPublishTimer = nil;
    self.audioPublishTimer = nil;
    
    [self.client stopStreaming];
    self.isPushing = NO;
}

#pragma mark add video data
+ (void)addLocalYBuffer:(void *)yBuffer uBuffer:(void *)uBuffer vBuffer:(void *)vBuffer
                yStride:(int)yStride uStride:(int)uStride vStride:(int)vStride
                  width:(int)width height:(int)height
               rotation:(int)rotation
{
    [[self sharedPusher] addLocalYBuffer:yBuffer uBuffer:uBuffer vBuffer:vBuffer yStride:yStride uStride:uStride vStride:vStride width:width height:height rotation:rotation];
}

+ (void)addRemoteOfUId:(unsigned int)uid
               yBuffer:(void *)yBuffer uBuffer:(void *)uBuffer vBuffer:(void *)vBuffer
               yStride:(int)yStride uStride:(int)uStride vStride:(int)vStride
                 width:(int)width height:(int)height
              rotation:(int)rotation
{
    [[self sharedPusher] addRemoteOfUId:uid yBuffer:yBuffer uBuffer:uBuffer vBuffer:vBuffer yStride:yStride uStride:uStride vStride:vStride width:width height:height rotation:rotation];
}

- (void)addLocalYBuffer:(void *)yBuffer uBuffer:(void *)uBuffer vBuffer:(void *)vBuffer
                yStride:(int)yStride uStride:(int)uStride vStride:(int)vStride
                  width:(int)width height:(int)height
               rotation:(int)rotation
{
    AGVideoBuffer *buffer = [[AGVideoBuffer alloc] initWithUId:0 yBuffer:yBuffer uBuffer:uBuffer vBuffer:vBuffer yStride:yStride uStride:uStride vStride:vStride width:width height:height rotation:rotation];
    dispatch_async([LivePusher sharedQueue], ^{
        if (self.localVideoBuffer != nil && self.localVideoBuffer.width == width && self.localVideoBuffer.height == height) {
            [self.localVideoBuffer updateWithYBuffer:buffer.yBuffer uBuffer:buffer.uBuffer vBuffer:buffer.vBuffer yStride:buffer.yStride uStride:buffer.uStride vStride:buffer.vStride width:buffer.width height:buffer.height rotation:buffer.rotation];
        } else {
            self.localVideoBuffer = buffer;
        }
    });
}

- (void)addRemoteOfUId:(unsigned int)uid
               yBuffer:(void *)yBuffer uBuffer:(void *)uBuffer vBuffer:(void *)vBuffer
               yStride:(int)yStride uStride:(int)uStride vStride:(int)vStride
                 width:(int)width height:(int)height
              rotation:(int)rotation
{
    AGVideoBuffer *newRemoteBuffer = [[AGVideoBuffer alloc] initWithUId:uid yBuffer:yBuffer uBuffer:uBuffer vBuffer:vBuffer yStride:yStride uStride:uStride vStride:vStride width:width height:height rotation:rotation];
    
    dispatch_async([LivePusher sharedQueue], ^{
        for (NSUInteger index = 0; index < self.remoteVideoBuffers.count; ++index) {
            AGVideoBuffer *buffer = self.remoteVideoBuffers[index];
            if (buffer.uid != newRemoteBuffer.uid) {
                continue;
            }
            
            if (buffer.width == newRemoteBuffer.width && buffer.height == newRemoteBuffer.height) {
                [buffer updateWithYBuffer:newRemoteBuffer.yBuffer uBuffer:newRemoteBuffer.uBuffer vBuffer:newRemoteBuffer.vBuffer yStride:newRemoteBuffer.yStride uStride:newRemoteBuffer.uStride vStride:newRemoteBuffer.vStride width:newRemoteBuffer.width height:newRemoteBuffer.height rotation:newRemoteBuffer.rotation];
            } else {
                [self.remoteVideoBuffers replaceObjectAtIndex:index withObject:newRemoteBuffer];
            }
            return;
        }
        
        [self.remoteVideoBuffers addObject:newRemoteBuffer];
    });
}

#pragma mark add audio
+ (void)addAudioBuffer:(void *)buffer length:(int)length
{
    [[self sharedPusher] addAudioBuffer:buffer length:length];
}

- (void)addAudioBuffer:(void *)buffer length:(int)length
{
    AGAudioBuffer *audioBuffer = [[AGAudioBuffer alloc] initWithBuffer:buffer length:length];
    dispatch_async([LivePusher sharedQueue], ^{
        [self.mixedAudioBuffers addObject:audioBuffer];
    });
}

#pragma mark push
- (void)mergeVideoToPush
{
    if (!self.localVideoBuffer) {
        return;
    }
    
    int localYBufferSize = self.localVideoBuffer.yStride * self.localVideoBuffer.height;
    int localUBufferSize = self.localVideoBuffer.uStride * self.localVideoBuffer.height / 2;
    int localVBufferSize = self.localVideoBuffer.vStride * self.localVideoBuffer.height / 2;
    unsigned char *localYBuffer = [AGVideoBuffer copy:self.localVideoBuffer.yBuffer size:localYBufferSize];
    unsigned char *localUBuffer = [AGVideoBuffer copy:self.localVideoBuffer.uBuffer size:localUBufferSize];
    unsigned char *localVBuffer = [AGVideoBuffer copy:self.localVideoBuffer.vBuffer size:localVBufferSize];
    
    //rotate local
    unsigned char *rotatedLocalYBuffer = malloc(localYBufferSize);
    unsigned char *rotatedLocalUBuffer = malloc(localUBufferSize);
    unsigned char *rotatedLocalVBuffer = malloc(localVBufferSize);
    I420Rotate(localYBuffer, self.localVideoBuffer.yStride,
               localUBuffer, self.localVideoBuffer.uStride,
               localVBuffer, self.localVideoBuffer.vStride,
               rotatedLocalYBuffer, self.localVideoBuffer.height,
               rotatedLocalUBuffer, self.localVideoBuffer.height/2,
               rotatedLocalVBuffer, self.localVideoBuffer.height/2,
               self.localVideoBuffer.width, self.localVideoBuffer.height, self.localVideoBuffer.rotation);
    free(localYBuffer);
    free(localUBuffer);
    free(localVBuffer);
    
    AGVideoBuffer *firstRemote = self.remoteVideoBuffers.firstObject;
    if (firstRemote) {
        int remoteYBufferSize = firstRemote.yStride * firstRemote.height;
        int remoteUBufferSize = firstRemote.uStride * firstRemote.height / 2;
        int remoteVBufferSize = firstRemote.vStride * firstRemote.height / 2;
        unsigned char *remoteYBuffer = [AGVideoBuffer copy:firstRemote.yBuffer size:remoteYBufferSize];
        unsigned char *remoteUBuffer = [AGVideoBuffer copy:firstRemote.uBuffer size:remoteUBufferSize];
        unsigned char *remoteVBuffer = [AGVideoBuffer copy:firstRemote.vBuffer size:remoteVBufferSize];
        
        //merge local to remote
        I420Scale(rotatedLocalYBuffer, self.localVideoBuffer.height,
                  rotatedLocalUBuffer, self.localVideoBuffer.height/2,
                  rotatedLocalVBuffer, self.localVideoBuffer.height/2,
                  self.localVideoBuffer.height, self.localVideoBuffer.width,
                  remoteYBuffer, firstRemote.height,
                  remoteUBuffer, firstRemote.height/2,
                  remoteVBuffer, firstRemote.height/2,
                  firstRemote.height/3, firstRemote.width/3,
                  kFilterNone);
        
        //push
        int dataLength = remoteYBufferSize + remoteUBufferSize + remoteVBufferSize;
        unsigned char *yuvData = malloc(dataLength);
        memcpy(yuvData, remoteYBuffer, remoteYBufferSize);
        memcpy(yuvData + remoteYBufferSize, remoteUBuffer, remoteUBufferSize);
        memcpy(yuvData + remoteYBufferSize + remoteUBufferSize, remoteVBuffer, remoteVBufferSize);
        
        [self pushVideoYUVData:yuvData dataLength:dataLength];
        
        free(remoteYBuffer);
        free(remoteUBuffer);
        free(remoteVBuffer);
        
        free(yuvData);
    } else {
        //push
        int dataLength = localYBufferSize + localUBufferSize + localVBufferSize;
        unsigned char *yuvData = malloc(dataLength);
        memcpy(yuvData, rotatedLocalYBuffer, localYBufferSize);
        memcpy(yuvData + localYBufferSize, rotatedLocalUBuffer, localUBufferSize);
        memcpy(yuvData + localYBufferSize + localUBufferSize, rotatedLocalVBuffer, localVBufferSize);
        
        [self pushVideoYUVData:yuvData dataLength:dataLength];
        free(yuvData);
    }
    
    free(rotatedLocalYBuffer);
    free(rotatedLocalUBuffer);
    free(rotatedLocalVBuffer);
}

- (void)pushVideoYUVData:(unsigned char *)pYUVBuff dataLength:(unsigned int)dataLength
{
    if (!self.isPushing) {
        return;
    }
    
    [self.client sendYUVData:pYUVBuff dataLength:dataLength];
}

//audio
- (void)mergeAudioToPush
{
    while (self.mixedAudioBuffers.count > 0) {
        AGAudioBuffer *firstAudioBuffer = self.mixedAudioBuffers.firstObject;
        
        [self.mixedAudioBuffers removeObjectAtIndex:0];
        
        int bufferLength = 0;
        if (firstAudioBuffer.length > 0) {
            bufferLength = firstAudioBuffer.length;
        } else {
            NSLog(@"!!!!!!!!!! Audio Buffer No Length !!!!!!!!!!!!");
            continue;
        }
        
        [self appendAudioBuffer:firstAudioBuffer.buffer length:bufferLength];
        [self checkMixedBuffer];
    }
}

- (void)appendAudioBuffer:(void *)buffer length:(int)length
{
    if (length <= 0) {
        return;
    }
    int newLength = self.mixedAudioBufferLength + length;
    void *newBuffer = malloc(newLength);
    if (self.mixedAudioBuffer != nil && self.mixedAudioBufferLength > 0) {
        memcpy(newBuffer, self.mixedAudioBuffer, self.mixedAudioBufferLength);
        free(self.mixedAudioBuffer);
    }
    memcpy(newBuffer + self.mixedAudioBufferLength, buffer, length);
    
    self.mixedAudioBuffer = newBuffer;
    self.mixedAudioBufferLength = newLength;
}

- (void)checkMixedBuffer
{
    while (self.mixedAudioBufferLength >= PCMDataSendLength) {
        void *pushingBuffer = malloc(PCMDataSendLength);
        memcpy(pushingBuffer, self.mixedAudioBuffer, PCMDataSendLength);
        
        int remainedLength = self.mixedAudioBufferLength - PCMDataSendLength;
        void *remainedBuffer = malloc(remainedLength);
        memcpy(remainedBuffer, self.mixedAudioBuffer + PCMDataSendLength, remainedLength);
        
        free(self.mixedAudioBuffer);
        self.mixedAudioBuffer = remainedBuffer;
        
        [self pushPCMData:pushingBuffer length:PCMDataSendLength];
        free(pushingBuffer);
        
        self.mixedAudioBufferLength -= PCMDataSendLength;
    }
}

- (void)pushPCMData: (unsigned char*)data length:(int)length
{
    if (!self.isPushing) {
        return;
    }
    
    [self.client sendPCMData:data dataLength:length];
}

@end
