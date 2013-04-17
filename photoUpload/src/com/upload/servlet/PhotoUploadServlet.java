package com.upload.servlet;

import java.io.File;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

public class PhotoUploadServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private ServletContext sc;
	private String savePath;

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);

	}


	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		DiskFileItemFactory factory = new DiskFileItemFactory();
		ServletFileUpload servletFileUpload = new ServletFileUpload(factory);
		
		try{
			List items = servletFileUpload.parseRequest(request);
			Iterator iterator = items.iterator();
			while(iterator.hasNext()){
				
				FileItem item = (FileItem) iterator.next();
				if(item.isFormField()){//表单
					System.out.println("文件名");
					System.out.println(item.getFieldName()+"  "+item.getString());
				}else{
					if(item.getName() != null && !item.getName().equals("")){//file
						System.out.println("文件名"+item.getName());
                        System.out.println("文件大小"+item.getSize());
                        System.out.println("文件类型"+item.getContentType());
                        
//                        File tempFile = new File(item.getName());//getName�õ����ļ���ư������ڿͻ��˵�·��
//                        File file = new File(sc.getRealPath("/")+savePath,tempFile.getName());
//                        item.write(file);
                        System.out.println("sus");
                    }else{
                    	System.out.println("fal");
                    }
					
				}
				
			}
		}catch (Exception e) {
			// TODO: handle exception
		}
		
	}

	@Override
	public void init(ServletConfig config) throws ServletException {
		// TODO Auto-generated method stub
		savePath = config.getInitParameter("savePath");
		sc = config.getServletContext();
	}

}
