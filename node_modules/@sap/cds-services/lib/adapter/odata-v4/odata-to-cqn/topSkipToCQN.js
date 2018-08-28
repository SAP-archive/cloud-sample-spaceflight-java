/**
 * Add odata top and skip to a CQN object.
 *
 * @param {Object} cqn - CQN object
 * @param {Object} topSkip - object that contains the values of $top and $skip
 * @param {Number} topSkip.top - value of $top
 * @param {Number} [topSkip.skip] - value of $skip
 * @private
 */
const topSkipToCQN = (cqn, topSkip) => {
  cqn.limit(topSkip.top, topSkip.skip)
}

module.exports = topSkipToCQN
