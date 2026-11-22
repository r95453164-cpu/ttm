# Admin Panel (React)
# Панель управления TikTok Custom

import React, { useState, useEffect } from 'react';
import axios from 'axios';

const API_BASE = process.env.REACT_APP_API_ENDPOINT || 'https://api.ttm.local';

function App() {
  const [users, setUsers] = useState([]);
  const [emojis, setEmojis] = useState([]);
  const [status, setStatus] = useState('loading');

  useEffect(() => {
    // Загрузка данных с бэкенда
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      const res = await axios.get(`${API_BASE}/api/v1/health`);
      setStatus('online');
      // Загрузка пользователей и эмодзи для модерации
    } catch (err) {
      setStatus('offline');
    }
  };

  return (
    <div className="admin-panel">
      <header>
        <h1>TikTok Custom Admin Panel</h1>
        <span className={`status ${status}`}>{status.toUpperCase()}</span>
      </header>

      <main className="grid">
        <section className="card">
          <h2>Users ({users.length})</h2>
          <ul>
            {users.map(u => <li key={u.id}>{u.username}</li>)}
          </ul>
        </section>

        <section className="card">
          <h2>Emoji Moderation ({emojis.length})</h2>
          <div className="emoji-grid">
            {emojis.map(e => (
              <div key={e.id} className="emoji-item">
                <img src={e.image_url} alt="emoji" />
                <button onClick={() => approve(e.id)}>Approve</button>
                <button onClick={() => reject(e.id)}>Reject</button>
              </div>
            ))}
          </div>
        </section>

        <section className="card">
          <h2>Server Statistics</h2>
          <p>Latency: 45ms</p>
          <p>RU Connectivity: Stable</p>
        </section>
      </main>
    </div>
  );
}

function approve(id) { console.log('Approve', id); }
function reject(id) { console.log('Reject', id); }

export default App;
