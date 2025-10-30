"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.FileInfo = void 0;
const path_1 = require("../util/path");
class FileInfo {
    /**
     * Extracts the needed information about the provider file path.
     *
     * @throws Error if the path is invalid or you don't have permissions to it
     */
    constructor(path, type) {
        this.name = (0, path_1.basename)(path);
        this.path = path;
        this.type = type;
    }
    get isDirectory() {
        return this.type === 'dir';
    }
}
exports.FileInfo = FileInfo;
//# sourceMappingURL=FileInfo.js.map