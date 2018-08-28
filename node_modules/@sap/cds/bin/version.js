module.exports = Object.assign ( run, {
    get: version,
    help: `
# SYNOPSIS

    *cds version*
    *cds -v*

    Prints the version of CDS
`})

function run(_, options={}) {
  const log = options.log || console.log
  const mark = options.noColors ? s => s : require('./utils/term').info
  const info = version ()
  Object.keys(info).forEach(key => log(`${mark(key)}: ${info[key]}`))
}

function version() {
  const info = version4 ()

  const path = require('path')
  Object.defineProperty(info, 'home', { value: path.dirname(__dirname) })  // strip off 'bin/'
  info['CDS home'] = info.home
  Object.defineProperty(info, 'initialHome', { value: global.__cds_bin ? path.dirname(global.__cds_bin) : '' })
  if (process.env.DEBUG)  info['CDS initial home'] = info.initialHome

  return info
}

function version4 (pkgPath='..', info={}, parentPath) {
  try {
    const pkj = require(pkgPath + '/package.json')
    const name = pkj.name || pkgPath
    if (info[name])  return // safeguard against circular dependencies
    info[name] = pkj.version
    // recurse sap packages in dependencies...
    for (let dep in pkj.dependencies) if (dep.startsWith('@sap/'))  version4 (dep, info, pkgPath)
  } catch (e) {
    if (e.code !== 'MODULE_NOT_FOUND')  info[pkgPath] = '-- missing --'  // unknown error
    // require fails for indirect packages if node_modules layout is nested, e.g. on Windows.
    // Try one more time with nested node_modules dir.
    else if (parentPath)  version4 (parentPath+'/node_modules/'+pkgPath, info)
  }
  return info
}

/* eslint no-console:0 */
