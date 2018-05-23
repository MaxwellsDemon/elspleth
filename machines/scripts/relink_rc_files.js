var fs = require('fs')
var path = require('path')
var os = require('os')

var srcRcDir = process.argv[2]
var rcNameRegex = /^\..+rc$/

if (!srcRcDir) {
  console.log('Usage: ' + path.basename(process.argv[1]) + ' <Directory of .*rc files>')
  process.exit(1)
}

fs.readdir(srcRcDir, (err, data) => {
  if (err) {
    return console.log(err)
  }
  console.log('Reading directory: ' + srcRcDir)
  data.forEach(rcName => {
    if (rcName.match(rcNameRegex)) {
      var rcFile = path.resolve(srcRcDir, rcName)
      var destinationRc = path.resolve(os.homedir(), rcName)
      console.log('About to hard link ' + rcFile + ' to ' + destinationRc)
      fs.unlink(destinationRc, err => {
        if (err) {
          return console.log(err)
        }
        fs.link(rcFile, destinationRc, err => {
          if (err) {
            return console.log(err)
          }
          console.log('Hard linked ' + rcFile + ' to ' + destinationRc)
        })
      })
    }
  })
})

