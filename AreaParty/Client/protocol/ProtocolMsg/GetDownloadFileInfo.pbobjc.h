// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: GetDownloadFileInfo.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers.h>
#else
 #import "GPBProtocolBuffers.h"
#endif

#if GOOGLE_PROTOBUF_OBJC_VERSION < 30002
#error This file was generated by a newer version of protoc which is incompatible with your Protocol Buffer library sources.
#endif
#if 30002 < GOOGLE_PROTOBUF_OBJC_MIN_SUPPORTED_VERSION
#error This file was generated by an older version of protoc which is incompatible with your Protocol Buffer library sources.
#endif

// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CF_EXTERN_C_BEGIN

@class ProgressItem;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Enum GetDownloadFileInfoRsp_ResultCode

typedef GPB_ENUM(GetDownloadFileInfoRsp_ResultCode) {
  GetDownloadFileInfoRsp_ResultCode_Success = 0,
  GetDownloadFileInfoRsp_ResultCode_Fail = 1,
};

GPBEnumDescriptor *GetDownloadFileInfoRsp_ResultCode_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL GetDownloadFileInfoRsp_ResultCode_IsValidValue(int32_t value);

#pragma mark - GetDownloadFileInfoRoot

/**
 * Exposes the extension registry for this file.
 *
 * The base class provides:
 * @code
 *   + (GPBExtensionRegistry *)extensionRegistry;
 * @endcode
 * which is a @c GPBExtensionRegistry that includes all the extensions defined by
 * this file and all files that it depends on.
 **/
@interface GetDownloadFileInfoRoot : GPBRootObject
@end

#pragma mark - GetDownloadFileInfoReq

typedef GPB_ENUM(GetDownloadFileInfoReq_FieldNumber) {
  GetDownloadFileInfoReq_FieldNumber_UserId = 1,
};

@interface GetDownloadFileInfoReq : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *userId;
/** Test to see if @c userId has been set. */
@property(nonatomic, readwrite) BOOL hasUserId;

@end

#pragma mark - GetDownloadFileInfoRsp

typedef GPB_ENUM(GetDownloadFileInfoRsp_FieldNumber) {
  GetDownloadFileInfoRsp_FieldNumber_ResultCode = 1,
  GetDownloadFileInfoRsp_FieldNumber_ProgressItemArray = 2,
};

@interface GetDownloadFileInfoRsp : GPBMessage

@property(nonatomic, readwrite) GetDownloadFileInfoRsp_ResultCode resultCode;

@property(nonatomic, readwrite) BOOL hasResultCode;
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<ProgressItem*> *progressItemArray;
/** The number of items in @c progressItemArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger progressItemArray_Count;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)