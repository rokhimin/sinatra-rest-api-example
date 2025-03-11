### Example REST API using Sinatra with CRUD Features

simple REST API Example using **Sinatra**, implementing CRUD operations.

### Library
- Sinatra (framework)
- SQLite3 (database)
- Bulma (CSS framework)

### **Application Structure**
- **Database:** SQLite with a table named `Anime`, containing columns:
  - `id`
  - `name`
  - `synopsis`
  - `airing`
  - `chara`

### **API Endpoints**
| Method | Endpoint            | Description |
|--------|---------------------|-------------|
| **GET**    | `/api/anime`        | Retrieve all anime data |
| **GET**    | `/api/anime/:id`    | Retrieve anime details by ID |
| **POST**   | `/api/anime`        | Add a new anime |
| **PUT**    | `/api/anime/:id`    | Update an existing anime |
| **DELETE** | `/api/anime/:id`    | Delete an anime |

---

### **Simple Views**
| Route | Description |
|--------|-------------|
| `/` | Main page displaying a list of all anime |
| `/anime/new` | Form to add a new anime |
| `/anime/:id` | Anime detail page |
| `/anime/:id/edit` | Form to edit an existing anime |

---

### **How to Run the Application**
1. **Create the necessary files** (e.g., `app.rb`, `views/`, `config.ru`)
2. **Install dependencies** by running:
   ```sh
   bundle install
   ```
3. **Start the application** using:
   ```sh
   ruby app.rb
   ```
   or  
   ```sh
   rackup config.ru
   ```

4. **Access the application:**
   - **`ruby app.rb`** → Runs on `http://localhost:4567`
   - **`rackup config.ru`** → Runs on `http://localhost:9292`

## License

This project is licensed under the [MIT License](LICENSE).