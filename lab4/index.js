const express = require('express')
const app = express()

app.use(express.json())

app.get('/', (req, res) => res.send('Hello World!'))

app.post('/test-post', (req, res) => {
	if (req.body.msg && req.body.msg === 'Hello, world!') {
		res.send('You sent the secret password: "Hello, world!"');
	} else {
		res.send('You did not send the secret password.');
	}
})

app.get('/id/:id', (req, res) => {
	res.send(`Accessing id: ${req.params.id}...`);
})

app.listen(3000, () => console.log('App listening on port 3000!'))