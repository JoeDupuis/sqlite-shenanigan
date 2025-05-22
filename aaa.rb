require 'sqlite3'
require 'benchmark'

db = SQLite3::Database.new("storage/test.db")
db.execute("CREATE TABLE IF NOT EXISTS test (id INTEGER PRIMARY KEY, data TEXT)")

puts Benchmark.measure {
  db.transaction
  1_000_000.times do |i|
    db.execute("INSERT INTO test (data) VALUES (?)", ["Row #{i}"])
  end
  db.commit
}


test
