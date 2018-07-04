// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: LoginMsg.proto

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

@class ChatItem;
@class GroupItem;
@class UserItem;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Enum LoginReq_LoginType

typedef GPB_ENUM(LoginReq_LoginType) {
  LoginReq_LoginType_Mobile = 0,
  LoginReq_LoginType_Pc = 1,
  LoginReq_LoginType_MobileCode = 2,
};

GPBEnumDescriptor *LoginReq_LoginType_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL LoginReq_LoginType_IsValidValue(int32_t value);

#pragma mark - Enum LoginRsp_ResultCode

typedef GPB_ENUM(LoginRsp_ResultCode) {
  LoginRsp_ResultCode_Success = 0,
  LoginRsp_ResultCode_Loggedin = 1,
  LoginRsp_ResultCode_Fail = 2,

  /** 非主设备 */
  LoginRsp_ResultCode_Notmainphone = 3,

  /** 主设备不在线 */
  LoginRsp_ResultCode_Mainphoneoutline = 4,

  /** 验证码错误 */
  LoginRsp_ResultCode_Usercodewrong = 5,
};

GPBEnumDescriptor *LoginRsp_ResultCode_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL LoginRsp_ResultCode_IsValidValue(int32_t value);

#pragma mark - Enum LoginRsp_MainMobileCode

typedef GPB_ENUM(LoginRsp_MainMobileCode) {
  LoginRsp_MainMobileCode_Yes = 0,
  LoginRsp_MainMobileCode_No = 1,
};

GPBEnumDescriptor *LoginRsp_MainMobileCode_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL LoginRsp_MainMobileCode_IsValidValue(int32_t value);

#pragma mark - LoginMsgRoot

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
@interface LoginMsgRoot : GPBRootObject
@end

#pragma mark - LoginReq

typedef GPB_ENUM(LoginReq_FieldNumber) {
  LoginReq_FieldNumber_UserId = 1,
  LoginReq_FieldNumber_UserPassword = 2,
  LoginReq_FieldNumber_LoginType = 3,
  LoginReq_FieldNumber_UserMac = 4,
  LoginReq_FieldNumber_MobileInfo = 5,
  LoginReq_FieldNumber_UserCode = 6,
};

@interface LoginReq : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *userId;
/** Test to see if @c userId has been set. */
@property(nonatomic, readwrite) BOOL hasUserId;

@property(nonatomic, readwrite, copy, null_resettable) NSString *userPassword;
/** Test to see if @c userPassword has been set. */
@property(nonatomic, readwrite) BOOL hasUserPassword;

@property(nonatomic, readwrite) LoginReq_LoginType loginType;

@property(nonatomic, readwrite) BOOL hasLoginType;
@property(nonatomic, readwrite, copy, null_resettable) NSString *userMac;
/** Test to see if @c userMac has been set. */
@property(nonatomic, readwrite) BOOL hasUserMac;

@property(nonatomic, readwrite, copy, null_resettable) NSString *mobileInfo;
/** Test to see if @c mobileInfo has been set. */
@property(nonatomic, readwrite) BOOL hasMobileInfo;

@property(nonatomic, readwrite, copy, null_resettable) NSString *userCode;
/** Test to see if @c userCode has been set. */
@property(nonatomic, readwrite) BOOL hasUserCode;

@end

#pragma mark - LoginRsp

typedef GPB_ENUM(LoginRsp_FieldNumber) {
  LoginRsp_FieldNumber_ResultCode = 1,
  LoginRsp_FieldNumber_UserItemArray = 2,
  LoginRsp_FieldNumber_ChatItemArray = 3,
  LoginRsp_FieldNumber_UserMac = 4,
  LoginRsp_FieldNumber_MainMobileCode = 5,
  LoginRsp_FieldNumber_GroupItemArray = 6,
  LoginRsp_FieldNumber_ShareFileCount = 7,
  LoginRsp_FieldNumber_ShareFileLimit = 8,
  LoginRsp_FieldNumber_DownloadingLimit = 9,
};

@interface LoginRsp : GPBMessage

@property(nonatomic, readwrite) LoginRsp_ResultCode resultCode;

@property(nonatomic, readwrite) BOOL hasResultCode;
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<UserItem*> *userItemArray;
/** The number of items in @c userItemArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger userItemArray_Count;

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<ChatItem*> *chatItemArray;
/** The number of items in @c chatItemArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger chatItemArray_Count;

@property(nonatomic, readwrite, copy, null_resettable) NSString *userMac;
/** Test to see if @c userMac has been set. */
@property(nonatomic, readwrite) BOOL hasUserMac;

/** 是否为主设备 */
@property(nonatomic, readwrite) LoginRsp_MainMobileCode mainMobileCode;

@property(nonatomic, readwrite) BOOL hasMainMobileCode;
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<GroupItem*> *groupItemArray;
/** The number of items in @c groupItemArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger groupItemArray_Count;

/** 已经分享文件的数量 */
@property(nonatomic, readwrite) int32_t shareFileCount;

@property(nonatomic, readwrite) BOOL hasShareFileCount;
/** 分享文件数量上限 */
@property(nonatomic, readwrite) int32_t shareFileLimit;

@property(nonatomic, readwrite) BOOL hasShareFileLimit;
/** 正在下载的数量上限 */
@property(nonatomic, readwrite) int32_t downloadingLimit;

@property(nonatomic, readwrite) BOOL hasDownloadingLimit;
@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)