var express = require('express')
var mongojs = require('mongojs')
var app = express()
var db = require('./myDB.js')

function requestMade(req, res, next) {
	console.log('Request made')
	console.log('Body', req.body)
	
	next()
}

app.use(express.json())
app.get('/', [requestMade], (req, res) => {
	res.status(200).send('GET /')
})

app.get('/getAll', [requestMade], (req, res) => {
  db.printAllInCollection('Restaurants', function(docs){
    console.log('Restaurants: ', docs)
    res.send(docs)
  })
})

app.post('/createCollection', [requestMade], (req, res) => {
	const { name } = req.body
	
	if (!name) {
		res.status(409).send('No name supplied')
		return
	}
	
	db.createCollection(name)
	
	res.status(201).send('Success!')
})

app.get('/getCollection', [requestMade], (req, res) => {
	const { name } = req.body
	
	if (!name) {
		res.status(409).send('No name supplied')
		return
	}
	
	db.printAllInCollection(name, function(docs){
		res.status(201).send(docs)
	})
})

app.post('/insertToCollection', [requestMade], (req, res) => {
	const { name, hash, other } = req.body
	
	if (!name || !hash || !other) {
		res.status(409).send('Missing data to insert')
		return
	}
	
	db.insertIntoCollection(name, { hash, other })
	
	res.status(201).send(`Inserted data into ${name}`)
})

app.listen(3000, ()=>console.log("listening"))
