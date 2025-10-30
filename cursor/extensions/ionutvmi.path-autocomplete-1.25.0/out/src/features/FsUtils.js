"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.readDirectory = exports.isDirectory = exports.pathExists = void 0;
const vscode_1 = __importDefault(require("vscode"));
async function pathExists(localPath) {
    try {
        await vscode_1.default.workspace.fs.stat(vscode_1.default.Uri.file(localPath));
        return true;
    }
    catch (e) {
        return false;
    }
}
exports.pathExists = pathExists;
async function isDirectory(filePath) {
    try {
        const stat = await vscode_1.default.workspace.fs.stat(vscode_1.default.Uri.file(filePath));
        return stat.type === vscode_1.default.FileType.Directory;
    }
    catch (e) {
        return false;
    }
}
exports.isDirectory = isDirectory;
async function readDirectory(filePath) {
    return vscode_1.default.workspace.fs.readDirectory(vscode_1.default.Uri.file(filePath));
}
exports.readDirectory = readDirectory;
//# sourceMappingURL=FsUtils.js.map