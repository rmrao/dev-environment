"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.activate = void 0;
const vscode_1 = __importDefault(require("vscode"));
const PathAutocompleteProvider_1 = require("./features/PathAutocompleteProvider");
function activate(context) {
    const selector = [
        {
            pattern: '**',
        },
    ];
    context.subscriptions.push(vscode_1.default.languages.registerCompletionItemProvider(selector, new PathAutocompleteProvider_1.PathAutocomplete(), '/', '\\'));
}
exports.activate = activate;
// this method is called when your extension is deactivated
// export function deactivate() {}
//# sourceMappingURL=extension.js.map