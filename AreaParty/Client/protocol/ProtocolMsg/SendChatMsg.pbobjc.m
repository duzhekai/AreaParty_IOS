// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: SendChatMsg.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "GPBProtocolBuffers_RuntimeSupport.h"
#endif

 #import "SendChatMsg.pbobjc.h"
 #import "ChatData.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - SendChatMsgRoot

@implementation SendChatMsgRoot

// No extensions in the file and none of the imports (direct or indirect)
// defined extensions, so no need to generate +extensionRegistry.

@end

#pragma mark - SendChatMsgRoot_FileDescriptor

static GPBFileDescriptor *SendChatMsgRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPB_DEBUG_CHECK_RUNTIME_VERSIONS();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@"protocol"
                                                     syntax:GPBFileSyntaxProto2];
  }
  return descriptor;
}

#pragma mark - SendChatReq

@implementation SendChatReq

@dynamic hasChatData, chatData;
@dynamic hasWhere, where;

typedef struct SendChatReq__storage_ {
  uint32_t _has_storage_[1];
  ChatItem *chatData;
  NSString *where;
} SendChatReq__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "chatData",
        .dataTypeSpecific.className = GPBStringifySymbol(ChatItem),
        .number = SendChatReq_FieldNumber_ChatData,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(SendChatReq__storage_, chatData),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "where",
        .dataTypeSpecific.className = NULL,
        .number = SendChatReq_FieldNumber_Where,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(SendChatReq__storage_, where),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[SendChatReq class]
                                     rootClass:[SendChatMsgRoot class]
                                          file:SendChatMsgRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(SendChatReq__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\001\010\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - SendChatRsp

@implementation SendChatRsp

@dynamic hasResultCode, resultCode;
@dynamic hasChatId, chatId;
@dynamic hasDate, date;
@dynamic hasWhere, where;
@dynamic hasFileDate, fileDate;
@dynamic hasPeerId, peerId;

typedef struct SendChatRsp__storage_ {
  uint32_t _has_storage_[1];
  SendChatRsp_ResultCode resultCode;
  NSString *where;
  NSString *fileDate;
  NSString *peerId;
  int64_t chatId;
  int64_t date;
} SendChatRsp__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "resultCode",
        .dataTypeSpecific.enumDescFunc = SendChatRsp_ResultCode_EnumDescriptor,
        .number = SendChatRsp_FieldNumber_ResultCode,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(SendChatRsp__storage_, resultCode),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "chatId",
        .dataTypeSpecific.className = NULL,
        .number = SendChatRsp_FieldNumber_ChatId,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(SendChatRsp__storage_, chatId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "date",
        .dataTypeSpecific.className = NULL,
        .number = SendChatRsp_FieldNumber_Date,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(SendChatRsp__storage_, date),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "where",
        .dataTypeSpecific.className = NULL,
        .number = SendChatRsp_FieldNumber_Where,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(SendChatRsp__storage_, where),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "fileDate",
        .dataTypeSpecific.className = NULL,
        .number = SendChatRsp_FieldNumber_FileDate,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(SendChatRsp__storage_, fileDate),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "peerId",
        .dataTypeSpecific.className = NULL,
        .number = SendChatRsp_FieldNumber_PeerId,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(SendChatRsp__storage_, peerId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[SendChatRsp class]
                                     rootClass:[SendChatMsgRoot class]
                                          file:SendChatMsgRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(SendChatRsp__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\004\001\n\000\002\006\000\005\010\000\006\006\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - Enum SendChatRsp_ResultCode

GPBEnumDescriptor *SendChatRsp_ResultCode_EnumDescriptor(void) {
  static GPBEnumDescriptor *descriptor = NULL;
  if (!descriptor) {
    static const char *valueNames =
        "Success\000Fail\000";
    static const int32_t values[] = {
        SendChatRsp_ResultCode_Success,
        SendChatRsp_ResultCode_Fail,
    };
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(SendChatRsp_ResultCode)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:SendChatRsp_ResultCode_IsValidValue];
    if (!OSAtomicCompareAndSwapPtrBarrier(nil, worker, (void * volatile *)&descriptor)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL SendChatRsp_ResultCode_IsValidValue(int32_t value__) {
  switch (value__) {
    case SendChatRsp_ResultCode_Success:
    case SendChatRsp_ResultCode_Fail:
      return YES;
    default:
      return NO;
  }
}


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
