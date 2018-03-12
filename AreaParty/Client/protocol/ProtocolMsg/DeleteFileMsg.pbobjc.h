// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: DeleteFileMsg.proto

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

#pragma mark - Enum DeleteFileRsp_ResultCode

typedef GPB_ENUM(DeleteFileRsp_ResultCode) {
  DeleteFileRsp_ResultCode_Success = 0,
  DeleteFileRsp_ResultCode_Fail = 1,
};

GPBEnumDescriptor *DeleteFileRsp_ResultCode_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL DeleteFileRsp_ResultCode_IsValidValue(int32_t value);

#pragma mark - DeleteFileMsgRoot

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
@interface DeleteFileMsgRoot : GPBRootObject
@end

#pragma mark - DeleteFileReq

typedef GPB_ENUM(DeleteFileReq_FieldNumber) {
  DeleteFileReq_FieldNumber_FileName = 1,
};

@interface DeleteFileReq : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *fileName;
/** Test to see if @c fileName has been set. */
@property(nonatomic, readwrite) BOOL hasFileName;

@end

#pragma mark - DeleteFileRsp

typedef GPB_ENUM(DeleteFileRsp_FieldNumber) {
  DeleteFileRsp_FieldNumber_ResultCode = 1,
  DeleteFileRsp_FieldNumber_FileName = 2,
};

@interface DeleteFileRsp : GPBMessage

@property(nonatomic, readwrite) DeleteFileRsp_ResultCode resultCode;

@property(nonatomic, readwrite) BOOL hasResultCode;
@property(nonatomic, readwrite, copy, null_resettable) NSString *fileName;
/** Test to see if @c fileName has been set. */
@property(nonatomic, readwrite) BOOL hasFileName;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)