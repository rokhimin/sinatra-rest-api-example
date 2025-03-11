require 'sinatra'
require 'sinatra/contrib'
require 'sqlite3'
require 'json'

# Konfigurasi Database
configure do
  # Buat database SQLite dan tabel Anime jika belum ada
  DB = SQLite3::Database.new('anime.db')
  DB.results_as_hash = true
  
  DB.execute <<-SQL
    CREATE TABLE IF NOT EXISTS Anime (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      synopsis TEXT,
      airing BOOLEAN,
      chara TEXT
    );
  SQL
end

# Set content type default sebagai JSON
before do
  content_type :json
end

# Set view untuk HTML responses
set :views, File.dirname(__FILE__) + '/views'

# Routes untuk API dan View

# Halaman Utama - HTML View
get '/' do
  content_type :html
  erb :index
end

# API Endpoints

# GET - Mendapatkan semua anime
get '/api/anime' do
  anime = DB.execute("SELECT * FROM Anime")
  anime.to_json
end

# GET - Mendapatkan anime berdasarkan ID
get '/api/anime/:id' do
  id = params[:id]
  anime = DB.execute("SELECT * FROM Anime WHERE id = ?", id).first
  
  if anime
    anime.to_json
  else
    status 404
    {error: "Anime dengan ID #{id} tidak ditemukan"}.to_json
  end
end

# POST - Menambahkan anime baru
post '/api/anime' do
  data = JSON.parse(request.body.read)
  
  name = data['name']
  synopsis = data['synopsis']
  airing = data['airing'] ? 1 : 0
  chara = data['chara']
  
  if name.nil? || name.empty?
    status 400
    return {error: "Nama anime harus diisi"}.to_json
  end
  
  DB.execute(
    "INSERT INTO Anime (name, synopsis, airing, chara) VALUES (?, ?, ?, ?)",
    [name, synopsis, airing, chara]
  )
  
  id = DB.last_insert_row_id
  status 201
  {message: "Anime berhasil ditambahkan", id: id}.to_json
end

# PUT - Memperbarui anime yang ada
put '/api/anime/:id' do
  id = params[:id]
  data = JSON.parse(request.body.read)
  
  anime = DB.execute("SELECT * FROM Anime WHERE id = ?", id).first
  
  if anime.nil?
    status 404
    return {error: "Anime dengan ID #{id} tidak ditemukan"}.to_json
  end
  
  name = data['name'] || anime['name']
  synopsis = data['synopsis'] || anime['synopsis']
  airing = data.key?('airing') ? (data['airing'] ? 1 : 0) : anime['airing']
  chara = data['chara'] || anime['chara']
  
  DB.execute(
    "UPDATE Anime SET name = ?, synopsis = ?, airing = ?, chara = ? WHERE id = ?",
    [name, synopsis, airing, chara, id]
  )
  
  {message: "Anime dengan ID #{id} berhasil diperbarui"}.to_json
end

# DELETE - Menghapus anime
delete '/api/anime/:id' do
  id = params[:id]
  
  anime = DB.execute("SELECT * FROM Anime WHERE id = ?", id).first
  
  if anime.nil?
    status 404
    return {error: "Anime dengan ID #{id} tidak ditemukan"}.to_json
  end
  
  DB.execute("DELETE FROM Anime WHERE id = ?", id)
  
  {message: "Anime dengan ID #{id} berhasil dihapus"}.to_json
end

# View Routes - HTML

# Tampilkan form untuk menambah anime baru
get '/anime/new' do
  content_type :html
  erb :new
end

# Tampilkan detail anime
get '/anime/:id' do
  content_type :html
  @anime = DB.execute("SELECT * FROM Anime WHERE id = ?", params[:id]).first
  
  if @anime
    erb :show
  else
    redirect '/'
  end
end

# Tampilkan form untuk edit anime
get '/anime/:id/edit' do
  content_type :html
  @anime = DB.execute("SELECT * FROM Anime WHERE id = ?", params[:id]).first
  
  if @anime
    erb :edit
  else
    redirect '/'
  end
end
