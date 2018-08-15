'use strict';

const Transform = require('stream').Transform;

/**
 * The BufferedWriter is a transform stream that buffers the incoming data and
 * emits the concatenated result as an event.
 *
 * After finished the stream processing this stream emits
 *
 * @extends Transform
 */
class BufferedWriter extends Transform {

    /**
     * Creates an instance of BufferedWriter.
     */
    constructor() {
        super({
            transform(data, encoding, callback) {
                const existingBufferList = this.getBufferList();
                existingBufferList.push(data);
                callback();
            }
        });

        this.on('finish', () => {
            /**
             * Result event to emit the result data.
             * @event BufferedWriter#result
             * @type {Buffer}
             */
            this.emit('result', this.createResultBuffer());
        });

        this._internalBufferList = [];
    }

    /**
     * Returns the internal buffer list
     *
     * @returns {Array} The internal buffer list
     */
    getBufferList() {
        return this._internalBufferList;
    }

    /**
     * Creates a single buffer from the internal buffer list.
     *
     * @returns {Buffer} The concatenated internal buffer
     */
    createResultBuffer() {
        return Buffer.concat(this.getBufferList());
    }
}

module.exports = BufferedWriter;
