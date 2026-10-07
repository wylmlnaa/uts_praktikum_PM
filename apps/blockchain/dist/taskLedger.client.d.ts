import { Contract } from "ethers";
import type { TaskLedgerConnection } from "./taskLedger.models";
export declare function getTaskLedgerContract(params: TaskLedgerConnection): Contract;
export declare function decodeRevertReason(e: any, contract: Contract): string | null;
export declare function resolveSignerAddress(contract: Contract): Promise<string>;
export declare function resolveBlockTimestamp(contract: Contract, blockNumber: number): Promise<number | null>;
export declare function normalizeHash(value: string): string;
