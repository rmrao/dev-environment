"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.normalizeForBrowser = void 0;
const os_1 = __importDefault(require("os"));
const normalize = require('normalize-path');
function normalizeForBrowser(filePath) {
    // we only need to do the normalization if we are in a browser environment
    if (os_1.default.platform().indexOf('browser') === -1) {
        return filePath;
    }
    return normalize(filePath);
}
exports.normalizeForBrowser = normalizeForBrowser;
//# sourceMappingURL=Normalize.js.map