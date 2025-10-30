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
exports.PathAutocomplete = void 0;
const vscode_1 = __importDefault(require("vscode"));
const minimatch_1 = __importDefault(require("minimatch"));
const FileInfo_1 = require("./FileInfo");
const PathConfiguration_1 = __importDefault(require("./PathConfiguration"));
const FsUtils_1 = require("./FsUtils");
const Normalize_1 = require("./Normalize");
const path = __importStar(require("../util/path"));
const configuration = PathConfiguration_1.default.configuration;
class PathAutocomplete {
    async provideCompletionItems(document, position, _token) {
        configuration.update(document.uri, document.languageId);
        this.currentFile = (0, Normalize_1.normalizeForBrowser)(document.fileName);
        const currentLine = document.getText(document.lineAt(position).range);
        this.currentLine = currentLine;
        this.currentPosition = position.character;
        this.namePrefix = this.getNamePrefix();
        if (!this.shouldProvide()) {
            return [];
        }
        const useBackslash = this.shouldUseBackslash();
        const foldersPath = await this.getFoldersPath(this.currentFile, currentLine, position.character);
        if (foldersPath.length === 0) {
            return [];
        }
        const folderItems = await this.getFolderItems(foldersPath);
        // build the list of the completion items
        const result = folderItems.filter(this.filter, this).map((file) => {
            const insertText = this.getInsertText(file);
            const completion = new vscode_1.default.CompletionItem(insertText);
            // correct suggestion Item icon, ref issue#100
            completion.detail = file.path;
            completion.insertText = insertText;
            // show folders before files
            if (file.isDirectory) {
                if (useBackslash) {
                    completion.label += '\\';
                }
                else {
                    completion.label += '/';
                }
                if (configuration.data.enableFolderTrailingSlash) {
                    let commandText = '/';
                    if (useBackslash) {
                        if (this.shouldUseSingleBackslash()) {
                            commandText = '\\';
                        }
                        else {
                            commandText = this.isInsideQuotes() ? '\\\\' : '\\';
                        }
                    }
                    completion.command = {
                        command: 'default:type',
                        title: 'triggerSuggest',
                        arguments: [
                            {
                                text: commandText,
                            },
                        ],
                    };
                }
                completion.sortText = 'd';
                completion.kind = vscode_1.default.CompletionItemKind.Folder;
            }
            else {
                completion.sortText = 'f';
                completion.kind = vscode_1.default.CompletionItemKind.File;
            }
            // this is deprecated but still needed for the completion to work
            // in json files
            completion.textEdit = new vscode_1.default.TextEdit(new vscode_1.default.Range(position, position), completion.insertText);
            return completion;
        });
        // add the `up one folder` item
        if (!configuration.data.disableUpOneFolder) {
            result.unshift(new vscode_1.default.CompletionItem('..'));
        }
        return result;
    }
    /**
     * Determines if the current completion item should use backshash or forward slash.
     */
    shouldUseBackslash() {
        if (configuration.data.useBackslash) {
            return true;
        }
        const userPath = this.getUserPath(this.currentLine, this.currentPosition);
        const pathParts = userPath.split(/\\|\//);
        const backslashParts = userPath.split('\\');
        // check if backslash is the path separator for the current path
        if (userPath.indexOf('\\') > -1 && pathParts.length === backslashParts.length) {
            return true;
        }
        return false;
    }
    /**
     * Determines if a single backslash should be used in the current string
     */
    shouldUseSingleBackslash() {
        if (configuration.data.useSingleBackslash) {
            return true;
        }
        // attempt to detect raw strings that don't need double backslash
        //  example: r"C:\work"
        if (this.isInsideQuotes()) {
            const currentLine = this.currentLine;
            const position = this.currentPosition;
            for (let i = position; i > 0; i--) {
                const c = currentLine[i];
                const isQuote = c === '"' || c === "'" || c === '`';
                if (i > 0 && isQuote && currentLine[i - 1] === 'r') {
                    return true;
                }
            }
            return false;
        }
    }
    /**
     * Gets the name prefix for the completion item.
     * This is used when the path that the user typed so far
     * contains part of the file/folder name
     * Examples:
     *      /folder/Fi => complete path is /folder/File => will return Fi
     *      /folder/subfo => complete path is /folder/subfolder => will return subfo
     */
    getNamePrefix() {
        const userPath = this.getUserPath(this.currentLine, this.currentPosition);
        if (userPath.endsWith('/') || userPath.endsWith('\\')) {
            return '';
        }
        return path.basename(userPath);
    }
    /**
     * Determines if the file extension should be included in the selected options when
     * the selection is made.
     */
    isExtensionEnabled() {
        if (this.currentLine.match(/require|import/)) {
            return configuration.data.withExtensionOnImport;
        }
        return configuration.data.withExtension;
    }
    getInsertText(file) {
        let insertText = '';
        if (this.isExtensionEnabled() || file.isDirectory) {
            insertText = file.name;
        }
        else {
            // remove the extension
            insertText = path.basename(file.name, path.extname(file.name));
        }
        if (!this.namePrefix &&
            this.shouldUseBackslash() &&
            this.isInsideQuotes() &&
            !this.shouldUseSingleBackslash()) {
            // determine if we should insert an additional backslash
            if (this.currentLine[this.currentPosition - 2] !== '\\') {
                insertText = '\\' + insertText;
            }
        }
        // apply the transformations
        configuration.data.transformations.forEach((transform) => {
            const fileNameRegex = transform.when && transform.when.fileName && new RegExp(transform.when.fileName);
            if (fileNameRegex && !file.name.match(fileNameRegex)) {
                return;
            }
            const pathRegex = transform.when && transform.when.path && new RegExp(transform.when.path);
            if (pathRegex && !file.path.match(pathRegex)) {
                return;
            }
            const parameters = transform.parameters || [];
            if (transform.type === 'replace' && parameters[0]) {
                insertText = String.prototype.replace.call(insertText, new RegExp(parameters[0], parameters[2]), parameters[1]);
            }
        });
        if (this.namePrefix) {
            insertText = insertText.substring(this.namePrefix.length);
        }
        return insertText;
    }
    /**
     * Builds a list of the available files and folders from the provided path.
     */
    async getFolderItems(foldersPath) {
        const getFileInfoPromises = foldersPath.map(async (folderPath) => {
            const fileTuples = await (0, FsUtils_1.readDirectory)(folderPath);
            return Promise.all(fileTuples.map(async (fileTuple) => {
                const filePath = path.join(folderPath, fileTuple[0]);
                try {
                    const isDir = fileTuple[1] === vscode_1.default.FileType.Directory;
                    return new FileInfo_1.FileInfo(filePath, isDir ? 'dir' : 'file');
                }
                catch (err) {
                    // silently ignore permissions errors
                    console.error(err);
                }
            }));
        });
        const fileInfosArray = await Promise.all(getFileInfoPromises);
        return fileInfosArray.flat().filter((record) => {
            // in case of a file permission error we need to keep only valid
            // FileInfo objects in the result
            return Boolean(record);
        });
    }
    /**
     * Builds the current folder path based on the current file and the path from
     * the current line.
     *
     */
    async getFoldersPath(fileName, currentLine, currentPosition) {
        const userPath = this.getUserPath(currentLine, currentPosition);
        const mappingResult = this.applyMapping(userPath);
        const promises = mappingResult.items
            .map((item) => {
            const insertedPath = item.insertedPath;
            const currentDir = item.currentDir || this.getCurrentDirectory(fileName, insertedPath);
            // relative to the disk
            if (insertedPath.match(/^[a-z]:/i)) {
                return [insertedPath];
            }
            // user folder
            if (insertedPath.startsWith('~')) {
                return [path.join(configuration.data.homeDirectory, insertedPath.substring(1))];
            }
            return [path.join(currentDir, insertedPath)];
        })
            // merge the resulted path
            .flat()
            // keep only folders
            .map(async (folderPath) => {
            if (!folderPath.endsWith('/') && !folderPath.endsWith('\\')) {
                const isDirPath = await (0, FsUtils_1.isDirectory)(folderPath);
                if (!isDirPath) {
                    folderPath = path.dirname(folderPath);
                }
            }
            const item = {
                folderPath,
                valid: true,
            };
            if (!(await (0, FsUtils_1.pathExists)(item.folderPath)) || !(await (0, FsUtils_1.isDirectory)(item.folderPath))) {
                item.valid = false;
            }
            return item;
        });
        const items = await Promise.all(promises);
        const foldersPath = [];
        for (const item of items) {
            if (item.valid) {
                foldersPath.push(item.folderPath);
            }
        }
        return foldersPath;
    }
    /**
     * Retrieves the path inserted by the user. This is taken based on the last quote or last white space character.
     *
     * @param currentLine The current line of the cursor.
     * @param currentPosition The current position of the cursor.
     */
    getUserPath(currentLine, currentPosition) {
        let lastQuote = -1;
        let lastSeparator = -1;
        const pathSeparators = configuration.data.pathSeparators.split('');
        for (let i = 0; i < currentPosition; i++) {
            const c = currentLine[i];
            // skip next character if escaped
            if (c === '\\') {
                i++;
                continue;
            }
            // handle separators for support outside strings
            if (pathSeparators.indexOf(c) > -1) {
                lastSeparator = i;
                continue;
            }
            // handle quotes
            if (c === "'" || c === '"' || c === '`') {
                lastQuote = i;
            }
        }
        const startPosition = lastQuote !== -1 ? lastQuote : lastSeparator;
        let userPath = currentLine.substring(startPosition + 1, currentPosition);
        // apply the transformations
        configuration.data.transformations.forEach((transform) => {
            const pathRegex = transform.when && transform.when.path && new RegExp(transform.when.path);
            if (pathRegex && !userPath.match(pathRegex)) {
                return;
            }
            const parameters = transform.parameters || [];
            if (transform.type === 'inputReplace' && parameters[0]) {
                userPath = String.prototype.replace.call(userPath, new RegExp(parameters[0], parameters[2]), parameters[1]);
            }
        });
        return userPath;
    }
    /**
     * Returns the current working directory
     */
    getCurrentDirectory(fileName, insertedPath) {
        let currentDir = path.parse(fileName).dir || '/';
        const workspacePath = configuration.data.workspaceFolderPath;
        // based on the project root
        if (insertedPath.startsWith('/') && workspacePath) {
            currentDir = workspacePath;
        }
        return path.resolve(currentDir);
    }
    /**
     * Applies the folder mappings based on the user configurations
     */
    applyMapping(insertedPath) {
        const workspaceFolderPath = configuration.data.workspaceFolderPath;
        const workspaceRootPath = configuration.data.workspaceRootPath;
        const items = [];
        Object.keys(configuration.data.pathMappings || {})
            // if insertedPath is '@view/'
            // and mappings is [{key: '@', ...}, {key: '@view', ...}]
            // and it will match '@' and return wrong items { currentDir: 'xxx',  insertedPath: 'view/'}
            // solution : Sort keys by matching longest prefix, and it will match key(@view) first
            .sort((key1, key2) => {
            const f1 = insertedPath.startsWith(key1) ? key1.length : 0;
            const f2 = insertedPath.startsWith(key2) ? key2.length : 0;
            return f2 - f1;
        })
            .filter((key) => {
            const candidate = configuration.data.pathMappings[key];
            if (typeof candidate == 'string' || Array.isArray(candidate)) {
                return true;
            }
            if (typeof candidate == 'object' && Array.isArray(candidate.conditions)) {
                /*
                    "conditions": [
                        {
                            "when": "packages/math/**",
                            "value": "${folder}/packages/math"
                        }
                    ]
                */
                return candidate.conditions.some((condition) => {
                    return (0, minimatch_1.default)(this.currentFile, condition.when);
                });
            }
            return false;
        })
            .map((key) => {
            let candidatePaths = configuration.data.pathMappings[key];
            // normalize candidate paths
            if (typeof candidatePaths == 'object' && Array.isArray(candidatePaths.conditions)) {
                const matchingCandidate = candidatePaths.conditions.find((condition) => (0, minimatch_1.default)(this.currentFile, condition.when));
                candidatePaths = matchingCandidate.value;
            }
            if (typeof candidatePaths == 'string') {
                candidatePaths = [candidatePaths];
            }
            return candidatePaths.map((candidatePath) => {
                if (workspaceRootPath) {
                    candidatePath = candidatePath.replace('${workspace}', workspaceRootPath);
                }
                if (workspaceFolderPath) {
                    candidatePath = candidatePath.replace('${folder}', workspaceFolderPath);
                }
                candidatePath = candidatePath.replace('${home}', configuration.data.homeDirectory);
                if (configuration.data.fileDirname) {
                    candidatePath = candidatePath.replace('${fileDirname}', configuration.data.fileDirname);
                }
                if (configuration.data.relativeFileDirname) {
                    candidatePath = candidatePath.replace('${relativeFileDirname}', configuration.data.relativeFileDirname);
                }
                return {
                    key: key,
                    path: candidatePath,
                };
            });
        })
            .some((mappings) => {
            let found = false;
            mappings.forEach((mapping) => {
                if (insertedPath.startsWith(mapping.key) ||
                    (mapping.key === '$root' && !insertedPath.startsWith('.'))) {
                    items.push({
                        currentDir: mapping.path,
                        insertedPath: insertedPath.replace(mapping.key, ''),
                    });
                    found = true;
                }
            });
            // stop after the first mapping found
            return found;
        });
        // no mapping was found, use the raw path inserted by the user
        if (items.length === 0) {
            items.push({
                currentDir: '',
                insertedPath,
            });
        }
        return { items };
    }
    /**
     * Determine if we should provide path completion.
     */
    shouldProvide() {
        if (configuration.data.ignoredFilesPattern &&
            (0, minimatch_1.default)(this.currentFile, configuration.data.ignoredFilesPattern)) {
            return false;
        }
        if (this.isIgnoredPrefix()) {
            return false;
        }
        if (configuration.data.triggerOutsideStrings) {
            return true;
        }
        return this.isInsideQuotes();
    }
    /**
     * Determines if the prefix of the path is in the ignored list
     */
    isIgnoredPrefix() {
        const ignoredPrefixes = configuration.data.ignoredPrefixes;
        if (!ignoredPrefixes || ignoredPrefixes.length === 0) {
            return false;
        }
        return ignoredPrefixes.some((prefix) => {
            const currentLine = this.currentLine;
            const position = this.currentPosition;
            if (prefix.length > currentLine.length) {
                return false;
            }
            const candidate = currentLine.substring(position - prefix.length, position);
            if (prefix === candidate) {
                return true;
            }
            return false;
        });
    }
    /**
     * Determines if the cursor is inside quotes.
     */
    isInsideQuotes() {
        const currentLine = this.currentLine;
        const position = this.currentPosition;
        const quotes = {
            single: 0,
            double: 0,
            backtick: 0,
        };
        // check if we are inside quotes
        for (let i = 0; i < position; i++) {
            if (currentLine.charAt(i) === "'" && currentLine.charAt(i - 1) !== '\\') {
                quotes.single += quotes.single > 0 ? -1 : 1;
            }
            if (currentLine.charAt(i) === '"' && currentLine.charAt(i - 1) !== '\\') {
                quotes.double += quotes.double > 0 ? -1 : 1;
            }
            if (currentLine.charAt(i) === '`' && currentLine.charAt(i - 1) !== '\\') {
                quotes.backtick += quotes.backtick > 0 ? -1 : 1;
            }
        }
        return !!(quotes.single || quotes.double || quotes.backtick);
    }
    /**
     * Filter for the suggested items
     */
    filter(suggestionFile) {
        // no options configured
        if (!configuration.data.excludedItems || typeof configuration.data.excludedItems != 'object') {
            return true;
        }
        // keep only the records that match the name prefix inserted by the user
        if (this.namePrefix && suggestionFile.name.indexOf(this.namePrefix) !== 0) {
            return false;
        }
        const currentFile = this.currentFile;
        const currentLine = this.currentLine;
        return Object.entries(configuration.data.excludedItems).every(([item, exclusion]) => {
            // check the local file name pattern
            if (!(0, minimatch_1.default)(currentFile, exclusion.when)) {
                return true;
            }
            if (!(0, minimatch_1.default)(suggestionFile.path, item)) {
                return true;
            }
            // check the local line context
            if (exclusion.context) {
                const contextRegex = new RegExp(exclusion.context);
                if (!contextRegex.test(currentLine)) {
                    return true;
                }
            }
            // exclude folders from the results
            if (exclusion.isDir && !suggestionFile.isDirectory) {
                return true;
            }
            return false;
        });
    }
}
exports.PathAutocomplete = PathAutocomplete;
//# sourceMappingURL=PathAutocompleteProvider.js.map