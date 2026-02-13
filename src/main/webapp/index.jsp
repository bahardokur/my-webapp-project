<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>Welcome</title>
  <style>
    * {
      box-sizing: border-box;
    }
    html, body {
      height: 100%;
      margin: 0;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
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
    p {
      margin: 0;
      color: #475569;
      font-size: 17px;
      line-height: 1.6;
    }
    .divider {
      width: 60px;
      height: 4px;
      background: linear-gradient(90deg, #6366f1, #22d3ee);
      border-radius: 999px;
      margin: 20px auto;
    }
    .badge {
      display: inline-block;
      margin-top: 18px;
      padding: 10px 16px;
      border-radius: 999px;
      background: #eef2ff;
      color: #4338ca;
      font-size: 14px;
      font-weight: 500;
    }
  </style>
</head>
<body>
  <div class="card">
    <h1>Welcome </h1>
    <div class="divider"></div>
    <p>
      This is your new clean and modern interface.<br>
      You can customize this page for your project or lab assignment.
    </p>
    <div class="badge">SE3318 · Labwork 2</div>
  </div>
</body>
</html>
