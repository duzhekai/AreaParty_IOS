// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: AddFriendMsg.proto

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

@class UserItem;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Enum AddFriendReq_RequestType

typedef GPB_ENUM(AddFriendReq_RequestType) {
  AddFriendReq_RequestType_Request = 0,
  AddFriendReq_RequestType_Agree = 1,
  AddFriendReq_RequestType_Refuse = 2,
};

GPBEnumDescriptor *AddFriendReq_RequestType_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL AddFriendReq_RequestType_IsValidValue(int32_t value);

#pragma mark - Enum AddFriendRsp_ResultCode

typedef GPB_ENUM(AddFriendRsp_ResultCode) {
  AddFriendRsp_ResultCode_Success = 0,
  AddFriendRsp_ResultCode_Fail = 1,
};

GPBEnumDescriptor *AddFriendRsp_ResultCode_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL AddFriendRsp_ResultCode_IsValidValue(int32_t value);

#pragma mark - Enum AddFriendRsp_RequestType

typedef GPB_ENUM(AddFriendRsp_RequestType) {
  AddFriendRsp_RequestType_Request = 0,
  AddFriendRsp_RequestType_Agree = 1,
  AddFriendRsp_RequestType_Refuse = 2,
};

GPBEnumDescriptor *AddFriendRsp_RequestType_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL AddFriendRsp_RequestType_IsValidValue(int32_t value);

#pragma mark - AddFriendMsgRoot

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
@interface AddFriendMsgRoot : GPBRootObject
@end

#pragma mark - AddFriendReq

typedef GPB_ENUM(AddFriendReq_FieldNumber) {
  AddFriendReq_FieldNumber_FriendUserId = 1,
  AddFriendReq_FieldNumber_RequestType = 2,
};

@interface AddFriendReq : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *friendUserId;
/** Test to see if @c friendUserId has been set. */
@property(nonatomic, readwrite) BOOL hasFriendUserId;

@property(nonatomic, readwrite) AddFriendReq_RequestType requestType;

@property(nonatomic, readwrite) BOOL hasRequestType;
@end

#pragma mark - AddFriendRsp

typedef GPB_ENUM(AddFriendRsp_FieldNumber) {
  AddFriendRsp_FieldNumber_ResultCode = 1,
  AddFriendRsp_FieldNumber_User = 2,
  AddFriendRsp_FieldNumber_RequestType = 3,
};

@interface AddFriendRsp : GPBMessage

@property(nonatomic, readwrite) AddFriendRsp_ResultCode resultCode;

@property(nonatomic, readwrite) BOOL hasResultCode;
@property(nonatomic, readwrite, strong, null_resettable) UserItem *user;
/** Test to see if @c user has been set. */
@property(nonatomic, readwrite) BOOL hasUser;

@property(nonatomic, readwrite) AddFriendRsp_RequestType requestType;

@property(nonatomic, readwrite) BOOL hasRequestType;
@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)