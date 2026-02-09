# Flask Integration Patterns

**Version**: 1.0.0  
**Last updated**: 2025-02-05

Capture patterns and anti-patterns for Flask applications integrating with external services, databases, and APIs.

---

## Scope

- Applies to: Flask web applications using SQLAlchemy ORM
- Focus areas: External API calls, database operations, background synchronization
- Does not cover: Basic Flask routing, request handling, authentication

---

## When to use

Activate this skill when:
- Building Flask applications that call external APIs
- Implementing database sync/replication logic
- Working with SQLite databases in Flask
- Creating background jobs or scheduled tasks in Flask context
- Debugging Flask + subprocess integration issues

---

## Database Patterns

### Always Use Absolute Paths for SQLite Databases

**Problem:** Relative database paths fail when Flask is run from different working directories.

**Do:**
```python
import os
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(BASE_DIR, 'data', 'database.db')
app.config['SQLALCHEMY_DATABASE_URI'] = f'sqlite:///{DB_PATH}'
```

**Don't:**
```python
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///data/database.db'
```

**Rationale:** Flask can be started from any directory; absolute paths ensure database is always found. Common issue when:
- Running with Gunicorn vs direct `python app.py`
- Development vs deployment environments
- Cron jobs or systemd services

---

## Many-to-Many Sync Operations

### Use `merge()` for Many-to-Many Sync Logic

**Problem:** When syncing data where entities exist in multiple collections (e.g., videos in multiple playlists), direct `add()` fails with `UNIQUE constraint` errors.

**Do:**
```python
for video_data in videos_to_sync:
    video = Video(
        id=video_data['id'],
        title=video_data['title'],
        # ... other fields
        playlist_id=playlist_id
    )
    # merge() updates if exists, inserts if new
    db_session.merge(video)

db_session.commit()
```

**Don't:**
```python
for video_data in videos_to_sync:
    video = Video(...)
    db_session.add(video)  # Fails if video.id exists in another playlist
db_session.commit()
```

**Rationale:** `merge()` performs an upsert operation, checking for existing primary keys and updating rather than failing. Essential for many-to-many relationships where the same entity belongs to multiple parents.

**When to use:**
- Syncing external APIs to local database
- Importing data from multiple sources
- Weekly/periodic data refresh jobs
- Entity appears in multiple collections

---

## External API Integration

### Use Subprocess + curl Instead of `requests` for External API Calls

**Problem:** The Python `requests` library can hang indefinitely when called from Flask application context, even though it works fine in standalone scripts.

**Do:**
```python
import subprocess
import json

def fetch_playlist_videos(playlist_id):
    url = f"https://www.googleapis.com/youtube/v3/playlistItems"
    cmd = [
        'curl', '-s', url,
        '-d', f'part=snippet&playlistId={playlist_id}&maxResults=50&key={API_KEY}'
    ]
    result = subprocess.run(cmd, capture_output=True, text=True)
    return json.loads(result.stdout)
```

**Don't:**
```python
import requests

def fetch_playlist_videos(playlist_id):
    url = f"https://www.googleapis.com/youtube/v3/playlistItems"
    params = {
        'part': 'snippet',
        'playlistId': playlist_id,
        'maxResults': 50,
        'key': API_KEY
    }
    response = requests.get(url, params=params)  # May hang indefinitely
    return response.json()
```

**Rationale:** Flask's application context can interfere with `requests` library's async I/O handling, causing deadlocks. Subprocess calls avoid this issue entirely by running curl as an external process.

**Alternatives if subprocess is not acceptable:**
- Use `aiohttp` with async/await (requires async Flask routes)
- Consider `httpx` with explicit timeout and connection handling
- Test thoroughly in production Flask context before using `requests`

**Warning signs:**
- Request hangs but doesn't time out
- Works in script but fails when called from Flask route
- No error messages, process just stalls

---

## Background Jobs and Synchronization

### Validate Sync Logic with Clean Database

**Pattern:** Always test sync operations with an empty database before running in production.

**Do:**
```python
# Test setup
os.remove('data/database.db')
db.create_all()

# Run sync
sync_all(db_session, channel_id)

# Verify results
print(f"Synced {len(Playlist.query.all())} playlists")
print(f"Synced {len(Video.query.all())} videos")
```

**Rationale:** Sync bugs (like UNIQUE constraint errors) are easier to identify when starting from a clean state rather than trying to merge with existing data.

---

## Common Integration Pitfalls

### Environment Variables

**Pattern:** Never commit API keys or secrets. Use `.env` files with templates.

**File structure:**
```
backend/
  .env                # Contains actual secrets (gitignored)
  .env.example        # Template for setup (committed)
  app.py              # Loads from python-dotenv
```

**Do:**
```python
from dotenv import load_dotenv
load_dotenv()

API_KEY = os.getenv('YOUTUBE_API_KEY')
```

---

### Health Check Endpoints

**Pattern:** Always include a health check endpoint for monitoring.

**Do:**
```python
@app.route('/api/health')
def health():
    return jsonify({
        'status': 'healthy',
        'database': 'connected' if db.session else 'disconnected',
        'version': '1.0.0'
    })
```

**Rationale:** Enables monitoring, load balancer health checks, and quick debugging.

---

## Testing Strategy

### Test API Integration Before Frontend

**Pattern:** Verify all backend endpoints work before building UI.

**Do:**
```bash
# Test each endpoint
curl -s http://localhost:5003/api/health | jq
curl -s http://localhost:5003/api/playlists | jq
curl -s http://localhost:5003/api/playlists/1/videos | jq

# Test POST endpoints
curl -X POST http://localhost:5003/api/sync
```

**Rationale:** Catches backend issues before they're obscured by frontend complexity.

---

## Deployment Considerations

### Production Server: Gunicorn, Not Flask Development Server

**Do:**
```python
# gunicorn_config.py
bind = "127.0.0.1:5000"
workers = 4
timeout = 120
```

```bash
# Run with Gunicorn
gunicorn -c gunicorn_config.py app:app
```

**Don't:**
```bash
# Never in production
python app.py
```

**Rationale:** Flask's development server is single-threaded and not production-ready. Gunicorn provides proper process management, worker scaling, and signal handling.

---

## Related Skills

This skill complements:
- **python-tutor** - For general Python language questions
- **autoskill** - For learning and updating skill patterns

---

## Change Log

### v1.0.0 (2025-02-05)
- Initial skill creation based on YouTube Playlist Viewer project lessons
- Added patterns: absolute SQLite paths, merge() for many-to-many syncs, subprocess + curl for external APIs
- Added deployment and testing best practices
