// @ts-check

/**
 * Regular expression for matching line endings.
 */
const newlineRe = /\r\n?|\n/g;

/**
 * Converts a string to an array of indented lines.
 * @param {String} string String to convert.
 * @returns {String[]} Array of indented lines.
 */
function toIndentedLines (string) {
	return string.split(newlineRe).map((line) => ` ${line}`);
}

/**
 * String-ifies an Error (or AggregateError) object.
 * @param {Error} error Error object to string-ify.
 * @returns {String} Error details.
 */
function stringifyError (error) {
	const name = error?.name || "[NO NAME]";
	const message = error?.message || JSON.stringify(error);
	const stack = error?.stack || "[NO STACK]";
	// @ts-ignore
	const cause = error?.cause;
	// @ts-ignore
	const errors = error?.errors || [];
	const result = [ `${name}: ${message}`, "stack:" ];
	const frames = stack.split(newlineRe);
	const discardFrame = (frames[0] === result[0]);
	for (const frame of frames.slice(discardFrame ? 1 : 0)) {
		result.push(` ${frame.trim()}`);
	}
	if (cause) {
		result.push("cause:");
		// eslint-disable-next-line unicorn/prefer-single-call
		result.push(...toIndentedLines(stringifyError(cause)));
	}
	if (errors.length > 0) {
		result.push("errors:");
		for (const subError of errors) {
			result.push(...toIndentedLines(stringifyError(subError)));
		}
	}
	return result.join("\n");
}

export default stringifyError;
