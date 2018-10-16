LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
# libyuv
LOCAL_MODULE := yuv
LOCAL_SRC_FILES := ../PREBUILT/$(TARGET_ARCH_ABI)/libyuv.a
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)

# All of the source files that we will compile.
LOCAL_SRC_FILES := \
	VMUtil.cpp \
	audio_video_preprocessing_plugin_jni.cpp \

# The JNI headers
LOCAL_C_INCLUDES += \
	$(LOCAL_PATH)/include \

LOCAL_STATIC_LIBRARIES := yuv

LOCAL_LDLIBS := -ldl -llog

LOCAL_MODULE := apm-plugin-audio-video-preprocessing

include $(BUILD_SHARED_LIBRARY)
