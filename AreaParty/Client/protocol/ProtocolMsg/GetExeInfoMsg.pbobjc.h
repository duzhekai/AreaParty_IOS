// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: GetExeInfoMsg.proto

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

@class ApplicationItem;
@class GameItem;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Enum GetExeInfoReq_RequestType

typedef GPB_ENUM(GetExeInfoReq_RequestType) {
  GetExeInfoReq_RequestType_All = 0,
  GetExeInfoReq_RequestType_Game = 1,
  GetExeInfoReq_RequestType_Application = 2,
};

GPBEnumDescriptor *GetExeInfoReq_RequestType_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL GetExeInfoReq_RequestType_IsValidValue(int32_t value);

#pragma mark - Enum GetExeInfoRsp_ResultCode

typedef GPB_ENUM(GetExeInfoRsp_ResultCode) {
  GetExeInfoRsp_ResultCode_Success = 0,
  GetExeInfoRsp_ResultCode_Fail = 1,
};

GPBEnumDescriptor *GetExeInfoRsp_ResultCode_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL GetExeInfoRsp_ResultCode_IsValidValue(int32_t value);

#pragma mark - GetExeInfoMsgRoot

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
@interface GetExeInfoMsgRoot : GPBRootObject
@end

#pragma mark - GetExeInfoReq

typedef GPB_ENUM(GetExeInfoReq_FieldNumber) {
  GetExeInfoReq_FieldNumber_RequestType = 1,
};

@interface GetExeInfoReq : GPBMessage

@property(nonatomic, readwrite) GetExeInfoReq_RequestType requestType;

@property(nonatomic, readwrite) BOOL hasRequestType;
@end

#pragma mark - GetExeInfoRsp

typedef GPB_ENUM(GetExeInfoRsp_FieldNumber) {
  GetExeInfoRsp_FieldNumber_ResultCode = 1,
  GetExeInfoRsp_FieldNumber_ApplicationItemArray = 2,
  GetExeInfoRsp_FieldNumber_GameItemArray = 3,
};

@interface GetExeInfoRsp : GPBMessage

@property(nonatomic, readwrite) GetExeInfoRsp_ResultCode resultCode;

@property(nonatomic, readwrite) BOOL hasResultCode;
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<ApplicationItem*> *applicationItemArray;
/** The number of items in @c applicationItemArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger applicationItemArray_Count;

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<GameItem*> *gameItemArray;
/** The number of items in @c gameItemArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger gameItemArray_Count;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)