"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.TASK_PAYLOAD_DOMAIN = exports.TASK_PAYLOAD_SCHEMA_VERSION = void 0;
exports.canonicalStringify = canonicalStringify;
exports.canonicalHash = canonicalHash;
const ethers_1 = require("ethers");
exports.TASK_PAYLOAD_SCHEMA_VERSION = "1";
exports.TASK_PAYLOAD_DOMAIN = "LIFELINE_TASK_V1";
function canonicalStringify(value) {
    return JSON.stringify(canonicalize(value));
}
function canonicalHash(value) {
    return (0, ethers_1.keccak256)((0, ethers_1.toUtf8Bytes)(canonicalStringify(value)));
}
function canonicalize(value) {
    if (value === null)
        return null;
    if (typeof value === "string" || typeof value === "boolean")
        return value;
    if (typeof value === "number") {
        if (!Number.isFinite(value)) {
            throw new Error("canonicalStringify: non-finite numbers are not supported");
        }
        return value;
    }
    if (typeof value === "bigint")
        return value.toString();
    // Mirror JSON.stringify behavior for unsupported primitives.
    if (typeof value === "undefined" || typeof value === "function" || typeof value === "symbol")
        return undefined;
    if (value instanceof Date)
        return value.toISOString();
    if (Array.isArray(value)) {
        return value.map((v) => {
            const cv = canonicalize(v);
            return cv === undefined ? null : cv;
        });
    }
    if (typeof value === "object") {
        const obj = value;
        const keys = Object.keys(obj).sort();
        const out = {};
        for (const k of keys) {
            const cv = canonicalize(obj[k]);
            // Mirror JSON.stringify behavior: omit keys with undefined/function/symbol values.
            if (cv !== undefined)
                out[k] = cv;
        }
        return out;
    }
    throw new Error("canonicalStringify: unsupported value");
}
