// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: LogoutMsg.proto

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

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Enum LogoutReq_LogoutType

typedef GPB_ENUM(LogoutReq_LogoutType) {
  LogoutReq_LogoutType_Mobile = 0,
  LogoutReq_LogoutType_Pc = 1,

  /** 强制PC用户下线 */
  LogoutReq_LogoutType_PcForce = 2,
};

GPBEnumDescriptor *LogoutReq_LogoutType_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL LogoutReq_LogoutType_IsValidValue(int32_t value);

#pragma mark - Enum LogoutRsp_ResultCode

typedef GPB_ENUM(LogoutRsp_ResultCode) {
  /** 手机 */
  LogoutRsp_ResultCode_Success = 0,
  LogoutRsp_ResultCode_Fail = 1,

  /** PC主动 */
  LogoutRsp_ResultCode_PcSuccess = 2,
  LogoutRsp_ResultCode_PcFail = 3,

  /** PC强制下线请求方 */
  LogoutRsp_ResultCode_PcForceSuccess = 4,
  LogoutRsp_ResultCode_PcForceFail = 5,

  /** PC被强制下线方 */
  LogoutRsp_ResultCode_PcForceLogout = 6,
};

GPBEnumDescriptor *LogoutRsp_ResultCode_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL LogoutRsp_ResultCode_IsValidValue(int32_t value);

#pragma mark - LogoutMsgRoot

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
@interface LogoutMsgRoot : GPBRootObject
@end

#pragma mark - LogoutReq

typedef GPB_ENUM(LogoutReq_FieldNumber) {
  LogoutReq_FieldNumber_LogoutType = 1,
  LogoutReq_FieldNumber_UserId = 2,
};

@interface LogoutReq : GPBMessage

/** 由于手机端已经写死了所以此处为optional */
@property(nonatomic, readwrite) LogoutReq_LogoutType logoutType;

@property(nonatomic, readwrite) BOOL hasLogoutType;
@property(nonatomic, readwrite, copy, null_resettable) NSString *userId;
/** Test to see if @c userId has been set. */
@property(nonatomic, readwrite) BOOL hasUserId;

@end

#pragma mark - LogoutRsp

typedef GPB_ENUM(LogoutRsp_FieldNumber) {
  LogoutRsp_FieldNumber_ResultCode = 1,
};

@interface LogoutRsp : GPBMessage

@property(nonatomic, readwrite) LogoutRsp_ResultCode resultCode;

@property(nonatomic, readwrite) BOOL hasResultCode;
@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
