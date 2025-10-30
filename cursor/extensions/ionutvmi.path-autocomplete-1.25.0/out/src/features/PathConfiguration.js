"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = __importDefault(require("vscode"));
const process = __importStar(require("../util/process"));
const path = __importStar(require("../util/path"));
class PathConfiguration {
    constructor() {
        this.data = {};
        this.update();
    }
    update(fileUri, languageId) {
        const codeConfiguration = vscode_1.default.workspace.getConfiguration('path-autocomplete', {
            uri: fileUri,
            languageId: languageId,
        });
        this.data.withExtension = codeConfiguration.get('includeExtension');
        this.data.withExtensionOnImport = codeConfiguration.get('extensionOnImport');
        this.data.excludedItems = codeConfiguration.get('excludedItems');
        this.data.pathMappings = codeConfiguration.get('pathMappings');
        this.data.pathSeparators = codeConfiguration.get('pathSeparators');
        this.data.transformations = codeConfiguration.get('transformations');
        this.data.triggerOutsideStrings = codeConfiguration.get('triggerOutsideStrings');
        this.data.disableUpOneFolder = codeConfiguration.get('disableUpOneFolder');
        this.data.useBackslash = codeConfiguration.get('useBackslash');
        this.data.useSingleBackslash = codeConfiguration.get('useSingleBackslash');
        this.data.enableFolderTrailingSlash = codeConfiguration.get('enableFolderTrailingSlash');
        this.data.ignoredFilesPattern = codeConfiguration.get('ignoredFilesPattern');
        this.data.ignoredPrefixes = codeConfiguration.get('ignoredPrefixes');
        this.data.homeDirectory = process.env[process.platform === 'win32' ? 'USERPROFILE' : 'HOME'];
        const workspaceRootFolder = vscode_1.default.workspace.workspaceFolders
            ? vscode_1.default.workspace.workspaceFolders[0]
            : null;
        let workspaceFolder = workspaceRootFolder;
        if (fileUri) {
            workspaceFolder = vscode_1.default.workspace.getWorkspaceFolder(fileUri);
            const dirName = path.dirname(fileUri.fsPath);
            this.data.fileDirname = dirName;
            if (workspaceFolder) {
                this.data.relativeFileDirname =
                    path.relative(workspaceFolder.uri.fsPath, dirName) || '.';
            }
        }
        this.data.workspaceFolderPath = workspaceFolder && workspaceFolder.uri.fsPath;
        this.data.workspaceRootPath = workspaceRootFolder && workspaceRootFolder.uri.fsPath;
    }
}
exports.default = PathConfiguration;
PathConfiguration.configuration = new PathConfiguration();
//# sourceMappingURL=PathConfiguration.js.map