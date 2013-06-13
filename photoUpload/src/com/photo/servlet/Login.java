package com.photo.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.photo.bean.Users;
import com.photo.dao.UserDAO;

public class Login extends HttpServlet {

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;


	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String name = request.getParameter("username") == null ?"" :request.getParameter("username");
		String pass = request.getParameter("password") == null ?"":request.getParameter("password");
		Users user = new Users();
		user.setUsername(name);
		user.setPassword(pass);
		if(new UserDAO().checkUser(user)){
			request.getRequestDispatcher("/servlet/Show").forward(request, response);
		}else{
			response.sendRedirect("/Upload/index.jsp");
		}
		
	}


}
