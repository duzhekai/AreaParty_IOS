// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: ChangeGroupMsg.proto

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

@class GroupItem;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Enum ChangeGroupReq_ChangeType

typedef GPB_ENUM(ChangeGroupReq_ChangeType) {
  ChangeGroupReq_ChangeType_Add = 0,
  ChangeGroupReq_ChangeType_Delete = 1,
  ChangeGroupReq_ChangeType_UpdateInfo = 2,
};

GPBEnumDescriptor *ChangeGroupReq_ChangeType_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL ChangeGroupReq_ChangeType_IsValidValue(int32_t value);

#pragma mark - Enum ChangeGroupRsp_ResultCode

typedef GPB_ENUM(ChangeGroupRsp_ResultCode) {
  ChangeGroupRsp_ResultCode_UpdateSuccess = 0,
  ChangeGroupRsp_ResultCode_UpdateFail = 1,
  ChangeGroupRsp_ResultCode_DeleteSuccess = 2,
  ChangeGroupRsp_ResultCode_DeleteFail = 3,
  ChangeGroupRsp_ResultCode_NoAuthority = 4,
};

GPBEnumDescriptor *ChangeGroupRsp_ResultCode_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL ChangeGroupRsp_ResultCode_IsValidValue(int32_t value);

#pragma mark - ChangeGroupMsgRoot

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
@interface ChangeGroupMsgRoot : GPBRootObject
@end

#pragma mark - ChangeGroupReq

typedef GPB_ENUM(ChangeGroupReq_FieldNumber) {
  ChangeGroupReq_FieldNumber_GroupId = 1,
  ChangeGroupReq_FieldNumber_ChangeType = 2,
  ChangeGroupReq_FieldNumber_UserIdArray = 3,
  ChangeGroupReq_FieldNumber_GroupName = 4,
};

@interface ChangeGroupReq : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *groupId;
/** Test to see if @c groupId has been set. */
@property(nonatomic, readwrite) BOOL hasGroupId;

@property(nonatomic, readwrite) ChangeGroupReq_ChangeType changeType;

@property(nonatomic, readwrite) BOOL hasChangeType;
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *userIdArray;
/** The number of items in @c userIdArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger userIdArray_Count;

@property(nonatomic, readwrite, copy, null_resettable) NSString *groupName;
/** Test to see if @c groupName has been set. */
@property(nonatomic, readwrite) BOOL hasGroupName;

@end

#pragma mark - ChangeGroupRsp

typedef GPB_ENUM(ChangeGroupRsp_FieldNumber) {
  ChangeGroupRsp_FieldNumber_ResultCode = 1,
  ChangeGroupRsp_FieldNumber_GroupChatId = 2,
  ChangeGroupRsp_FieldNumber_OldGroupName = 3,
  ChangeGroupRsp_FieldNumber_NewGroupName = 4,
  ChangeGroupRsp_FieldNumber_UserIdArray = 5,
};

@interface ChangeGroupRsp : GPBMessage

@property(nonatomic, readwrite) ChangeGroupRsp_ResultCode resultCode;

@property(nonatomic, readwrite) BOOL hasResultCode;
@property(nonatomic, readwrite) int32_t groupChatId;

@property(nonatomic, readwrite) BOOL hasGroupChatId;
@property(nonatomic, readwrite, copy, null_resettable) NSString *oldGroupName;
/** Test to see if @c oldGroupName has been set. */
@property(nonatomic, readwrite) BOOL hasOldGroupName;

@property(nonatomic, readwrite, copy, null_resettable) NSString *newGroupName NS_RETURNS_NOT_RETAINED;
/** Test to see if @c newGroupName has been set. */
@property(nonatomic, readwrite) BOOL hasNewGroupName;

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *userIdArray;
/** The number of items in @c userIdArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger userIdArray_Count;

@end

#pragma mark - ChangeGroupSync

typedef GPB_ENUM(ChangeGroupSync_FieldNumber) {
  ChangeGroupSync_FieldNumber_GroupItem = 1,
};

@interface ChangeGroupSync : GPBMessage

@property(nonatomic, readwrite, strong, null_resettable) GroupItem *groupItem;
/** Test to see if @c groupItem has been set. */
@property(nonatomic, readwrite) BOOL hasGroupItem;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
