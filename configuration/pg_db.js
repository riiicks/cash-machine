const { Pool} = require('pg')

const pool = new Pool({
  user: 'user_db',
  database: 'omnidocdb',
  password: 't3st179_',
  port: 5432,
  host: 'localhost',
})


module.exports = { pool };