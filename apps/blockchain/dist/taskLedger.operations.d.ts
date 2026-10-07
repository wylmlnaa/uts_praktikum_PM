import type { ReadTaskVerificationInput, ReadTaskVerificationOutput, RecordTaskVerificationInput, RecordTaskVerificationOutput, ReverifyTaskInput, ReverifyTaskOutput, RevokeTaskVerificationInput, RevokeTaskVerificationOutput, VerifyTaskInput, VerifyTaskOutput } from "./taskLedger.models";
export declare function recordTaskVerification(input: RecordTaskVerificationInput): Promise<RecordTaskVerificationOutput>;
export declare function verifyTaskOnChain(input: VerifyTaskInput): Promise<VerifyTaskOutput>;
export declare function revokeTaskVerificationOnChain(input: RevokeTaskVerificationInput): Promise<RevokeTaskVerificationOutput>;
export declare function reverifyTaskOnChain(input: ReverifyTaskInput): Promise<ReverifyTaskOutput>;
export declare function readTaskVerificationOnChain(input: ReadTaskVerificationInput): Promise<ReadTaskVerificationOutput>;
export declare function hashTaskId(taskId: string): string;
export declare function hashTaskPayload(payload: unknown): string;
export declare function hashTaskRevokeReason(reason: unknown): string;
