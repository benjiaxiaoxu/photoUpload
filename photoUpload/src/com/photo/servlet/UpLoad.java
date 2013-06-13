package com.photo.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jspsmart.upload.SmartUpload;
import com.jspsmart.upload.SmartUploadException;
import com.photo.bean.Photo;
import com.photo.bean.Users;
import com.photo.dao.UserDAO;
import com.photo.service.PhotoService;
import com.photo.util.Dbcon;

public class UpLoad extends HttpServlet {

	
	private static final long serialVersionUID = 1L;

	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		SmartUpload su = new SmartUpload();
		su.initialize(getServletConfig(), request, response);
		try {
			su.upload();
			String username = su.getRequest().getParameter("name") == null ?"":su.getRequest().getParameter("name") ;
			String password = su.getRequest().getParameter("password") == null ?"":su.getRequest().getParameter("password");
		
			String city = su.getRequest().getParameter("city")== null ?"":su.getRequest().getParameter("city");
			String prov = su.getRequest().getParameter("prov")== null ?"":su.getRequest().getParameter("prov");
			String county = su.getRequest().getParameter("county")== null ?"":su.getRequest().getParameter("county");
			Users user = new Users();
			user.setUsername(username);
			user.setPassword(password);
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			boolean isHas = new UserDAO().checkUser(user);
//			System.out.println(isHas);
			if(isHas){
				for(int i = 0;i < su.getFiles().getCount(); i++){
					com.jspsmart.upload.File myFile = su.getFiles().getFile(i);
					String fileName = myFile.getFileName();
					Photo photo = new Photo();
					photo.setFilename(fileName);
					photo.setCity(city);
					photo.setProv(prov);
					photo.setCounty(county);
					Date currentTime = new Date();
					SimpleDateFormat  formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					 String dateString = formatter.format(currentTime);
					photo.setFiledate(dateString);
					su.save("/upload");
					PhotoService ps = new PhotoService();
					ps.insert(photo, Dbcon.getCon());
					}
					out.println("Ok");
				
			}else{
			
				out.println("No");
			}
			out.flush();
			out.close();
			

		} catch (SmartUploadException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
	}

	/**
	 * Initialization of the servlet. <br>
	 *
	 * @throws ServletException if an error occurs
	 */
	public void init() throws ServletException {
		// Put your code here
	}

}
