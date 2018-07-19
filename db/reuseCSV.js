// Copies csv files from reuse modules to the local db/src/gen folder for deployment.
// Only reuse modules in the sap namespace which are directly referenced in the package.json are considered (no recursive evaluation).
// A reuse module must provide an hdbtabledata file declaring its csv files. In case there is no hdbtabledata file, no csv files are copied.
// The hdbtabledata file maps the fully qualified table name to the csv filename.
// If there is a csv file for the same table:
// 1. ... on consumption level and on reuse level => only the file from the consumption level is taken (no merge of data)
// 2. ... in different reuse modules => the file from the reuse module being declared first in the package.json is taken
// All csv files declared in hdbtabledata files are copied according to the rules above, no matter whether the corresponding table is used on consumption level or not.
// In case of structural table changes, it is necessary to provide an 'overwriting' csv file on the consumption level, reflecting the new table structure.
//

const fs = require('fs')
const path = require('path')
const EOL = require('os').EOL
const dependencyFilter = dep => dep.startsWith("space") // only  consider space* modules

const localTableData = _getTableDataSync(path.join(__dirname, 'src/csv')) // local *.hdbtabledata to be filtered out
const tableNames = [] // gather all locally declared table names
localTableData.forEach(filePath => {
  const jsonTableDataContent = JSON.parse(fs.readFileSync(filePath))
  jsonTableDataContent.imports.forEach(entry => { tableNames.push(entry.target_table) })
})

const packages = JSON.parse(fs.readFileSync(path.join(__dirname , '../package.json')))
const reuseTableDataFiles = [] // all potential *.hdbtabledata to be copied
Object.keys(packages.dependencies).filter(dependencyFilter).forEach(dependency => {
  _getTableDataSync(path.join(__dirname, '../node_modules', dependency), reuseTableDataFiles)
})

const newFiles = []
reuseTableDataFiles.forEach(filePath => { // filter out tables declared locally and copy csv data
  console.log(`Reusing csv mappings from '${path.relative(process.cwd(), filePath)}'`)
  const jsonTableDataContent = JSON.parse(fs.readFileSync(filePath))
  const nonFilteredImports = [] // will contain imports with locally declared and/or duplicate tables filtered out
  jsonTableDataContent.imports.filter(entry => {
    const existing = tableNames.includes(entry.target_table)
    if (existing) {
      console.log('Filtered out already existing table: ' + entry.target_table)
    }
    return !existing
  }).forEach(entry => {
    nonFilteredImports.push(entry)
    tableNames.push(entry.target_table)
  })

  const copiedTableDataImports = [] // will contain the table data of the non-filtered imports
  const baseDestPath = path.join(__dirname, 'src/gen', path.dirname(filePath).split('node_modules')[1])
  nonFilteredImports.forEach(entry => {
    const srcFile = path.join(path.dirname(filePath), entry.source_data.file_name)
    if (fs.existsSync(srcFile)) {
      const destFile = path.join(baseDestPath, entry.source_data.file_name)
      _writeContentSync(destFile, fs.readFileSync(srcFile))
      newFiles.push(destFile)
    } else {
      console.log('No csv file was found for table: ' + entry.target_table)
    }
    copiedTableDataImports.push(entry)
  })
  if (nonFilteredImports.length > 0) { // writes the non-filtered table data
    const tableData = {}
    tableData.format_version = 1
    tableData.imports = copiedTableDataImports // assumption: simple *.hdbtabledata
    const destFile = path.join(baseDestPath, path.basename(filePath))
    _writeContentSync(destFile, JSON.stringify(tableData, null, 2))
    newFiles.push(destFile)
  }
})
console.log(reuseTableDataFiles.length + ' *.hdbtabledata filtered and copied')

// add our new files to the list that Web IDE will copy back to the workspace
if (process.env.GENERATION_LOG && newFiles.length > 0) {
	let log = fs.readFileSync(process.env.GENERATION_LOG)
	log += newFiles.map(f => path.relative(process.cwd(), f)).join(EOL)
	fs.writeFileSync(process.env.GENERATION_LOG, log)
}

function _writeContentSync(fileName, data) {
  const pathName = path.dirname(fileName)
  if (fs.existsSync(pathName)) {
    fs.writeFileSync(fileName, data)
  } else {
    _mkdirSync(pathName)
    _writeContentSync(fileName, data)
  }
}

function _mkdirSync(pathName) {
  const sep = path.sep
  const initDir = path.isAbsolute(pathName) ? sep : ''
  pathName.split(sep).reduce((parentDir, childDir) => {
    const curDir = path.resolve('.', parentDir, childDir)
    if (!fs.existsSync(curDir)) {
      fs.mkdirSync(curDir)
    }
    return curDir
  }, initDir)
}

function _getTableDataSync(directory, tableDataList) {
  const files = fs.readdirSync(directory)
  tableDataList = tableDataList || []
  files.forEach(file => {
    if (fs.statSync(path.join(directory, file)).isDirectory()) {
      tableDataList = _getTableDataSync(path.join(directory, file), tableDataList)
    } else if (file.toString().endsWith('.hdbtabledata')) {
      tableDataList.push(path.join(directory, file))
    }
  })
  return tableDataList
}