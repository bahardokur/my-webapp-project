package com.todo.servlet;

import com.todo.dao.TaskDAO;
import com.todo.model.Task;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.BufferedReader;
import java.util.List;

@WebServlet("/api/tasks/*")
public class TasksServlet extends HttpServlet {
    private TaskDAO taskDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        taskDAO = new TaskDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            List<Task> tasks = taskDAO.getAllTasks();
            response.getWriter().write(gson.toJson(tasks));
        } else {
            try {
                int id = Integer.parseInt(pathInfo.substring(1));
                Task task = taskDAO.getTaskById(id);
                if (task != null) {
                    response.getWriter().write(gson.toJson(task));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().write("{\"error\": \"Task not found\"}");
                }
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Invalid task ID\"}");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");

        try {
            String body = getRequestBody(request);
            Task inputTask = gson.fromJson(body, Task.class);

            if (inputTask.getTitle() == null || inputTask.getTitle().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Title is required\"}");
                return;
            }

            Task createdTask = taskDAO.createTask(inputTask.getTitle());
            response.setStatus(HttpServletResponse.SC_CREATED);
            response.getWriter().write(gson.toJson(createdTask));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid request\"}");
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");

        try {
            String pathInfo = request.getPathInfo();
            int id = Integer.parseInt(pathInfo.substring(1));

            String body = getRequestBody(request);
            Task inputTask = gson.fromJson(body, Task.class);

            boolean updated = taskDAO.updateTask(id, inputTask.getTitle(), inputTask.isCompleted());
            if (updated) {
                Task task = taskDAO.getTaskById(id);
                response.getWriter().write(gson.toJson(task));
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\": \"Task not found\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid request\"}");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");

        try {
            String pathInfo = request.getPathInfo();
            int id = Integer.parseInt(pathInfo.substring(1));

            boolean deleted = taskDAO.deleteTask(id);
            if (deleted) {
                response.getWriter().write("{\"message\": \"Task deleted\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\": \"Task not found\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid task ID\"}");
        }
    }

    private String getRequestBody(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        return sb.toString();
    }
}