<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>TODO List</title>

  <!-- Bootstrap Icons CDN -->
  <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

  <style>
    * {
      box-sizing: border-box;
    }
    html, body {
      height: 100%;
      margin: 0;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
                   Arial, sans-serif;
      background: linear-gradient(135deg, #f8fafc, #e0e7ff, #f1f5f9);
    }
    body {
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .card {
      width: min(560px, 92vw);
      padding: 40px 36px;
      border-radius: 18px;
      background: #ffffff;
      box-shadow: 0 20px 40px rgba(0,0,0,0.08);
      text-align: center;
    }
    h1 {
      margin: 0 0 12px;
      font-size: 42px;
      color: #1e293b;
    }
    .divider {
      width: 60px;
      height: 4px;
      background: linear-gradient(90deg, #6366f1, #22d3ee);
      border-radius: 999px;
      margin: 20px auto;
    }
    .todo-input {
      display: flex;
      gap: 8px;
      margin-bottom: 20px;
    }
    .todo-input input {
      flex: 1;
      padding: 8px 12px;
      border: 1px solid #ccc;
      border-radius: 6px;
      font-size: 16px;
    }
    .todo-input button {
      padding: 8px 16px;
      border: none;
      background: #6366f1;
      color: #fff;
      border-radius: 6px;
      cursor: pointer;
    }
    ul.todo-list {
      list-style: none;
      padding: 0;
      margin: 0;
      text-align: left;
    }
    ul.todo-list li {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 8px 0;
      border-bottom: 1px solid #eee;
    }
    ul.todo-list li .left {
      display: flex;
      align-items: center;
      gap: 8px;
    }
    ul.todo-list li .title {
      font-size: 16px;
      color: #475569;
    }
    ul.todo-list li .actions i {
      cursor: pointer;
      margin-left: 12px;
      color: #6b7280;
    }
    ul.todo-list li .actions i:hover {
      color: #374151;
    }
  </style>
</head>
<body>
  <div class="card">
    <h1>My TODOs</h1>
    <div class="divider"></div>

    <div class="todo-input">
      <input type="text" id="newTaskTitle" placeholder="Add new task…" />
      <button id="addBtn">Add</button>
    </div>

    <ul class="todo-list" id="taskList">
      <!-- tasks will be injected here -->
    </ul>
  </div>

  <script>
    const apiBase = '/my-webapp-project/api/tasks';

    document.addEventListener('DOMContentLoaded', () => {
      fetchTasks();

      document.getElementById('addBtn').addEventListener('click', () => {
        const input = document.getElementById('newTaskTitle');
        const title = input.value.trim();
        if (!title) return;
        fetch(apiBase, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ title })
        })
        .then(r => r.ok ? fetchTasks() : Promise.reject(r))
        .catch(err => {
          console.error('Add failed', err);
          alert('Could not add task');
        })
        .finally(() => input.value = '');
      });
    });

    function fetchTasks() {
      fetch(apiBase)
        .then(r => r.json())
        .then(renderList)
        .catch(err => {
          console.error('Fetch error', err);
          alert('Could not load tasks');
        });
    }

    function renderList(tasks) {
      const ul = document.getElementById('taskList');
      ul.innerHTML = '';
      tasks.forEach(t => {
        const li = document.createElement('li');
        li.dataset.id = t.id;
        li.dataset.title = t.title;
        li.dataset.completed = t.completed;

        li.innerHTML = `
          <div class="left">
            <input type="checkbox" ${t.completed ? 'checked' : ''}>
            <span class="title">${escapeHtml(t.title)}</span>
          </div>
          <div class="actions">
            <i class="bi bi-pencil"></i>
            <i class="bi bi-trash"></i>
          </div>
        `;
        // checkbox toggle
        li.querySelector('input').addEventListener('change', e => {
          updateTask(t.id, {
            title: t.title,
            completed: e.target.checked
          });
        });
        // delete
        li.querySelector('.bi-trash').addEventListener('click', () => {
          if (confirm('Delete this task?')) {
            fetch(`${apiBase}/${t.id}`, { method: 'DELETE' })
              .then(r => r.ok ? fetchTasks() : Promise.reject(r))
              .catch(err => {
                console.error('Delete error', err);
                alert('Could not delete task');
              });
          }
        });
        // edit
        li.querySelector('.bi-pencil').addEventListener('click', () => {
          const newTitle = prompt('New title', t.title);
          if (newTitle && newTitle.trim() && newTitle !== t.title) {
            updateTask(t.id, {
              title: newTitle.trim(),
              completed: t.completed
            });
          }
        });

        ul.appendChild(li);
      });
    }

    function updateTask(id, body) {
      fetch(`${apiBase}/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body)
      })
      .then(r => r.ok ? fetchTasks() : Promise.reject(r))
      .catch(err => {
        console.error('Update error', err);
        alert('Could not update task');
      });
    }

    function escapeHtml(s) {
      return s.replace(/&/g, "&amp;")
              .replace(/</g, "&lt;")
              .replace(/>/g, "&gt;")
              .replace(/"/g, "&quot;");
    }
  </script>
</body>
</html>
