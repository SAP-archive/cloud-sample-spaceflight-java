const debug = (req, res, next) => {
  req.getContract().enableDebugMode(true)
  next()
}

module.exports = debug
