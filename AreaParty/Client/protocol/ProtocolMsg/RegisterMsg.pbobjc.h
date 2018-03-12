// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: RegisterMsg.proto

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

#pragma mark - Enum RegisterReq_RequestCode

typedef GPB_ENUM(RegisterReq_RequestCode) {
  /** 检查用户名是否存在 */
  RegisterReq_RequestCode_Checkuserid = 0,

  /** 检查手机号是否已被注册 */
  RegisterReq_RequestCode_Checkmobile = 1,

  /** 正式注册 */
  RegisterReq_RequestCode_Register = 2,
};

GPBEnumDescriptor *RegisterReq_RequestCode_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL RegisterReq_RequestCode_IsValidValue(int32_t value);

#pragma mark - Enum RegisterRsp_ResultType

typedef GPB_ENUM(RegisterRsp_ResultType) {
  RegisterRsp_ResultType_Userid = 0,
  RegisterRsp_ResultType_Mobile = 1,
  RegisterRsp_ResultType_Register = 2,
};

GPBEnumDescriptor *RegisterRsp_ResultType_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL RegisterRsp_ResultType_IsValidValue(int32_t value);

#pragma mark - Enum RegisterRsp_ResultCode

typedef GPB_ENUM(RegisterRsp_ResultCode) {
  /** 表示注册成功 */
  RegisterRsp_ResultCode_Success = 0,

  /** 表示用户名已存在 */
  RegisterRsp_ResultCode_Exist = 1,

  /** 验证码错误 */
  RegisterRsp_ResultCode_Codewrong = 2,
};

GPBEnumDescriptor *RegisterRsp_ResultCode_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL RegisterRsp_ResultCode_IsValidValue(int32_t value);

#pragma mark - RegisterMsgRoot

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
@interface RegisterMsgRoot : GPBRootObject
@end

#pragma mark - RegisterReq

typedef GPB_ENUM(RegisterReq_FieldNumber) {
  RegisterReq_FieldNumber_RequestCode = 1,
  RegisterReq_FieldNumber_UserId = 2,
  RegisterReq_FieldNumber_UserName = 3,
  RegisterReq_FieldNumber_UserPassword = 4,
  RegisterReq_FieldNumber_UserMobile = 5,
  RegisterReq_FieldNumber_UserMac = 6,
  RegisterReq_FieldNumber_UserAddress = 7,
  RegisterReq_FieldNumber_UserStreet = 8,
  RegisterReq_FieldNumber_UserCommunity = 9,
  RegisterReq_FieldNumber_RegisterCode = 10,
};

@interface RegisterReq : GPBMessage

@property(nonatomic, readwrite) RegisterReq_RequestCode requestCode;

@property(nonatomic, readwrite) BOOL hasRequestCode;
@property(nonatomic, readwrite, copy, null_resettable) NSString *userId;
/** Test to see if @c userId has been set. */
@property(nonatomic, readwrite) BOOL hasUserId;

@property(nonatomic, readwrite, copy, null_resettable) NSString *userName;
/** Test to see if @c userName has been set. */
@property(nonatomic, readwrite) BOOL hasUserName;

@property(nonatomic, readwrite, copy, null_resettable) NSString *userPassword;
/** Test to see if @c userPassword has been set. */
@property(nonatomic, readwrite) BOOL hasUserPassword;

@property(nonatomic, readwrite, copy, null_resettable) NSString *userMobile;
/** Test to see if @c userMobile has been set. */
@property(nonatomic, readwrite) BOOL hasUserMobile;

@property(nonatomic, readwrite, copy, null_resettable) NSString *userMac;
/** Test to see if @c userMac has been set. */
@property(nonatomic, readwrite) BOOL hasUserMac;

@property(nonatomic, readwrite, copy, null_resettable) NSString *userAddress;
/** Test to see if @c userAddress has been set. */
@property(nonatomic, readwrite) BOOL hasUserAddress;

@property(nonatomic, readwrite, copy, null_resettable) NSString *userStreet;
/** Test to see if @c userStreet has been set. */
@property(nonatomic, readwrite) BOOL hasUserStreet;

@property(nonatomic, readwrite, copy, null_resettable) NSString *userCommunity;
/** Test to see if @c userCommunity has been set. */
@property(nonatomic, readwrite) BOOL hasUserCommunity;

@property(nonatomic, readwrite) int32_t registerCode;

@property(nonatomic, readwrite) BOOL hasRegisterCode;
@end

#pragma mark - RegisterRsp

typedef GPB_ENUM(RegisterRsp_FieldNumber) {
  RegisterRsp_FieldNumber_ResultCode = 1,
  RegisterRsp_FieldNumber_ResultType = 2,
};

@interface RegisterRsp : GPBMessage

@property(nonatomic, readwrite) RegisterRsp_ResultCode resultCode;

@property(nonatomic, readwrite) BOOL hasResultCode;
@property(nonatomic, readwrite) RegisterRsp_ResultType resultType;

@property(nonatomic, readwrite) BOOL hasResultType;
@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)