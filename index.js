const express = require('express')
const redis = require('redis')
const client = redis.createClient('redis://h:p25pnih6vrapuiareqd49j6ro6i@ec2-23-21-84-3.compute-1.amazonaws.com:23069')
const path = require('path')

const app = express()

const publicPath = express.static(path.join(__dirname, './dist'), {
  maxAge: 315360000000
})
app.use('/', publicPath)

app.get('/count', function (req, res) {
  client.get('count', function (err, reply) {
    if (err) console.log('get count err', err)
    var replyInt = parseInt(reply, 10) + 1
    client.set('count', replyInt.toString(), function (err, reply) {
      if (err) console.log('set err', err)
      client.get('count', function (err, newCount) {
        res.json({
          count: newCount
        })
      })
    })
  })
})

app.listen(3000, function () {
  console.log('Example app listening on port 3000!')
})
