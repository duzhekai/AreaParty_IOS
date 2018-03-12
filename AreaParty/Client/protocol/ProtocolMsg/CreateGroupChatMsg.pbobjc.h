// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: CreateGroupChatMsg.proto

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

#pragma mark - Enum CreateGroupChatRsp_ResultCode

typedef GPB_ENUM(CreateGroupChatRsp_ResultCode) {
  CreateGroupChatRsp_ResultCode_Success = 0,
  CreateGroupChatRsp_ResultCode_Fail = 1,
};

GPBEnumDescriptor *CreateGroupChatRsp_ResultCode_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL CreateGroupChatRsp_ResultCode_IsValidValue(int32_t value);

#pragma mark - CreateGroupChatMsgRoot

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
@interface CreateGroupChatMsgRoot : GPBRootObject
@end

#pragma mark - CreateGroupChatReq

typedef GPB_ENUM(CreateGroupChatReq_FieldNumber) {
  CreateGroupChatReq_FieldNumber_UserIdArray = 1,
};

@interface CreateGroupChatReq : GPBMessage

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *userIdArray;
/** The number of items in @c userIdArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger userIdArray_Count;

@end

#pragma mark - CreateGroupChatRsp

typedef GPB_ENUM(CreateGroupChatRsp_FieldNumber) {
  CreateGroupChatRsp_FieldNumber_ResultCode = 1,
  CreateGroupChatRsp_FieldNumber_GroupChatId = 2,
};

@interface CreateGroupChatRsp : GPBMessage

@property(nonatomic, readwrite) CreateGroupChatRsp_ResultCode resultCode;

@property(nonatomic, readwrite) BOOL hasResultCode;
@property(nonatomic, readwrite) int32_t groupChatId;

@property(nonatomic, readwrite) BOOL hasGroupChatId;
@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)