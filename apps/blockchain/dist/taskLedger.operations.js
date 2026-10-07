"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.recordTaskVerification = recordTaskVerification;
exports.verifyTaskOnChain = verifyTaskOnChain;
exports.revokeTaskVerificationOnChain = revokeTaskVerificationOnChain;
exports.reverifyTaskOnChain = reverifyTaskOnChain;
exports.readTaskVerificationOnChain = readTaskVerificationOnChain;
exports.hashTaskId = hashTaskId;
exports.hashTaskPayload = hashTaskPayload;
exports.hashTaskRevokeReason = hashTaskRevokeReason;
const ethers_1 = require("ethers");
const hash_1 = require("./hash");
const taskLedger_client_1 = require("./taskLedger.client");
async function recordTaskVerification(input) {
    return verifyTaskOnChain(input);
}
async function verifyTaskOnChain(input) {
    const taskId = String(input.taskId || "");
    if (!taskId)
        throw new Error("verifyTaskOnChain: taskId is required");
    const taskIdHash = (0, ethers_1.id)(taskId);
    const payloadHash = (0, hash_1.canonicalHash)(input.payload);
    const contract = (0, taskLedger_client_1.getTaskLedgerContract)(input);
    const signerAddress = await (0, taskLedger_client_1.resolveSignerAddress)(contract);
    let tx;
    try {
        tx = await contract.verifyTask(taskIdHash, payloadHash);
    }
    catch (e) {
        const decoded = (0, taskLedger_client_1.decodeRevertReason)(e, contract);
        if (decoded)
            throw new Error(`verifyTaskOnChain: ${decoded}`);
        throw e;
    }
    const receipt = await tx.wait();
    const blockNumber = receipt?.blockNumber;
    if (typeof blockNumber !== "number") {
        throw new Error("verifyTaskOnChain: missing blockNumber in transaction receipt");
    }
    const blockTimestamp = await (0, taskLedger_client_1.resolveBlockTimestamp)(contract, blockNumber);
    return { txHash: tx.hash, blockNumber, taskIdHash, payloadHash, signerAddress, blockTimestamp };
}
async function revokeTaskVerificationOnChain(input) {
    const taskId = String(input.taskId || "");
    if (!taskId)
        throw new Error("revokeTaskVerificationOnChain: taskId is required");
    const taskIdHash = (0, ethers_1.id)(taskId);
    const reasonHash = (0, hash_1.canonicalHash)(input.reason);
    const contract = (0, taskLedger_client_1.getTaskLedgerContract)(input);
    const signerAddress = await (0, taskLedger_client_1.resolveSignerAddress)(contract);
    let tx;
    try {
        tx = await contract.revokeTaskVerification(taskIdHash, reasonHash);
    }
    catch (e) {
        const decoded = (0, taskLedger_client_1.decodeRevertReason)(e, contract);
        if (decoded)
            throw new Error(`revokeTaskVerificationOnChain: ${decoded}`);
        throw e;
    }
    const receipt = await tx.wait();
    const blockNumber = receipt?.blockNumber;
    if (typeof blockNumber !== "number") {
        throw new Error("revokeTaskVerificationOnChain: missing blockNumber in transaction receipt");
    }
    const blockTimestamp = await (0, taskLedger_client_1.resolveBlockTimestamp)(contract, blockNumber);
    return { txHash: tx.hash, blockNumber, taskIdHash, reasonHash, signerAddress, blockTimestamp };
}
async function reverifyTaskOnChain(input) {
    const taskId = String(input.taskId || "");
    if (!taskId)
        throw new Error("reverifyTaskOnChain: taskId is required");
    const taskIdHash = (0, ethers_1.id)(taskId);
    const payloadHash = (0, hash_1.canonicalHash)(input.payload);
    const contract = (0, taskLedger_client_1.getTaskLedgerContract)(input);
    const signerAddress = await (0, taskLedger_client_1.resolveSignerAddress)(contract);
    let tx;
    try {
        tx = await contract.reverifyTask(taskIdHash, payloadHash);
    }
    catch (e) {
        const decoded = (0, taskLedger_client_1.decodeRevertReason)(e, contract);
        if (decoded)
            throw new Error(`reverifyTaskOnChain: ${decoded}`);
        throw e;
    }
    const receipt = await tx.wait();
    const blockNumber = receipt?.blockNumber;
    if (typeof blockNumber !== "number") {
        throw new Error("reverifyTaskOnChain: missing blockNumber in transaction receipt");
    }
    const blockTimestamp = await (0, taskLedger_client_1.resolveBlockTimestamp)(contract, blockNumber);
    return { txHash: tx.hash, blockNumber, taskIdHash, payloadHash, signerAddress, blockTimestamp };
}
async function readTaskVerificationOnChain(input) {
    const taskId = String(input.taskId || "");
    if (!taskId)
        throw new Error("readTaskVerificationOnChain: taskId is required");
    const taskIdHash = (0, ethers_1.id)(taskId);
    const contract = (0, taskLedger_client_1.getTaskLedgerContract)(input);
    const [payloadHashRaw, revokedRaw] = await Promise.all([
        contract.verifiedPayloadByTask(taskIdHash),
        contract.revokedTask(taskIdHash),
    ]);
    const payloadHash = String(payloadHashRaw || "");
    const verified = (0, taskLedger_client_1.normalizeHash)(payloadHash) !== (0, taskLedger_client_1.normalizeHash)(ethers_1.ZeroHash);
    const revoked = Boolean(revokedRaw);
    return { taskIdHash, payloadHash, verified, revoked };
}
function hashTaskId(taskId) {
    const normalizedTaskId = String(taskId || "");
    if (!normalizedTaskId)
        throw new Error("hashTaskId: taskId is required");
    return (0, ethers_1.id)(normalizedTaskId);
}
function hashTaskPayload(payload) {
    return (0, hash_1.canonicalHash)(payload);
}
function hashTaskRevokeReason(reason) {
    return (0, hash_1.canonicalHash)(reason);
}
