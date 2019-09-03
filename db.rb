require 'json'

class DB
  @db = JSON.parse(File.read('db.json'))

  def self.read(table)
    table.nil? ? @db : @db[table]
  end

  def self.create(table, entry)
    return if table.nil? || entry.nil?

    @db[table].push entry
    File.write('db.json', @db.to_json)
  end
end