"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getTaskLedgerContract = getTaskLedgerContract;
exports.decodeRevertReason = decodeRevertReason;
exports.resolveSignerAddress = resolveSignerAddress;
exports.resolveBlockTimestamp = resolveBlockTimestamp;
exports.normalizeHash = normalizeHash;
const ethers_1 = require("ethers");
const TaskLedger_abi_json_1 = __importDefault(require("./abi/TaskLedger.abi.json"));
function getTaskLedgerContract(params) {
    const rpcUrl = String(params.rpcUrl || "").trim();
    const privateKey = String(params.privateKey || "").trim();
    const contractAddressRaw = String(params.contractAddress || "").trim();
    if (!rpcUrl)
        throw new Error("getTaskLedgerContract: rpcUrl is required");
    if (!privateKey)
        throw new Error("getTaskLedgerContract: privateKey is required");
    if (!(0, ethers_1.isAddress)(contractAddressRaw)) {
        throw new Error(`getTaskLedgerContract: contractAddress is invalid (${contractAddressRaw})`);
    }
    const contractAddress = (0, ethers_1.getAddress)(contractAddressRaw);
    const abi = TaskLedger_abi_json_1.default?.abi;
    if (!Array.isArray(abi)) {
        throw new Error("getTaskLedgerContract: ABI json is invalid (expected { abi: [...] })");
    }
    const provider = new ethers_1.JsonRpcProvider(rpcUrl);
    const wallet = new ethers_1.Wallet(privateKey, provider);
    return new ethers_1.Contract(contractAddress, abi, wallet);
}
function decodeRevertReason(e, contract) {
    const revertData = (typeof e?.data === "string" && e.data.startsWith("0x") ? e.data : null) ||
        (typeof e?.error?.data === "string" && e.error.data.startsWith("0x") ? e.error.data : null) ||
        null;
    if (!revertData)
        return null;
    try {
        const parsed = contract.interface.parseError(revertData);
        if (parsed?.name === "Error") {
            const reason = String(parsed.args?.[0] ?? "").trim();
            if (reason === "ALREADY_VERIFIED")
                return "task already verified (ALREADY_VERIFIED).";
            if (reason === "NOT_VERIFIED")
                return "task is not verified yet (NOT_VERIFIED).";
            if (reason)
                return `execution reverted (${reason}).`;
            return "execution reverted (Error).";
        }
        if (parsed?.name === "AccessControlUnauthorizedAccount") {
            const account = String(parsed.args?.[0] ?? "");
            const neededRole = String(parsed.args?.[1] ?? "");
            if (account && neededRole) {
                return `unauthorized signer ${account} (missing role ${neededRole}). Have the contract admin call grantVerifier(${account}) on ${contract.target}.`;
            }
            return "unauthorized signer (missing required AccessControl role).";
        }
        if (parsed?.name === "AlreadyVerified") {
            return "task already verified (AlreadyVerified).";
        }
        if (parsed?.name === "NotVerified") {
            return "task is not verified yet (NotVerified).";
        }
        if (parsed?.name)
            return `execution reverted (${parsed.name}).`;
    }
    catch {
        // ignore decode failures
    }
    const fallback = String(e?.shortMessage || e?.message || "").trim();
    if (fallback.includes("ALREADY_VERIFIED"))
        return "task already verified (ALREADY_VERIFIED).";
    if (fallback.includes("NOT_VERIFIED"))
        return "task is not verified yet (NOT_VERIFIED).";
    if (fallback.includes("AlreadyVerified"))
        return "task already verified (AlreadyVerified).";
    if (fallback.includes("NotVerified"))
        return "task is not verified yet (NotVerified).";
    if (fallback.includes("missing role"))
        return fallback;
    return fallback ? fallback : null;
}
async function resolveSignerAddress(contract) {
    const maybeRunner = contract.runner;
    if (maybeRunner && typeof maybeRunner.getAddress === "function") {
        try {
            const address = await maybeRunner.getAddress();
            return String(address || "");
        }
        catch {
            return "";
        }
    }
    return "";
}
async function resolveBlockTimestamp(contract, blockNumber) {
    const maybeRunner = contract.runner;
    const provider = maybeRunner?.provider;
    if (!provider || typeof provider.getBlock !== "function")
        return null;
    try {
        const block = await provider.getBlock(blockNumber);
        return typeof block?.timestamp === "number" ? block.timestamp : null;
    }
    catch {
        return null;
    }
}
function normalizeHash(value) {
    return String(value || "").trim().toLowerCase();
}
